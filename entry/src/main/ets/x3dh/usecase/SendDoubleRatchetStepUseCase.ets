/**
 * SendDoubleRatchetStepUseCase - 发送端 Double Ratchet 步进
 *
 * 职责：
 *  - 发送消息时进行链密钥演进
 *  - 推导消息密钥三元组 (messageKey, macKey, iv)
 *  - 更新 SessionRecord 发送链状态
 *
 * 架构流向：
 *   ViewModel → SendDoubleRatchetStepUseCase → SessionRecordDao + ChainKey + EncryptUtil
 */
import { BaseUseCase } from 'static_library_common';
import { Log } from 'static_library_common';
import { HexUtil } from 'static_library_common';
import { DarcyIMDatabase, SessionRecordEntity } from 'library_database';
import { EncryptUtil } from 'library_crypto';
import { MessageKey } from 'library_crypto/src/main/ets/x3dh/model/MessageKey';
import { ChainKey } from 'library_crypto/src/main/ets/x3dh/chain/ChainKey';

/**
 * 发送 Double Ratchet 步进入参
 */
export interface SendDoubleRatchetStepParams {
  /** 本地用户 ID */
  localUserId: number;
  /** 远程用户 ID */
  remoteUserId: number;
}

/**
 * 发送端 Double Ratchet 步进
 *
 * 返回 MessageKey（包含消息加密所需的所有密钥材料）
 */
export class SendDoubleRatchetStepUseCase extends BaseUseCase<SendDoubleRatchetStepParams, MessageKey> {
  private sessionRecordDao = DarcyIMDatabase.getInstance().getSessionRecordDao();

  async execute(params: SendDoubleRatchetStepParams): Promise<MessageKey> {
    const localUserId = params.localUserId;
    const remoteUserId = params.remoteUserId;

    // 校验参数
    if (!localUserId) {
      throw new Error('localUserId 不能为空');
    }
    if (!remoteUserId) {
      throw new Error('remoteUserId 不能为空');
    }

    // 获取会话记录
    const sessionRecord = await this.sessionRecordDao.getByUserPair(localUserId, remoteUserId);
    if (!sessionRecord) {
      throw new Error('sessionRecord 不存在');
    }

    const lastRootKey = HexUtil.hexToBytes(sessionRecord.rootKey);
    EncryptUtil.log(`$localUserId 根密钥:`, lastRootKey);

    const remoteDHKey = HexUtil.hexToBytes(sessionRecord.remoteDHKey);
    const localEphemeralPrivateKey = HexUtil.hexToBytes(sessionRecord.localEphemeralPrivateKey);
    const localEphemeralPublicKey = HexUtil.hexToBytes(sessionRecord.localEphemeralPublicKey);

    EncryptUtil.log(`$localUserId 本地公钥:`, localEphemeralPublicKey);
    EncryptUtil.log(`$localUserId DH 私钥:`, localEphemeralPrivateKey);
    EncryptUtil.log(`$localUserId DH 公钥:`, remoteDHKey);

    // 发送链无需 DH 步进
    const newN: number = sessionRecord.N + 1;
    const newPN: number = sessionRecord.PN;

    Log.warn(`$localUserId DH 棘轮无需步进:`);
    Log.log(`$localUserId 发送链索引: N=$newN, PN=$newPN`);

    // 演进发送链密钥
    const currentChainKey = new ChainKey(
      HexUtil.hexToBytes(sessionRecord.sendingChainKey),
      sessionRecord.N,
    );
    const newSendingChainKey = currentChainKey.getNextChainKey();

    EncryptUtil.log(`$localUserId 发送链密钥:`, newSendingChainKey.getKey());

    // 更新会话记录
    await this.sessionRecordDao.update(
      new SessionRecordEntity(
        sessionRecord.id,
        sessionRecord.localUserId,
        sessionRecord.remoteUserId,
        sessionRecord.remoteIdentityKey,
        sessionRecord.remoteDHKey,
        sessionRecord.localEphemeralPrivateKey,
        sessionRecord.localEphemeralPublicKey,
        sessionRecord.rootKey,
        HexUtil.bytesToHex(newSendingChainKey.getKey()),
        sessionRecord.receivingChainKey,
        sessionRecord.receivingChainIndex,
        newN,
        newPN,
        sessionRecord.createdTime,
        Date.now().toString(),
      ),
    );

    // 派生消息密钥三元组
    const messageKeyTriple = newSendingChainKey.getMessageKeyTriple();
    const messageKeyBytes = messageKeyTriple[0];
    const macKeyBytes = messageKeyTriple[1];
    const ivBytes = messageKeyTriple[2];

    EncryptUtil.logI(`$localUserId 发送 $remoteUserId 的消息密钥:`, messageKeyBytes);

    return new MessageKey(
      localUserId,
      remoteUserId,
      HexUtil.bytesToHex(localEphemeralPublicKey),
      HexUtil.bytesToHex(messageKeyBytes),
      HexUtil.bytesToHex(macKeyBytes),
      HexUtil.bytesToHex(ivBytes),
      newN,
      newPN,
      '/private',
    );
  }
}
