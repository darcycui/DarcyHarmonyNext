/**
 * GenerateOneTimePreKeyUseCase - 生成一次性预密钥业务用例
 *
 * 职责：
 *  - 生成 X25519 ECC 密钥对
 *  - 创建 OneTimePreKeyEntity 并通过 OneTimePreKeyDao 持久化到数据库
 *  - 查询并返回已持久化的实体
 *
 * 架构流向：
 *   ViewModel → GenerateOneTimePreKeyUseCase → OneTimePreKeyDao → database
 *
 * 使用示例：
 * ```typescript
 * const useCase = new GenerateOneTimePreKeyUseCase(oneTimePreKeyDao);
 * const entity = await useCase.execute({ userId: 123 });
 * ```
 */
import { BaseUseCase, HexUtil, Log } from 'static_library_common';
import { DHExchangeUtil } from 'library_crypto';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { DarcyIMDatabase, OneTimePreKeyDao, OneTimePreKeyEntity } from 'library_database';

/**
 * 生成一次性预密钥用例入参
 */
export interface GenerateOneTimePreKeyParams {
  /** 用户 ID */
  userId: number;
}

/**
 * 生成一次性预密钥用例
 * 入参：GenerateOneTimePreKeyParams
 * 出参：OneTimePreKeyEntity（已持久化的一次性预密钥实体）
 */
export class GenerateOneTimePreKeyUseCase extends BaseUseCase<GenerateOneTimePreKeyParams, OneTimePreKeyEntity[]> {
  private darcyIMDatabase: DarcyIMDatabase;

  constructor(darcyIMDatabase: DarcyIMDatabase) {
    super();
    this.darcyIMDatabase = darcyIMDatabase;
  }

  async execute(params: GenerateOneTimePreKeyParams): Promise<OneTimePreKeyEntity[]> {
    // 1. 校验：userId 必须有效
    if (!params.userId || params.userId <= 0) {
      throw new Error('无效的用户 ID');
    }

    // 2. 生成 X25519 密钥对
    const keyPair: cryptoFramework.KeyPair | null = await DHExchangeUtil.generateKeyPair();
    if (keyPair == null) {
      throw new Error('生成一次性预密钥对失败');
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
    const keyId: string = `otpk-${params.userId}-${Date.now()}`;

    // 5. 创建实体并插入数据库
    const entityList: OneTimePreKeyEntity[] = [];
    for (let index = 0; index < 100; index++) {
      const entity = new OneTimePreKeyEntity(
        undefined,
        keyId,
        params.userId,
        privateKeyHex,
        publicKeyHex,
      );
      entityList.push(entity);
    }
    const oneTimePreKeyDao = this.darcyIMDatabase.getOneTimePreKeyDao()
    await oneTimePreKeyDao.insertBatch(entityList);
    Log.info(`[GenerateOneTimePreKeyUseCase] 一次性预密钥持久化成功, keyId=${keyId}`);

    // 6. 从数据库中查询刚插入的记录并返回
    const entityListFromDb = await oneTimePreKeyDao.getByKeyId(keyId);
    if (entityListFromDb == null) {
      throw new Error('查询刚插入的一次性预密钥失败');
    }
    return entityListFromDb;
  }
}
