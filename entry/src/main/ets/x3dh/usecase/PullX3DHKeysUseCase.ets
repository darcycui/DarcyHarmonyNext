/**
 * PullX3DHKeysUseCase - 拉取 Bob 的 X3DH 密钥业务用例
 *
 * 职责：
 *  - 编排拉取 Bob 的 X3DH 密钥材料的完整业务流程
 *  - 调用 X3DHKeysRepository 拉取密钥
 *  - 返回 Bob 的密钥材料供后续计算使用
 *
 * 架构流向：
 *   ViewModel → PullX3DHKeysUseCase → X3DHKeysRepository → httpHelper.doPost
 *
 * 使用示例：
 * ```typescript
 * const useCase = new PullX3DHKeysUseCase(repository);
 * const bobKeys = await useCase.execute({ aliceUserId: 1, bobUserId: 2 });
 * ```
 */
import { BaseUseCase } from 'static_library_common';
import { X3DHKeysPullResponse } from 'library_network';
import { X3DHKeysRepository } from 'library_login/src/main/ets/x3dh/repository/X3DHKeysRepository';

/**
 * 拉取 Bob 的 X3DH 密钥入参
 */
export interface PullX3DHKeysParams {
  /** Alice 用户 ID（发起方） */
  aliceUserId: number;
  /** Bob 用户 ID（接收方） */
  bobUserId: number;
}

/**
 * 拉取 Bob 的 X3DH 密钥用例
 * 入参：PullX3DHKeysParams
 * 出参：X3DHKeysPullResponse（Bob 的密钥材料）
 */
export class PullX3DHKeysUseCase extends BaseUseCase<PullX3DHKeysParams, X3DHKeysPullResponse> {
  private repository: X3DHKeysRepository;

  constructor(repository: X3DHKeysRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: PullX3DHKeysParams): Promise<X3DHKeysPullResponse> {
    // 1. 校验：用户 ID 必须有效
    if (!params.aliceUserId || params.aliceUserId <= 0) {
      throw new Error('无效的 Alice 用户 ID');
    }
    if (!params.bobUserId || params.bobUserId <= 0) {
      throw new Error('无效的 Bob 用户 ID');
    }

    // 2. 调用 Repository 拉取 Bob 的密钥
    const bobKeys: X3DHKeysPullResponse = await this.repository.pullBobKeys(
      params.aliceUserId,
      params.bobUserId
    );

    // 3. 校验响应
    if (!bobKeys.identityKey) {
      throw new Error('Bob 的身份密钥为空');
    }
    if (!bobKeys.signedPreKey) {
      throw new Error('Bob 的签名预密钥为空');
    }
    if (!bobKeys.oneTimePreKey) {
      throw new Error('Bob 的一次性预密钥为空');
    }

    return bobKeys;
  }
}
