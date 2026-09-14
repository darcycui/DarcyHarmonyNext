/**
 * PushX3DHKeysUseCase - 推送 X3DH 密钥业务用例
 *
 * 职责：
 *  - 推送当前用户的 X3DH 密钥材料到服务端
 *  - 调用 X3DHPushKeysRepository 完成网络请求
 *  - 返回推送结果
 *
 * 架构流向：
 *   ViewModel → PushX3DHKeysUseCase → X3DHPushKeysRepository → doPost
 *
 * 使用示例：
 * ```typescript
 * const useCase = new PushX3DHKeysUseCase(repository);
 * const result = await useCase.execute({
 *   userId: 1,
 *   identityKey: 'hex...',
 *   signedPreKey: 'hex...',
 *   oneTimePreKeys: [OneTimePreKeyInputDTO]
 * });
 * ```
 */
import { BaseUseCase } from 'static_library_common';
import { OneTimePreKeyInputDTO, X3DHKeysPushResponse } from 'library_network';
import { X3DHPushKeysRepository } from '../repository/X3DHPushKeysRepository';

/**
 * 推送 X3DH 密钥入参
 */
export interface PushX3DHKeysParams {
  /** 用户 ID */
  userId: number;
  /** 身份密钥（hex 编码） */
  identityKey: string;
  /** 签名预密钥（hex 编码） */
  signedPreKey: string;
  /** 一次性预密钥列表 */
  oneTimePreKeys: OneTimePreKeyInputDTO[];
}

/**
 * 推送 X3DH 密钥用例
 * 入参：PushX3DHKeysParams
 * 出参：X3DHKeysPushResponse（推送结果）
 */
export class PushX3DHKeysUseCase extends BaseUseCase<PushX3DHKeysParams, X3DHKeysPushResponse> {
  private repository: X3DHPushKeysRepository;

  constructor(repository: X3DHPushKeysRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: PushX3DHKeysParams): Promise<X3DHKeysPushResponse> {
    // 1. 校验：用户 ID 必须有效
    if (!params.userId || params.userId <= 0) {
      throw new Error('无效的用户 ID');
    }

    // 2. 校验：身份密钥和签名预密钥不能为空
    if (!params.identityKey) {
      throw new Error('身份密钥为空');
    }
    if (!params.signedPreKey) {
      throw new Error('签名预密钥为空');
    }

    // 3. 推送密钥
    const response: X3DHKeysPushResponse = await this.repository.pushX3DHKeys(
      params.userId,
      params.identityKey,
      params.signedPreKey,
      params.oneTimePreKeys
    );

    // 4. 校验响应
    if (response.status !== 0 && response.status !== 200) {
      throw new Error(response.message || '推送 X3DH 密钥失败');
    }

    return response;
  }
}
