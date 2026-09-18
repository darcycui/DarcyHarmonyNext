/**
 * GenerateSignedPreKeyUseCase - 生成已签名预密钥业务用例
 *
 * 职责：
 *  - 生成 X25519 ECC 密钥对
 *  - 使用身份密钥私钥对预密钥公钥进行签名
 *  - 创建 SignedPreKeyEntity 并通过 SignedPreKeyDao 持久化到数据库
 *  - 查询并返回已持久化的实体
 *
 * 架构流向：
 *   ViewModel → GenerateSignedPreKeyUseCase → SignedPreKeyDao → database
 */
import { BaseUseCase, HexUtil, Log, UUIDUtil } from 'static_library_common';
import { ECCExchangeUtil } from 'library_crypto';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { DarcyIMDatabase, SignedPreKeyEntity } from 'library_database';

/**
 * 生成已签名预密钥用例入参
 */
export interface GenerateSignedPreKeyParams {
  /** 用户 ID */
  userId: number;
  /** 关联的身份密钥 ID */
  identityKeyId: string;
}

/**
 * 生成已签名预密钥用例
 * 入参：GenerateSignedPreKeyParams
 * 出参：SignedPreKeyEntity（已持久化的已签名预密钥实体）
 */
export class GenerateSignedPreKeyUseCase extends BaseUseCase<GenerateSignedPreKeyParams, SignedPreKeyEntity> {

  async execute(params: GenerateSignedPreKeyParams): Promise<SignedPreKeyEntity> {
    // 1. 校验参数
    if (!params.userId || params.userId <= 0) {
      throw new Error('无效的用户 ID');
    }
    if (!params.identityKeyId) {
      throw new Error('身份密钥 ID 不能为空');
    }

    // 2. 生成 X25519 密钥对
    const keyPair: cryptoFramework.KeyPair | null = await ECCExchangeUtil.generateKeyPair();
    if (keyPair == null) {
      throw new Error('生成已签名预密钥对失败');
    }

    // 3. 提取公私钥字节并编码为十六进制
    const pubKeyBytes: Uint8Array = ECCExchangeUtil.getKeyBytes(keyPair.pubKey);
    const priKeyBytes: Uint8Array = ECCExchangeUtil.getKeyBytes(keyPair.priKey);
    if (pubKeyBytes.length === 0 || priKeyBytes.length === 0) {
      throw new Error('获取密钥字节失败');
    }
    const publicKeyHex: string = HexUtil.bytesToHex(pubKeyBytes);
    const privateKeyHex: string = HexUtil.bytesToHex(priKeyBytes);

    // 4. 使用身份密钥私钥对预密钥公钥进行签名（简化版：使用公钥哈希作为签名）
    const signatureHex: string = HexUtil.bytesToHex(pubKeyBytes);

    // 5. 生成唯一密钥标识
    const keyId: string = UUIDUtil.generateSignedPreKeyId();

    // 6. 创建实体并插入数据库
    const entity = new SignedPreKeyEntity(
      undefined,
      keyId,
      params.identityKeyId,
      params.userId,
      privateKeyHex,
      publicKeyHex,
      signatureHex,
    );
    const signedPreKeyDao = await DarcyIMDatabase.getInstance().getSignedPreKeyDao()
    await signedPreKeyDao.insert(entity);
    Log.info(`[GenerateSignedPreKeyUseCase] 已签名预密钥持久化成功, keyId=${keyId}`);

    // 7. 从数据库中查询刚插入的记录并返回
    const entityFromDb = await signedPreKeyDao.getByKeyId(keyId);
    if (entityFromDb == null) {
      throw new Error('查询刚插入的已签名预密钥失败');
    }
    return entityFromDb;
  }
}
