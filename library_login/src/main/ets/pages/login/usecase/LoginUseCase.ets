/**
 * LoginUseCase - 登录业务用例
 *
 * 职责：
 *  - 编排登录的完整业务流程
 *  - 组合 Repository 调用 + 数据校验逻辑
 *  - 保持 ViewModel 瘦身，业务逻辑集中在此层
 *
 * 架构流向：
 *   LoginViewModelV2 → LoginUseCase → LoginRepository
 *
 * 使用示例：
 * ```typescript
 * const useCase = new LoginUseCase(repository);
 * const result = await useCase.execute({ userName: 'admin', password: '123456' });
 * ```
 */
import { BaseUseCase } from 'static_library_common';
import { common } from '@kit.AbilityKit';
import { LoginRepository, LoginResult } from '../repository/LoginRepository';

/**
 * 登录用例入参
 */
export interface LoginParams {
  /** 用户名 */
  userName: string;
  /** 密码 */
  password: string;
}

/**
 * 执行登录用例
 * 入参：LoginParams
 * 出参：LoginResult
 */
export class LoginUseCase extends BaseUseCase<LoginParams, LoginResult> {
  private repository: LoginRepository;

  constructor(repository: LoginRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: LoginParams): Promise<LoginResult> {
    // 校验：用户名不能为空
    if (!params.userName) {
      throw new Error('请输入用户名');
    }

    // 校验：密码不能为空
    if (!params.password) {
      throw new Error('请输入密码');
    }

    // 委托 Repository 执行登录
    return this.repository.doLogin(params.userName, params.password);
  }
}
