/**
 * InitAliceDHRatchetUseCase - 初始化 Alice 端 DH 棘轮
 *
 * 职责：
 *  - Alice 发起会话时初始化 DH 棘轮
 *  - 生成本地临时密钥对
 *  - 计算发送链根密钥和链密钥
 *  - 更新 SessionRecord
 *
 * 架构流向：
 *   ViewModel → InitAliceDHRatchetUseCase → SessionRecordDao + ECCExchangeHelper + HKDFUtil
 */
import { ArrayUtil, BaseUseCase } from 'static_library_common';
import { Log } from 'static_library_common';
import { HexUtil } from 'static_library_common';
import { DarcyIMDatabase, SessionRecordEntity } from 'library_database';
import { ECCExchangeUtil, EncryptUtil } from 'library_crypto';
import { HKDF1 } from 'library_crypto/src/main/ets/x3dh/chain/HKDF1';
import { ChainKey } from 'library_crypto/src/main/ets/x3dh/chain/ChainKey';

/**
 * Alice DH 棘轮初始化入参
 */
export interface InitAliceDHRatchetParams {
  /** Alice 用户 ID */
  aliceUserId: number;
  /** Bob 用户 ID */
  bobUserId: number;
  /** Bob 签名预公钥（hex 字符串） */
  bobSignedPreKey: string;
}

/**
 * 初始化 Alice 端 DH 棘轮
 *
 * 返回 boolean：是否成功
 */
export class InitAliceDHRatchetUseCase extends BaseUseCase<InitAliceDHRatchetParams, boolean> {

  async execute(params: InitAliceDHRatchetParams): Promise<boolean> {
    const sessionRecordDao = await DarcyIMDatabase.getInstance().getSessionRecordDao();
    const localUserId = params.aliceUserId;
    const remoteUserId = params.bobUserId;
    const bobSignedPreKey = params.bobSignedPreKey;

    // 校验参数
    if (!localUserId) {
      throw new Error('aliceUserId 不能为空');
    }
    if (!remoteUserId) {
      throw new Error('bobUserId 不能为空');
    }
    if (!bobSignedPreKey) {
      throw new Error('bobSignedPreKey 不能为空');
    }

    // 获取会话记录
    const sessionRecord = await sessionRecordDao.getByUserPair(localUserId, remoteUserId);
    if (!sessionRecord) {
      throw new Error('sessionRecord 不存在');
    }

    const K1 = sessionRecord.rootKey;

    // Alice 初始化 DH 棘轮
    Log.warn(`$localUserId DH 棘轮步进开始`);

    // 生成新的本地临时密钥对
    const localEphemeralKey = await ECCExchangeUtil.generateKeyPair();
    if (localEphemeralKey == null) {
      throw new Error('生成本地临时密钥对 localEphemeralKey 失败');
    }
    const newLocalEphemeralPrivateKey = ECCExchangeUtil.getKeyBytes(localEphemeralKey?.priKey);
    const newLocalEphemeralPublicKey = ECCExchangeUtil.getKeyBytes(localEphemeralKey?.pubKey);

    EncryptUtil.log(`$localUserId 本地新公钥:`, newLocalEphemeralPublicKey);
    EncryptUtil.log(`$localUserId DH 新私钥:`, newLocalEphemeralPrivateKey);
    Log.log(`$localUserId DH 公钥: ${bobSignedPreKey}`);

    // 计算 DH 共享密钥
    const sendingNewDHSharedSecret = await ECCExchangeUtil.getSharedSecretByUintArrays(
      newLocalEphemeralPrivateKey,
      HexUtil.hexToBytes(bobSignedPreKey),
    );

    Log.warn(`$localUserId DH 棘轮步进完成 ${HexUtil.bytesToHex(sendingNewDHSharedSecret)}`);

    // HKDF 派生新的根密钥和发送链密钥
    const hkdf = new HKDF1();
    const sendingDHRatchetResult = hkdf.deriveSecrets(
      sendingNewDHSharedSecret,
      HexUtil.hexToBytes(K1),
      ArrayUtil.stringToBytes('DHInfo'),
      64,
    );

    const sendingPair = EncryptUtil.splitArray64(sendingDHRatchetResult, 32);
    const sendingNewRootKey = sendingPair[0];
    EncryptUtil.log(`$localUserId 根密钥(新):`, sendingNewRootKey);

    const sendingNewChainKey = sendingPair[1];
    EncryptUtil.log(`$localUserId 发送链初始化密钥:`, sendingNewChainKey);

    const sendingChain = new ChainKey(sendingNewChainKey, 0);
    EncryptUtil.log(`$localUserId 发送链密钥:`, sendingChain.getKey());

    // 更新会话记录
    const updatedCount = await sessionRecordDao.update(
      new SessionRecordEntity(
        sessionRecord.id,
        sessionRecord.localUserId,
        sessionRecord.remoteUserId,
        sessionRecord.remoteIdentityKey,
        sessionRecord.remoteDHKey,
        HexUtil.bytesToHex(newLocalEphemeralPrivateKey),
        HexUtil.bytesToHex(newLocalEphemeralPublicKey),
        HexUtil.bytesToHex(sendingNewRootKey),
        HexUtil.bytesToHex(sendingChain.getKey()),
        sessionRecord.receivingChainKey,
        sessionRecord.receivingChainIndex,
        sessionRecord.N,
        sessionRecord.PN,
        sessionRecord.createdTime,
        Date.now().toString(),
      ),
    );

    if (updatedCount > 0) {
      Log.log(`$localUserId Alice DH 棘轮初始化成功`);
      return true;
    }
    throw new Error('更新 sessionRecord 失败');
  }
}
