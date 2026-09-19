/**
 * FetchFriendsUseCase - 获取好友列表业务用例
 *
 * 职责：
 *  - 获取当前用户的好友列表
 *  - 参数校验 + 委托 Repository 执行
 *
 * 架构流向：
 *   ContactViewModel → FetchFriendsUseCase → ContactRepository
 *
 * 使用示例：
 * ```typescript
 * const useCase = new FetchFriendsUseCase(repository);
 * const result = await useCase.execute({ userId: 1 });
 * ```
 */
import { FriendshipResponse } from 'library_network';
import { BaseUseCase } from 'static_library_common';
import { ContactRepository } from '../repository/ContactRepository';

/**
 * 获取好友列表入参
 */
export interface FetchFriendsParams {
  /** 当前用户 ID */
  userId: number;
}

/**
 * 执行获取好友列表用例
 * 入参：FetchFriendsParams
 * 出参：FriendshipResponse[]
 */
export class FetchFriendsUseCase extends BaseUseCase<FetchFriendsParams, FriendshipResponse[]> {
  private repository: ContactRepository;

  constructor(repository: ContactRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: FetchFriendsParams): Promise<FriendshipResponse[]> {
    if (!params.userId || params.userId <= 0) {
      throw new Error('用户 ID 不能为空');
    }

    return this.repository.fetchFriends(params.userId);
  }
}
