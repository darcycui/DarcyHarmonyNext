/**
 * PushAliceHelloUseCase - 推送 Alice Hello 消息业务用例
 *
 * 职责：
 *  - 编排推送 Alice Hello 消息的完整业务流程
 *  - 调用 AliceHelloRepository 推送 Hello 消息
 *  - 返回推送响应供后续流程使用
 *
 * 架构流向：
 *   ViewModel → PushAliceHelloUseCase → AliceHelloRepository → httpHelper.doPost
 *
 * 使用示例：
 * ```typescript
 * const useCase = new PushAliceHelloUseCase(repository);
 * const response = await useCase.execute({
 *   aliceUserId: 1, bobUserId: 2,
 *   aliceIdentityKey: '...', aliceEphemeralKey: '...', bobOneTimePreKeyId: '...'
 * });
 * ```
 */
import { BaseUseCase } from 'static_library_common';
import { X3DHAliceHelloPushResponse } from 'library_network';
import { AliceHelloRepository } from '../repository/AliceHelloRepository';

/**
 * 推送 Alice Hello 消息入参
 */
export interface PushAliceHelloParams {
  /** Alice 用户 ID（发起方） */
  aliceUserId: number;
  /** Bob 用户 ID（接收方） */
  bobUserId: number;
  /** Alice 的身份密钥 */
  aliceIdentityKey: string;
  /** Alice 的临时密钥 */
  aliceEphemeralKey: string;
  /** Bob 的一次性预密钥 ID */
  bobOneTimePreKeyId: string;
}

/**
 * 推送 Alice Hello 消息用例
 * 入参：PushAliceHelloParams
 * 出参：X3DHAliceHelloPushResponse（推送响应）
 */
export class PushAliceHelloUseCase extends BaseUseCase<PushAliceHelloParams, X3DHAliceHelloPushResponse> {
  private repository: AliceHelloRepository;

  constructor(repository: AliceHelloRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: PushAliceHelloParams): Promise<X3DHAliceHelloPushResponse> {
    // 1. 校验：用户 ID 必须有效
    if (!params.aliceUserId || params.aliceUserId <= 0) {
      throw new Error('无效的 Alice 用户 ID');
    }
    if (!params.bobUserId || params.bobUserId <= 0) {
      throw new Error('无效的 Bob 用户 ID');
    }

    // 2. 校验：密钥材料不能为空
    if (!params.aliceIdentityKey) {
      throw new Error('Alice 身份密钥为空');
    }
    if (!params.aliceEphemeralKey) {
      throw new Error('Alice 临时密钥为空');
    }
    if (!params.bobOneTimePreKeyId) {
      throw new Error('Bob 一次性预密钥 ID 为空');
    }

    // 3. 调用 Repository 推送 Alice Hello 消息
    const response: X3DHAliceHelloPushResponse = await this.repository.pushAliceHello(
      params.aliceUserId,
      params.bobUserId,
      params.aliceIdentityKey,
      params.aliceEphemeralKey,
      params.bobOneTimePreKeyId
    );

    // 4. 校验响应
    if (!response || !response.id) {
      throw new Error('推送 Alice Hello 消息失败：响应为空');
    }

    return response;
  }
}
