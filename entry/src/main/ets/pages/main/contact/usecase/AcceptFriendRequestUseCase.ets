/**
 * AcceptFriendRequestUseCase - 同意好友请求业务用例
 *
 * 职责：
 *  - 同意好友请求
 *  - 参数校验 + 委托 Repository 执行
 *
 * 架构流向：
 *   AcceptFriendViewModel → AcceptFriendRequestUseCase → ContactRepository
 *
 * 使用示例：
 * ```typescript
 * const useCase = new AcceptFriendRequestUseCase(repository);
 * const result = await useCase.execute({ friendRequestId: 1 });
 * ```
 */
import { ApplyFriendResponse } from 'library_network';
import { BaseUseCase } from 'static_library_common';
import { ContactRepository } from '../repository/ContactRepository';

/**
 * 同意好友请求入参
 */
export interface AcceptFriendRequestParams {
  /** 好友请求 ID */
  friendRequestId: number;
}

/**
 * 执行同意好友请求用例
 * 入参：AcceptFriendRequestParams
 * 出参：ApplyFriendResponse
 */
export class AcceptFriendRequestUseCase extends BaseUseCase<AcceptFriendRequestParams, ApplyFriendResponse> {
  private repository: ContactRepository;

  constructor(repository: ContactRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: AcceptFriendRequestParams): Promise<ApplyFriendResponse> {
    if (!params.friendRequestId || params.friendRequestId <= 0) {
      throw new Error('好友请求 ID 不能为空');
    }

    return this.repository.acceptFriendRequest(params.friendRequestId);
  }
}
