/**
 * CreateConversationUseCase - 创建会话业务用例
 *
 * 职责：
 *  - 创建当前用户与目标用户之间的会话
 *  - 参数校验 + 委托 Repository 执行
 *
 * 架构流向：
 *   ContactViewModel → CreateConversationUseCase → ConversationRepository
 *
 * 使用示例：
 * ```typescript
 * const useCase = new CreateConversationUseCase(repository);
 * const result = await useCase.execute({ userId: 1, targetId: 2, conversationType: 1 });
 * ```
 */
import { ConversationResponse } from 'library_network';
import { BaseUseCase } from 'static_library_common';
import { ConversationRepository } from '../repository/ConversationRepository';

/**
 * 创建会话入参
 */
export interface CreateConversationParams {
  /** 当前用户 ID */
  userId: number;
  /** 目标用户 ID */
  targetId: number;
  /** 会话类型（1 表示单聊） */
  conversationType: number;
}

/**
 * 执行创建会话用例
 * 入参：CreateConversationParams
 * 出参：ConversationResponse
 */
export class CreateConversationUseCase extends BaseUseCase<CreateConversationParams, ConversationResponse> {
  private repository: ConversationRepository;

  constructor(repository: ConversationRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: CreateConversationParams): Promise<ConversationResponse> {
    if (!params.userId || params.userId <= 0) {
      throw new Error('用户 ID 不能为空');
    }
    if (!params.targetId || params.targetId <= 0) {
      throw new Error('目标用户 ID 不能为空');
    }

    return this.repository.createConversation(params.userId, params.targetId, params.conversationType);
  }
}
