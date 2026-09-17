/**
 * CalculateBobX3DHKeyUseCase - 计算 Bob 端 X3DH 密钥
 *
 * 职责：
 *  - 根据 Bob 本地私钥材料和 Alice 公钥计算 X3DH 共享密钥
 *  - 返回 x3DHKey (64 字节)
 *
 * 架构流向：
 *   ViewModel → CalculateBobX3DHKeyUseCase → IdentityKeyDao + SignedPreKeyDao + OneTimePreKeyDao + ECCExchangeHelper + HKDFUtil
 */
import { ArrayUtil, BaseUseCase } from 'static_library_common';
import { Log } from 'static_library_common';
import { HexUtil } from 'static_library_common';
import { DarcyIMDatabase } from 'library_database';
import { ECCExchangeHelper, HKDFUtil, EncryptUtil } from 'library_crypto';

/**
 * Bob X3DH 密钥计算入参
 */
export interface CalculateBobX3DHKeyParams {
  /** Bob 用户 ID */
  bobUserId: number;
  /** Alice 身份公钥（hex 字符串） */
  aliceIdentityKey: string;
  /** Alice 临时公钥（hex 字符串） */
  aliceEphemeralKey: string;
  /** Bob 使用的一次性预密钥 ID */
  bobOneTimePreKeyId: string;
}

/**
 * 计算 Bob 端 X3DH 密钥
 *
 * 返回 Uint8Array：x3DHKey (64 字节)
 */
export class CalculateBobX3DHKeyUseCase extends BaseUseCase<CalculateBobX3DHKeyParams, Uint8Array> {
  private identityKeyDao = DarcyIMDatabase.getInstance().getIdentityKeyDao();
  private signedPreKeyDao = DarcyIMDatabase.getInstance().getSignedPreKeyDao();
  private oneTimePreKeyDao = DarcyIMDatabase.getInstance().getOneTimePreKeyDao();

  async execute(params: CalculateBobX3DHKeyParams): Promise<Uint8Array> {
    const bobUserId = params.bobUserId;
    const aliceIdentityKey = params.aliceIdentityKey;
    const aliceEphemeralKey = params.aliceEphemeralKey;
    const bobOneTimePreKeyId = params.bobOneTimePreKeyId;

    // 校验参数
    if (!bobUserId) {
      throw new Error('bobUserId 不能为空');
    }
    if (!aliceIdentityKey) {
      throw new Error('aliceIdentityKey 不能为空');
    }
    if (!aliceEphemeralKey) {
      throw new Error('aliceEphemeralKey 不能为空');
    }
    if (!bobOneTimePreKeyId) {
      throw new Error('bobOneTimePreKeyId 不能为空');
    }

    // 获取 Bob 本地密钥
    const identityKeys = await this.identityKeyDao.getByUserId(bobUserId);
    if (identityKeys.length === 0) {
      throw new Error('bobIdentityKey 不存在');
    }
    const bobIdentityKey = identityKeys[0];
    const bobIdentityPrivateKey = HexUtil.hexToBytes(bobIdentityKey.privateKey);
    const bobIdentityPublicKey = HexUtil.hexToBytes(bobIdentityKey.publicKey);
    Log.log(`$bobUserId bobIdentityPublic ${HexUtil.bytesToHex(bobIdentityPublicKey)}`);

    const signedPreKeys = await this.signedPreKeyDao.getByUserId(bobUserId);
    if (signedPreKeys.length === 0) {
      throw new Error('bobSignedPreKey 不存在');
    }
    const bobSignedPreKey = signedPreKeys[0];
    const bobSignedPreKeyPrivateKey = HexUtil.hexToBytes(bobSignedPreKey.privateKey);
    const bobSignedPreKeyPublicKey = HexUtil.hexToBytes(bobSignedPreKey.publicKey);
    Log.log(`$bobUserId bobSignedPreKeyPublic ${HexUtil.bytesToHex(bobSignedPreKeyPublicKey)}`);

    const oneTimePreKey = await this.oneTimePreKeyDao.getByKeyId(bobOneTimePreKeyId);
    if (oneTimePreKey == null) {
      throw new Error('bobOneTimePreKey 不存在');
    }
    const bobOneTimePreKeyPrivateKey = HexUtil.hexToBytes(oneTimePreKey.privateKey);
    const bobOneTimePreKeyPublicKey = HexUtil.hexToBytes(oneTimePreKey.publicKey);
    Log.log(`$bobUserId bobOneTimePreKeyPublic ${HexUtil.bytesToHex(bobOneTimePreKeyPublicKey)}`);

    // 解析 Alice 公钥
    const aliceIdentityPublic = HexUtil.hexToBytes(aliceIdentityKey);
    const aliceEphemeralPublic = HexUtil.hexToBytes(aliceEphemeralKey);
    Log.log(`$bobUserId aliceIdentityPublic ${HexUtil.bytesToHex(aliceIdentityPublic)}`);
    Log.log(`$bobUserId aliceEphemeralPublic ${HexUtil.bytesToHex(aliceEphemeralPublic)}`);

    // 计算 4 个 DH 共享密钥
    const dh1 = await ECCExchangeHelper.getSharedSecretByUintArrays(bobIdentityPrivateKey, aliceIdentityPublic);
    const dh2 = await ECCExchangeHelper.getSharedSecretByUintArrays(bobIdentityPrivateKey, aliceEphemeralPublic);
    const dh3 = await ECCExchangeHelper.getSharedSecretByUintArrays(bobSignedPreKeyPrivateKey, aliceEphemeralPublic);
    const dh4 = await ECCExchangeHelper.getSharedSecretByUintArrays(bobOneTimePreKeyPrivateKey, aliceEphemeralPublic);

    // 拼接并派生 X3DH 密钥
    const sharedSecret = EncryptUtil.appendArrays(dh1, dh2, dh3, dh4);
    const hkdf = new HKDFUtil();
    const x3DHKey = hkdf.deriveSecrets(
      sharedSecret,
      new Uint8Array(32),
      ArrayUtil.stringToBytes('Info'),
      64,
    );

    Log.log(`$bobUserId x3DHKey= ${HexUtil.bytesToHex(x3DHKey)}`);
    return x3DHKey;
  }
}
