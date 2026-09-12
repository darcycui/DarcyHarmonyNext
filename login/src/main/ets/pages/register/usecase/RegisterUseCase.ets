/**
 * RegisterUseCase - 注册业务用例
 *
 * 职责：
 *  - 编排注册的完整业务流程
 *  - 组合 Repository 调用 + 数据校验逻辑
 *  - 保持 ViewModel 瘦身，业务逻辑集中在此层
 *
 * 架构流向：
 *   RegisterViewModelV2 → RegisterUseCase → RegisterRepository
 *
 * 使用示例：
 * ```typescript
 * const useCase = new RegisterUseCase(repository);
 * const result = await useCase.execute({
 *   userName: 'user',
 *   password: '123456',
 *   phone: '13800138000',
 *   nickname: 'nick',
 *   email: 'user@example.com'
 * });
 * ```
 */
import { RegisterResponse } from 'library_network';
import { BaseUseCase } from 'static_library_common';
import { RegisterRepository, RegisterResult } from '../repository/RegisterRepository';

/**
 * 注册用例入参
 */
export interface RegisterParams {
  /** 用户名 */
  userName: string;
  /** 密码 */
  password: string;
  /** 手机号 */
  phone: string;
  /** 昵称 */
  nickname: string;
  /** 邮箱 */
  email: string;
}

/**
 * 执行注册用例
 * 入参：RegisterParams
 * 出参：RegisterResult
 */
export class RegisterUseCase extends BaseUseCase<RegisterParams, RegisterResponse> {
  private repository: RegisterRepository;

  constructor(repository: RegisterRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: RegisterParams): Promise<RegisterResponse> {
    // 校验：用户名不能为空
    if (!params.userName) {
      throw new Error('请输入用户名');
    }

    // 校验：密码不能为空
    if (!params.password) {
      throw new Error('请输入密码');
    }

    // 校验：手机号不能为空
    if (!params.phone) {
      throw new Error('请输入手机号');
    }

    // 校验：昵称不能为空
    if (!params.nickname) {
      throw new Error('请输入昵称');
    }

    // 校验：邮箱不能为空
    if (!params.email) {
      throw new Error('请输入邮箱');
    }

    // 委托 Repository 执行注册
    return this.repository.doRegister(
      params.userName,
      params.password,
      params.phone,
      params.nickname,
      params.email
    );
  }
}
