/**
 * QueryFriendRequestsFromMeUseCase - 查询我发出的好友请求业务用例
 *
 * 职责：
 *  - 查询当前用户发出的好友请求列表
 *  - 参数校验 + 委托 Repository 执行
 *
 * 架构流向：
 *   ViewModel → QueryFriendRequestsFromMeUseCase → ContactRepository
 *
 * 使用示例：
 * ```typescript
 * const useCase = new QueryFriendRequestsFromMeUseCase(repository);
 * const result = await useCase.execute({ fromUserId: 1 });
 * ```
 */
import { ApplyFriendResponse } from 'library_network';
import { BaseUseCase } from 'static_library_common';
import { ContactRepository } from '../repository/ContactRepository';

/**
 * 查询我发出的好友请求入参
 */
export interface QueryFriendRequestsFromMeParams {
  /** 当前用户 ID */
  fromUserId: number;
}

/**
 * 执行查询我发出的好友请求用例
 * 入参：QueryFriendRequestsFromMeParams
 * 出参：ApplyFriendResponse[]
 */
export class QueryFriendRequestsFromMeUseCase extends BaseUseCase<QueryFriendRequestsFromMeParams, ApplyFriendResponse[]> {
  private repository: ContactRepository;

  constructor(repository: ContactRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: QueryFriendRequestsFromMeParams): Promise<ApplyFriendResponse[]> {
    if (!params.fromUserId || params.fromUserId <= 0) {
      throw new Error('用户 ID 不能为空');
    }

    return this.repository.queryFriendRequestsFromMe(params.fromUserId);
  }
}
