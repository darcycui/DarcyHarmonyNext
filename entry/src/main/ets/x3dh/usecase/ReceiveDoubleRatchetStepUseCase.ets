/**
 * ReceiveDoubleRatchetStepUseCase - 接收端 Double Ratchet 步进
 *
 * 职责：
 *  - 接收消息时进行 DH 棘轮步进判断和链密钥演进
 *  - 处理乱序消息（跳过密钥缓存/恢复）
 *  - 推导消息密钥三元组
 *  - 更新 SessionRecord 接收链状态
 *
 * 架构流向：
 *   ViewModel → ReceiveDoubleRatchetStepUseCase → SessionRecordDao + SkippedMessageKeyDao + ChainKey + ECCExchangeHelper + HKDF1
 *
 * 这是 Double Ratchet 协议的核心接收逻辑，包含：
 * - DH 棘轮步进（当远程 DH 公钥变化时）
 * - 接收链密钥演进
 * - 跳过消息密钥的缓存与恢复
 */
import { ArrayUtil, BaseUseCase } from 'static_library_common';
import { Log } from 'static_library_common';
import { HexUtil } from 'static_library_common';
import {
  DarcyIMDatabase,
  SessionRecordDao,
  SessionRecordEntity,
  SkippedMessageKeyDao,
  SkippedMessageKeyEntity,
} from 'library_database';
import { ECCExchangeUtil, EncryptUtil } from 'library_crypto';
import { MessageKey } from 'library_crypto/src/main/ets/x3dh/model/MessageKey';
import { HKDF1 } from 'library_crypto/src/main/ets/x3dh/chain/HKDF1';
import { ChainKey } from 'library_crypto/src/main/ets/x3dh/chain/ChainKey';

/**
 * 接收 Double Ratchet 步进入参
 */
export interface ReceiveDoubleRatchetStepParams {
  /** 本地用户 ID */
  localUserId: number;
  /** 远程用户 ID */
  remoteUserId: number;
  /** 远程 DH 公钥（Uint8Array） */
  remoteDHKey: Uint8Array;
  /** 消息 ID */
  msgId: string;
  /** 发送链消息序号 N */
  N_KEY: number;
  /** 前一个发送链长度 PN */
  PN_KEY: number;
}

/**
 * 接收端 Double Ratchet 步进
 *
 * 返回 MessageKey（包含消息解密所需的所有密钥材料）
 */
export class ReceiveDoubleRatchetStepUseCase extends BaseUseCase<ReceiveDoubleRatchetStepParams, MessageKey> {
  private sessionRecordDao!: SessionRecordDao;
  private skippedMessageKeyDao!: SkippedMessageKeyDao;

  async execute(params: ReceiveDoubleRatchetStepParams): Promise<MessageKey> {
    this.sessionRecordDao = await DarcyIMDatabase.getInstance().getSessionRecordDao();
    this.skippedMessageKeyDao = await DarcyIMDatabase.getInstance().getSkippedMessageKeyDao();
    const localUserId = params.localUserId;
    const remoteUserId = params.remoteUserId;
    const remoteDHKey = params.remoteDHKey;
    const msgId = params.msgId;
    const N = params.N_KEY;
    const PN = params.PN_KEY;

    // 校验参数
    if (!localUserId) throw new Error('localUserId 不能为空');
    if (!remoteUserId) throw new Error('remoteUserId 不能为空');
    if (!remoteDHKey || remoteDHKey.length === 0) throw new Error('remoteDHKey 不能为空');
    if (!msgId) throw new Error('msgId 不能为空');
    if (N === undefined || N === null) throw new Error('N (消息序号) 不能为空');
    if (PN === undefined || PN === null) throw new Error('PN (前一链长度) 不能为空');

    // 获取会话记录
    const sessionRecord = await this.sessionRecordDao.getByUserPair(localUserId, remoteUserId);
    if (!sessionRecord) {
      throw new Error('sessionRecord 不存在');
    }

    Log.log(`$localUserId 收到消息 - 消息ID:$msgId, N=$N, PN=$PN, 当前接收链索引:${sessionRecord.receivingChainIndex}`);

    // 判断是否需要 DH 步进
    const needsDHStep = await this.needDHStep(remoteDHKey, sessionRecord.remoteDHKey);

    if (needsDHStep) {
      Log.warn(`$localUserId 需要进行 DH棘轮步进`);
      Log.log(`$localUserId 顺序或未来消息，处理并缓存跳过密钥`);
      return await this.handleInOrderMessageWithDH(
        localUserId, remoteUserId, msgId,
        sessionRecord, remoteDHKey, N, PN,
      );
    } else {
      Log.warn(`$localUserId 不需要进行 DH棘轮步进`);
      if (N > sessionRecord.receivingChainIndex) {
        Log.log(`$localUserId 顺序或未来消息，处理并缓存跳过密钥`);
        return await this.handleInOrderMessage(
          localUserId, remoteUserId, msgId,
          sessionRecord, remoteDHKey, N, PN,
        );
      } else {
        Log.warn(`$localUserId 跳过的消息 (N:$N <= 当前:${sessionRecord.receivingChainIndex})`);
        return await this.handleSkippedMessage(
          localUserId, remoteUserId, msgId,
          sessionRecord, remoteDHKey, N,
        );
      }
    }
  }

  /**
   * 处理跳过的消息（从缓存中恢复密钥）
   */
  private async handleSkippedMessage(
    localUserId: number,
    remoteUserId: number,
    msgId: string,
    sessionRecord: SessionRecordEntity,
    remoteDHKey: Uint8Array,
    N: number,
  ): Promise<MessageKey> {
    const remoteDHKeyHex = HexUtil.bytesToHex(remoteDHKey);
    const skippedKeys = await this.skippedMessageKeyDao.getByDhPublicKeyAndChainIndex(remoteDHKeyHex, N);

    if (skippedKeys.length > 0) {
      const skippedKey = skippedKeys[0];
      Log.log(`$localUserId 找到已保存的跳过的消息密钥 - 消息ID:$msgId, 索引:$N`);

      const messageKey = new MessageKey(
        remoteUserId,
        localUserId,
        skippedKey.dhPublicKey,
        skippedKey.messageKey,
        skippedKey.macKey,
        skippedKey.iv,
      );

      Log.log(`消息密钥:${messageKey.messageKey}`);
      Log.log(`MAC密钥:${messageKey.macKey}`);
      Log.log(`IV:${messageKey.iv}`);

      return messageKey;
    } else {
      Log.warn(`$localUserId 消息已过期或重复，且无缓存密钥 索引:$N`);
      throw new Error(`消息已过期或重复，且无缓存密钥 索引:$N`);
    }
  }

  /**
   * 处理需要 DH 步进的顺序消息
   */
  private async handleInOrderMessageWithDH(
    localUserId: number,
    remoteUserId: number,
    msgId: string,
    sessionRecord: SessionRecordEntity,
    remoteDHKey: Uint8Array,
    N: number,
    PN: number,
  ): Promise<MessageKey> {
    const lastRootKey = HexUtil.hexToBytes(sessionRecord.rootKey);
    const hkdf = new HKDF1();

    // 缓存旧链的跳过密钥
    await this.cacheSkippedMessageKeysForDHStep(
      localUserId, remoteUserId, sessionRecord, N, PN,
    );

    const localEphemeralPrivateKey = HexUtil.hexToBytes(sessionRecord.localEphemeralPrivateKey);
    const localEphemeralPublicKey = HexUtil.hexToBytes(sessionRecord.localEphemeralPublicKey);

    Log.warn(`$localUserId DH 棘轮步进开始`);
    Log.log(`$localUserId 对方发送链信息: N=$N, PN=$PN`);
    EncryptUtil.log(`$localUserId 本地公钥:`, localEphemeralPublicKey);
    EncryptUtil.log(`$localUserId DH 私钥:`, localEphemeralPrivateKey);
    EncryptUtil.log(`$localUserId DH 公钥:`, remoteDHKey);

    // 计算新的 DH 共享密钥
    const receivingNewDHSharedSecret = await ECCExchangeUtil.getSharedSecretByUintArrays(
      localEphemeralPrivateKey, remoteDHKey,
    );
    Log.log(`$localUserId DH 棘轮步进完成 ${HexUtil.bytesToHex(receivingNewDHSharedSecret)}`);
    EncryptUtil.log(`$localUserId 根密钥(旧):`, lastRootKey);

    // HKDF 派生新的根密钥和接收链密钥
    const receivingDHRatchetResult = hkdf.deriveSecrets(
      receivingNewDHSharedSecret,
      lastRootKey,
      ArrayUtil.stringToBytes('DHInfo'),
      64,
    );

    const receivingPair = EncryptUtil.splitArray64(receivingDHRatchetResult, 32);
    const receivingNewRootKey = receivingPair[0];
    EncryptUtil.log(`$localUserId 根密钥(新):`, receivingNewRootKey);

    const receivingNewChainKey = receivingPair[1];
    EncryptUtil.log(`$localUserId 接收链初始化密钥:`, receivingNewChainKey);

    let currentReceiverChainKey = new ChainKey(receivingNewChainKey, 0);

    // 处理跳过的消息密钥（新链中 N > 0 时）
    const skippedCount = N - 1;
    if (skippedCount > 0) {
      Log.error(`$localUserId 新接收链需要跳过 $skippedCount 个消息密钥 (索引 0 到 ${skippedCount - 1})`);
      currentReceiverChainKey = await this.cacheSkippedKeysForCurrentChain(
        localUserId, remoteUserId,
        currentReceiverChainKey, skippedCount,
        HexUtil.bytesToHex(remoteDHKey),
      );
    }

    // 演进接收链获取消息密钥
    const receiverChain = currentReceiverChainKey.getNextChainKey();
    EncryptUtil.log(`$localUserId 接收链密钥:`, receiverChain.getKey());

    const messageKeyTriple = receiverChain.getMessageKeyTriple();
    const messageKeyBytes = messageKeyTriple[0];
    const macKeyBytes = messageKeyTriple[1];
    const ivBytes = messageKeyTriple[2];

    EncryptUtil.logI(`$localUserId 接收 $remoteUserId 的消息密钥:`, messageKeyBytes);
    EncryptUtil.logI(`$localUserId 接收 $remoteUserId 的MAC密钥:`, macKeyBytes);
    EncryptUtil.logI(`$localUserId 接收 $remoteUserId 的IV:`, ivBytes);

    const messageKey = new MessageKey(
      remoteUserId,
      localUserId,
      HexUtil.bytesToHex(localEphemeralPublicKey),
      HexUtil.bytesToHex(messageKeyBytes),
      HexUtil.bytesToHex(macKeyBytes),
      HexUtil.bytesToHex(ivBytes),
    );

    // 更新会话记录（接收链状态）
    await this.sessionRecordDao.update(
      new SessionRecordEntity(
        sessionRecord.id,
        sessionRecord.localUserId,
        sessionRecord.remoteUserId,
        sessionRecord.remoteIdentityKey,
        HexUtil.bytesToHex(remoteDHKey),
        sessionRecord.localEphemeralPrivateKey,
        sessionRecord.localEphemeralPublicKey,
        HexUtil.bytesToHex(receivingNewRootKey),
        sessionRecord.sendingChainKey,
        HexUtil.bytesToHex(receiverChain.getKey()),
        N,
        sessionRecord.N,
        sessionRecord.PN,
        sessionRecord.createdTime,
        Date.now().toString(),
      ),
    );

    Log.log(`$localUserId 处理消息成功 - 索引:$N, 消息ID:$msgId`);

    // === 发送端 DH 步进 ===
    Log.warn(`$localUserId DH 棘轮步进开始（发送端）`);
    const localEphemeralKey = await ECCExchangeUtil.generateKeyPair();
    if (localEphemeralKey == null) {
      throw new Error('本地 ephemeral key 生成失败');
    }
    const newLocalEphemeralPrivateKey = (ECCExchangeUtil.getPriKeyBytes(localEphemeralKey!.priKey));
    const newLocalEphemeralPublicKey = (ECCExchangeUtil.getPubKeyBytes(localEphemeralKey!.pubKey));

    EncryptUtil.log(`$localUserId 本地新公钥:`, newLocalEphemeralPublicKey);
    EncryptUtil.log(`$localUserId DH 新私钥:`, newLocalEphemeralPrivateKey);
    EncryptUtil.log(`$localUserId DH 公钥:`, remoteDHKey);

    const sendingNewDHSharedSecret = await ECCExchangeUtil.getSharedSecretByUintArrays(
      newLocalEphemeralPrivateKey, remoteDHKey,
    );
    Log.warn(`$localUserId DH 棘轮步进完成 ${HexUtil.bytesToHex(sendingNewDHSharedSecret)}`);
    EncryptUtil.log(`$localUserId 根密钥(旧):`, receivingNewRootKey);

    // HKDF 派生发送链
    const sendingDHRatchetResult = hkdf.deriveSecrets(
      sendingNewDHSharedSecret,
      receivingNewRootKey,
      ArrayUtil.stringToBytes('DHInfo'),
      64,
    );

    const sendingPair = EncryptUtil.splitArray64(sendingDHRatchetResult, 32);
    const sendingNewRootKey = sendingPair[0];
    EncryptUtil.log(`$localUserId 根密钥(新):`, sendingNewRootKey);

    const sendingNewChainKey = sendingPair[1];
    EncryptUtil.log(`$localUserId 发送链初始化密钥:`, sendingNewChainKey);

    const senderChain = new ChainKey(sendingNewChainKey, 0);
    EncryptUtil.log(`$localUserId 发送链密钥:`, senderChain.getKey());

    // 更新会话记录（发送链状态）
    await this.sessionRecordDao.update(
      new SessionRecordEntity(
        sessionRecord.id,
        sessionRecord.localUserId,
        sessionRecord.remoteUserId,
        sessionRecord.remoteIdentityKey,
        HexUtil.bytesToHex(remoteDHKey),
        HexUtil.bytesToHex(newLocalEphemeralPrivateKey),
        HexUtil.bytesToHex(newLocalEphemeralPublicKey),
        HexUtil.bytesToHex(sendingNewRootKey),
        HexUtil.bytesToHex(senderChain.getKey()),
        HexUtil.bytesToHex(receiverChain.getKey()),
        N,
        0,
        sessionRecord.N,
        sessionRecord.createdTime,
        Date.now().toString(),
      ),
    );

    return messageKey;
  }

  /**
   * 处理不需要 DH 步进的顺序消息
   */
  private async handleInOrderMessage(
    localUserId: number,
    remoteUserId: number,
    msgId: string,
    sessionRecord: SessionRecordEntity,
    remoteDHKey: Uint8Array,
    N: number,
    PN: number,
  ): Promise<MessageKey> {
    const localEphemeralPublicKeyBytes = HexUtil.hexToBytes(sessionRecord.localEphemeralPublicKey);

    Log.warn(`$localUserId DH 棘轮无需步进`);

    const currentChainIndex = sessionRecord.receivingChainIndex + 1;
    const skippedCount = N - currentChainIndex;

    let currentReceivingChainKey = new ChainKey(
      HexUtil.hexToBytes(sessionRecord.receivingChainKey),
      sessionRecord.receivingChainIndex,
    );

    // 处理跳过的消息密钥
    if (skippedCount > 0) {
      Log.error(`$localUserId 当前接收链需要跳过 $skippedCount 个消息密钥 (索引 $currentChainIndex 到 ${N - 1})`);
      currentReceivingChainKey = await this.cacheSkippedKeysForCurrentChain(
        localUserId, remoteUserId,
        currentReceivingChainKey, skippedCount,
        sessionRecord.remoteDHKey,
      );
    }

    const localEphemeralPrivateKey = HexUtil.hexToBytes(sessionRecord.localEphemeralPrivateKey);
    const localEphemeralPublicKey = HexUtil.hexToBytes(sessionRecord.localEphemeralPublicKey);

    EncryptUtil.log(`$localUserId 本地公钥:`, localEphemeralPublicKey);
    EncryptUtil.log(`$localUserId DH 私钥:`, localEphemeralPrivateKey);
    EncryptUtil.log(`$localUserId DH 公钥:`, remoteDHKey);

    // 演进接收链获取消息密钥
    const newReceivingChainKey = currentReceivingChainKey.getNextChainKey();
    EncryptUtil.log(`$localUserId 接收链密钥:`, newReceivingChainKey.getKey());

    const messageKeyTriple = newReceivingChainKey.getMessageKeyTriple();
    const messageKeyBytes = messageKeyTriple[0];
    const macKeyBytes = messageKeyTriple[1];
    const ivBytes = messageKeyTriple[2];

    EncryptUtil.logI(`$localUserId 接收 $remoteUserId 的消息密钥:`, messageKeyBytes);
    EncryptUtil.logI(`$localUserId 接收 $remoteUserId 的MAC密钥:`, macKeyBytes);
    EncryptUtil.logI(`$localUserId 接收 $remoteUserId 的IV:`, ivBytes);

    const messageKey = new MessageKey(
      remoteUserId,
      localUserId,
      HexUtil.bytesToHex(localEphemeralPublicKeyBytes),
      HexUtil.bytesToHex(messageKeyBytes),
      HexUtil.bytesToHex(macKeyBytes),
      HexUtil.bytesToHex(ivBytes),
    );

    Log.log(`$localUserId 处理消息成功 - 索引:$N, 消息ID:$msgId`);

    // 更新会话记录
    await this.sessionRecordDao.update(
      new SessionRecordEntity(
        sessionRecord.id,
        sessionRecord.localUserId,
        sessionRecord.remoteUserId,
        sessionRecord.remoteIdentityKey,
        HexUtil.bytesToHex(remoteDHKey),
        sessionRecord.localEphemeralPrivateKey,
        sessionRecord.localEphemeralPublicKey,
        sessionRecord.rootKey,
        sessionRecord.sendingChainKey,
        HexUtil.bytesToHex(newReceivingChainKey.getKey()),
        N,
        sessionRecord.N,
        sessionRecord.PN,
        sessionRecord.createdTime,
        Date.now().toString(),
      ),
    );

    return messageKey;
  }

  /**
   * DH 步进前缓存旧接收链的跳过密钥
   */
  private async cacheSkippedMessageKeysForDHStep(
    localUserId: number,
    remoteUserId: number,
    sessionRecord: SessionRecordEntity,
    N: number,
    PN: number,
  ): Promise<void> {
    const currentReceivingChainLength = sessionRecord.receivingChainIndex + 1;
    const oldChainSkipCount = PN - currentReceivingChainLength;

    if (oldChainSkipCount > 0) {
      Log.error(`$localUserId 旧接收链需要跳过 $oldChainSkipCount 个消息密钥`);
      let oldChainKey = new ChainKey(
        HexUtil.hexToBytes(sessionRecord.receivingChainKey),
        sessionRecord.receivingChainIndex,
      );
      oldChainKey = await this.cacheSkippedKeysForCurrentChain(
        localUserId, remoteUserId,
        oldChainKey, oldChainSkipCount,
        sessionRecord.remoteDHKey,
      );
    } else {
      Log.log(`$localUserId 旧接收链无需跳过消息`);
    }
  }

  /**
   * 缓存当前链中跳过的消息密钥
   */
  private async cacheSkippedKeysForCurrentChain(
    localUserId: number,
    remoteUserId: number,
    startChainKey: ChainKey,
    skipCount: number,
    dhPublicKey: string,
  ): Promise<ChainKey> {
    let chainKey = startChainKey;
    const skippedEntities: SkippedMessageKeyEntity[] = [];

    for (let i = 0; i < skipCount; i++) {
      chainKey = chainKey.getNextChainKey();
      const keyTriple = chainKey.getMessageKeyTriple();
      const messageKey = keyTriple[0];
      const macKey = keyTriple[1];
      const iv = keyTriple[2];

      const entity = new SkippedMessageKeyEntity(
        undefined,
        localUserId,
        remoteUserId,
        '',
        dhPublicKey,
        chainKey.getIndex(),
        HexUtil.bytesToHex(messageKey),
        HexUtil.bytesToHex(macKey),
        HexUtil.bytesToHex(iv),
        Date.now().toString(),
      );
      skippedEntities.push(entity);

      Log.log(
        `$localUserId 缓存跳过密钥 - DH:${dhPublicKey.substring(0, 16)}... ` +
        `messageKey:${HexUtil.bytesToHex(messageKey).substring(0, 16)}..., 索引:${chainKey.getIndex()}`,
      );
    }

    if (skippedEntities.length > 0) {
      await this.skippedMessageKeyDao.insertBatch(skippedEntities);
      Log.log(`$localUserId 已缓存 ${skippedEntities.length} 个跳过消息密钥`);
    }

    return chainKey;
  }

  /**
   * 判断是否需要 DH 棘轮步进
   */
  private async needDHStep(newRemoteDHKey: Uint8Array, localRemoteDHKey: string): Promise<boolean> {
    const newRemoteDHKeyHex = HexUtil.bytesToHex(newRemoteDHKey);
    return newRemoteDHKeyHex.length > 0 && newRemoteDHKeyHex !== localRemoteDHKey;
  }
}
