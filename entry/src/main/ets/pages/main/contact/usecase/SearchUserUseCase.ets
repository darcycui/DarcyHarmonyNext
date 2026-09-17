/**
 * SearchUserUseCase - 搜索用户业务用例
 *
 * 职责：
 *  - 根据手机号搜索用户
 *  - 参数校验 + 委托 Repository 执行
 *
 * 架构流向：
 *   ContactViewModel → SearchUserUseCase → ContactRepository
 *
 * 使用示例：
 * ```typescript
 * const useCase = new SearchUserUseCase(repository);
 * const result = await useCase.execute({ phone: '13800001111' });
 * ```
 */
import { UserResponse } from 'library_network';
import { BaseUseCase } from 'static_library_common';
import { ContactRepository } from '../repository/ContactRepository';

/**
 * 搜索用户入参
 */
export interface SearchUserParams {
  /** 手机号 */
  phone: string;
}

/**
 * 执行搜索用户用例
 * 入参：SearchUserParams
 * 出参：UserResponse
 */
export class SearchUserUseCase extends BaseUseCase<SearchUserParams, UserResponse> {
  private repository: ContactRepository;

  constructor(repository: ContactRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: SearchUserParams): Promise<UserResponse> {
    if (!params.phone) {
      throw new Error('请输入手机号');
    }

    return this.repository.searchUserByPhone(params.phone);
  }
}
