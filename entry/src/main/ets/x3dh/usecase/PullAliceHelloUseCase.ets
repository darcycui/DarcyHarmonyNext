/**
 * PullAliceHelloUseCase - 拉取 Alice Hello 消息业务用例
 *
 * 职责：
 *  - 编排拉取 Alice Hello 消息的完整业务流程
 *  - 调用 AliceHelloRepository 拉取 Hello 消息
 *  - 返回拉取响应供后续流程使用
 *
 * 架构流向：
 *   ViewModel → PullAliceHelloUseCase → AliceHelloRepository → httpHelper.doPost
 *
 * 使用示例：
 * ```typescript
 * const useCase = new PullAliceHelloUseCase(repository);
 * const response = await useCase.execute({ aliceUserId: 1, bobUserId: 2 });
 * ```
 */
import { BaseUseCase } from 'static_library_common';
import { X3DHAliceHelloPullResponse } from 'library_network';
import { AliceHelloRepository } from '../repository/AliceHelloRepository';

/**
 * 拉取 Alice Hello 消息入参
 */
export interface PullAliceHelloParams {
  /** Alice 用户 ID（发起方） */
  aliceUserId: number;
  /** Bob 用户 ID（接收方） */
  bobUserId: number;
}

/**
 * 拉取 Alice Hello 消息用例
 * 入参：PullAliceHelloParams
 * 出参：X3DHAliceHelloPullResponse（拉取响应）
 */
export class PullAliceHelloUseCase extends BaseUseCase<PullAliceHelloParams, X3DHAliceHelloPullResponse> {
  private repository: AliceHelloRepository;

  constructor(repository: AliceHelloRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: PullAliceHelloParams): Promise<X3DHAliceHelloPullResponse> {
    // 1. 校验：用户 ID 必须有效
    if (!params.aliceUserId || params.aliceUserId <= 0) {
      throw new Error('无效的 Alice 用户 ID');
    }
    if (!params.bobUserId || params.bobUserId <= 0) {
      throw new Error('无效的 Bob 用户 ID');
    }

    // 2. 调用 Repository 拉取 Alice Hello 消息
    const response: X3DHAliceHelloPullResponse = await this.repository.pullAliceHello(
      params.aliceUserId,
      params.bobUserId
    );

    // 3. 校验响应
    if (!response || !response.id) {
      throw new Error('拉取 Alice Hello 消息失败：响应为空');
    }

    return response;
  }
}
