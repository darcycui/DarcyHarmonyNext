/**
 * FetchConversationListUseCase - 获取会话列表业务用例
 *
 * 职责：
 *  - 获取当前用户的会话列表
 *  - 参数校验 + 委托 Repository 执行
 *
 * 架构流向：
 *   ConversationListViewModel → FetchConversationListUseCase → ConversationRepository
 *
 * 使用示例：
 * ```typescript
 * const useCase = new FetchConversationListUseCase(repository);
 * const result = await useCase.execute({ userId: 1 });
 * ```
 */
import { ConversationResponse } from 'library_network';
import { BaseUseCase } from 'static_library_common';
import { ConversationRepository } from '../repository/ConversationRepository';

/**
 * 获取会话列表入参
 */
export interface FetchConversationListParams {
  /** 当前用户 ID */
  userId: number;
}

/**
 * 执行获取会话列表用例
 * 入参：FetchConversationListParams
 * 出参：ConversationResponse[]
 */
export class FetchConversationListUseCase extends BaseUseCase<FetchConversationListParams, ConversationResponse[]> {
  private repository: ConversationRepository;

  constructor(repository: ConversationRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: FetchConversationListParams): Promise<ConversationResponse[]> {
    if (!params.userId) {
      throw new Error('用户 ID 不能为空');
    }

    return this.repository.fetchConversationList(params.userId);
  }
}
