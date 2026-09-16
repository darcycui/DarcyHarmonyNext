/**
 * GenerateIdentityKeyUseCase - 生成身份密钥业务用例
 *
 * 职责：
 *  - 生成 X25519 ECC 密钥对
 *  - 创建 IdentityKeyEntity 并通过 IdentityKeyDao 持久化到数据库
 *  - 查询并返回已持久化的实体
 *
 * 架构流向：
 *   ViewModel → GenerateIdentityKeyUseCase → IdentityKeyDao → database
 *
 * 使用示例：
 * ```typescript
 * const useCase = new GenerateIdentityKeyUseCase(identityKeyDao);
 * const entity = await useCase.execute({ userId: 123 });
 * ```
 */
import { BaseUseCase, HexUtil, Log, UUIDUtil } from 'static_library_common';
import { DHExchangeUtil } from 'library_crypto';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { DarcyIMDatabase, IdentityKeyDao, IdentityKeyEntity } from 'library_database';

/**
 * 生成身份密钥用例入参
 */
export interface GenerateIdentityKeyParams {
  /** 用户 ID */
  userId: number;
}

/**
 * 生成身份密钥用例
 * 入参：GenerateIdentityKeyParams
 * 出参：IdentityKeyEntity（已持久化的身份密钥实体）
 */
export class GenerateIdentityKeyUseCase extends BaseUseCase<GenerateIdentityKeyParams, IdentityKeyEntity> {
  private darcyIMDatabase: DarcyIMDatabase;

  constructor(darcyIMDatabase: DarcyIMDatabase) {
    super();
    this.darcyIMDatabase = darcyIMDatabase;
  }

  async execute(params: GenerateIdentityKeyParams): Promise<IdentityKeyEntity> {
    // 1. 校验：userId 必须有效
    if (!params.userId || params.userId <= 0) {
      throw new Error('无效的用户 ID');
    }

    // 2. 生成 X25519 密钥对
    const keyPair: cryptoFramework.KeyPair | null = await DHExchangeUtil.generateKeyPair();
    if (keyPair == null) {
      throw new Error('生成身份密钥对失败');
    }

    // 3. 提取公私钥字节并编码为十六进制
    const pubKeyBytes: Uint8Array = DHExchangeUtil.getKeyBytes(keyPair.pubKey);
    const priKeyBytes: Uint8Array = DHExchangeUtil.getKeyBytes(keyPair.priKey);
    if (pubKeyBytes.length === 0 || priKeyBytes.length === 0) {
      throw new Error('获取密钥字节失败');
    }
    const publicKeyHex: string = HexUtil.bytesToHex(pubKeyBytes);
    const privateKeyHex: string = HexUtil.bytesToHex(priKeyBytes);

    // 4. 生成唯一密钥标识
    const keyId: string = UUIDUtil.generateIdentityKeyId();

    // 5. 创建实体并插入数据库
    const entity = new IdentityKeyEntity(
      undefined,
      keyId,
      params.userId,
      privateKeyHex,
      publicKeyHex,
    );
    const identityKeyDao = this.darcyIMDatabase.getIdentityKeyDao()
    await identityKeyDao.insert(entity);
    Log.info(`[GenerateIdentityKeyUseCase] 身份密钥持久化成功, keyId=${keyId}`);

    // 6. 从数据库中查询刚插入的记录并返回
    const entityFromDb = await identityKeyDao.getByKeyId(keyId);
    if (entityFromDb == null) {
      throw new Error('查询刚插入的身份密钥失败');
    }
    return entityFromDb;
  }
}
