/**
 * QueryFriendRequestsUseCase - 查询好友请求业务用例
 *
 * 职责：
 *  - 查询发给当前用户的好友请求列表
 *  - 参数校验 + 委托 Repository 执行
 *
 * 架构流向：
 *   AcceptFriendViewModel → QueryFriendRequestsUseCase → ContactRepository
 *
 * 使用示例：
 * ```typescript
 * const useCase = new QueryFriendRequestsUseCase(repository);
 * const result = await useCase.execute({ toUserId: 1 });
 * ```
 */
import { ApplyFriendResponse } from 'library_network';
import { BaseUseCase } from 'static_library_common';
import { ContactRepository } from '../repository/ContactRepository';

/**
 * 查询好友请求入参
 */
export interface QueryFriendRequestsParams {
  /** 当前用户 ID */
  toUserId: number;
}

/**
 * 执行查询好友请求用例
 * 入参：QueryFriendRequestsParams
 * 出参：ApplyFriendResponse[]
 */
export class QueryFriendRequestsToMeUseCase extends BaseUseCase<QueryFriendRequestsParams, ApplyFriendResponse[]> {
  private repository: ContactRepository;

  constructor(repository: ContactRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: QueryFriendRequestsParams): Promise<ApplyFriendResponse[]> {
    if (!params.toUserId || params.toUserId <= 0) {
      throw new Error('用户 ID 不能为空');
    }

    return this.repository.queryFriendRequestsToMe(params.toUserId);
  }
}
