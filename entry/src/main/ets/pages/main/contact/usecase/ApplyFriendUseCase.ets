/**
 * ApplyFriendUseCase - 申请好友业务用例
 *
 * 职责：
 *  - 向目标用户发起好友申请
 *  - 参数校验 + 委托 Repository 执行
 *
 * 架构流向：
 *   ContactViewModel → ApplyFriendUseCase → ContactRepository
 *
 * 使用示例：
 * ```typescript
 * const useCase = new ApplyFriendUseCase(repository);
 * const result = await useCase.execute({ fromUserId: 1, toUserId: 2 });
 * ```
 */
import { ApplyFriendResponse } from 'library_network';
import { BaseUseCase } from 'static_library_common';
import { ContactRepository } from '../repository/ContactRepository';

/**
 * 申请好友入参
 */
export interface ApplyFriendParams {
  /** 发起者用户 ID */
  fromUserId: number;
  /** 目标用户 ID */
  toUserId: number;
}

/**
 * 执行申请好友用例
 * 入参：ApplyFriendParams
 * 出参：ApplyFriendResponse
 */
export class ApplyFriendUseCase extends BaseUseCase<ApplyFriendParams, ApplyFriendResponse> {
  private repository: ContactRepository;

  constructor(repository: ContactRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: ApplyFriendParams): Promise<ApplyFriendResponse> {
    if (!params.fromUserId) {
      throw new Error('发起者用户 ID 不能为空');
    }

    if (!params.toUserId) {
      throw new Error('目标用户 ID 不能为空');
    }

    return this.repository.applyFriend(params.fromUserId, params.toUserId);
  }
}
