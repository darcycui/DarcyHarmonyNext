/**
 * CalculateAliceX3DHKeyUseCase - 计算 Alice 端 X3DH 密钥
 *
 * 职责：
 *  - 根据 Alice 身份密钥和 Bob 公钥材料计算 X3DH 共享密钥
 *  - 生成 Alice 临时密钥对
 *  - 返回 [x3DHKey, aliceEphemeralKey]
 *
 * 架构流向：
 *   ViewModel → CalculateAliceX3DHKeyUseCase → IdentityKeyDao + ECCExchangeHelper + HKDFUtil
 *
 * 返回值：Array<Uint8Array>，[0] = x3DHKey (64字节)，[1] = aliceEphemeralKey (包含 privateKey/publicKey)
 */
import { ArrayUtil, BaseUseCase } from 'static_library_common';
import { Log } from 'static_library_common';
import { HexUtil } from 'static_library_common';
import { DarcyIMDatabase, IdentityKeyEntity } from 'library_database';
import { ECCExchangeUtil, HKDFUtil, EncryptUtil } from 'library_crypto';
import { X3DHKeysPullResponse } from 'library_network';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

/**
 * Alice X3DH 密钥计算入参
 */
export interface CalculateAliceX3DHKeyParams {
  /** Alice 用户 ID */
  aliceUserId: number;
  /** Bob 用户 ID */
  bobUserId: number;
  /** Bob 的 X3DH 公钥材料（JSON 字符串） */
  bobKeys: string;
}

/**
 * 计算 Alice 端 X3DH 密钥结果
 */

export interface CalculateAliceX3DHKeyResult {
  /** X3DH 密钥 */
  x3DHKey: Uint8Array;
  /** Alice 临时密钥对 */
  aliceEphemeralKey: cryptoFramework.KeyPair;
}

/**
 * 计算 Alice 端 X3DH 密钥
 *
 * 返回 Array：[x3DHKey, aliceEphemeralKey]
 * - x3DHKey: Uint8Array (64 字节)
 * - aliceEphemeralKey: { privateKey: Uint8Array, publicKey: Uint8Array }
 */
export class CalculateAliceX3DHKeyUseCase extends BaseUseCase<CalculateAliceX3DHKeyParams, CalculateAliceX3DHKeyResult> {
  private identityKeyDao = DarcyIMDatabase.getInstance().getIdentityKeyDao();

  async execute(params: CalculateAliceX3DHKeyParams): Promise<CalculateAliceX3DHKeyResult> {
    const aliceUserId = params.aliceUserId;
    const bobUserId = params.bobUserId;
    const bobKeysStr = params.bobKeys;

    // 校验参数
    if (!aliceUserId) {
      throw new Error('aliceUserId 不能为空');
    }
    if (!bobUserId) {
      throw new Error('bobUserId 不能为空');
    }
    if (!bobKeysStr) {
      throw new Error('bobKeys 不能为空');
    }

    // 解析 Bob 公钥材料
    const bobKeys = JSON.parse(bobKeysStr) as X3DHKeysPullResponse;
    if (!bobKeys || !bobKeys.identityKey) {
      throw new Error('bobKeys 解析失败');
    }

    // 获取 Alice 身份私钥
    const identityKeys = await this.identityKeyDao.getByUserId(aliceUserId);
    if (identityKeys.length === 0) {
      throw new Error('aliceIdentityPrivateKey 不存在');
    }
    const aliceIdentityKey = identityKeys[0];
    const aliceIdentityPrivateKey = HexUtil.hexToBytes(aliceIdentityKey.privateKey);
    const aliceIdentityPublicKey = HexUtil.hexToBytes(aliceIdentityKey.publicKey);

    // 生成 Alice 临时密钥对
    const aliceEphemeralKey = await ECCExchangeUtil.generateKeyPair();
    if (aliceEphemeralKey == null) {
      throw new Error('aliceEphemeralKey 生成失败');
    }

    Log.log(`$aliceUserId aliceIdentityPublic= ${HexUtil.bytesToHex(aliceIdentityPublicKey)}`);
    Log.log(`$aliceUserId aliceEphemeralPublic= ${HexUtil.bytesToHex(ECCExchangeUtil.getKeyBytes(aliceEphemeralKey.pubKey))}`);

    // 解析 Bob 公钥
    const bobIdentityPublic = HexUtil.hexToBytes(bobKeys.identityKey);
    const bobSignedPreKeyPublic = HexUtil.hexToBytes(bobKeys.signedPreKey);
    const bobOneTimePreKeyPublic = HexUtil.hexToBytes(bobKeys.oneTimePreKey);

    Log.log(`$aliceUserId bobIdentityPublic= ${HexUtil.bytesToHex(bobIdentityPublic)}`);
    Log.log(`$aliceUserId bobSignedPreKeyPublic= ${HexUtil.bytesToHex(bobSignedPreKeyPublic)}`);
    Log.log(`$aliceUserId bobOneTimePreKeyPublic= ${HexUtil.bytesToHex(bobOneTimePreKeyPublic)}`);

    // 计算 4 个 DH 共享密钥
    const dh1 = await ECCExchangeUtil.getSharedSecretByUintArrays(aliceIdentityPrivateKey, bobIdentityPublic);
    const dh2 = await ECCExchangeUtil.getSharedSecretByUintArrays(ECCExchangeUtil.getKeyBytes(aliceEphemeralKey.priKey), bobIdentityPublic);
    const dh3 = await ECCExchangeUtil.getSharedSecretByUintArrays(ECCExchangeUtil.getKeyBytes(aliceEphemeralKey.priKey), bobSignedPreKeyPublic);
    const dh4 = await ECCExchangeUtil.getSharedSecretByUintArrays(ECCExchangeUtil.getKeyBytes(aliceEphemeralKey.priKey), bobOneTimePreKeyPublic);

    // 拼接并派生 X3DH 密钥
    const sharedSecret = EncryptUtil.appendArrays(dh1, dh2, dh3, dh4);
    const hkdf = new HKDFUtil();
    const x3DHKey = hkdf.deriveSecrets(
      sharedSecret,
      new Uint8Array(32),
      ArrayUtil.stringToBytes('Info'),
      64,
    );

    Log.log(`$aliceUserId x3DHKey= ${HexUtil.bytesToHex(x3DHKey)}`);

    // 返回 [x3DHKey, aliceEphemeralKey]
    const result: CalculateAliceX3DHKeyResult = { x3DHKey, aliceEphemeralKey };
    return result;
  }
}
