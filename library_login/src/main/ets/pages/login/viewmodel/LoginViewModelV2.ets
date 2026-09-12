/**
 * LoginViewModelV2 - V2 版本的登录 ViewModel
 *
 * 展示如何从 V1 (@Observed + @State) 迁移到 V2 (@ObservedV2 + @Trace)
 * 采用 MVI 模式：通过 dispatch(intent) 统一入口
 *
 * 对比 V1 版本 (LoginIndex 直接管理状态) 的关键改进：
 *   ✅ 继承 BaseViewModel，获得统一的 loading/error 状态管理
 *   ✅ @ObservedV2 + @Trace → 支持细粒度属性追踪
 *   ✅ 通过 UseCase → Repository 分层，ViewModel 不再直接处理数据访问
 *   ✅ MVI dispatch 模式，便于复杂页面状态追踪
 *   ✅ 状态统一封装到 LoginState，由 LoginReducer 负责修改
 *
 * ─── View 层使用示例 ─────────────────────────────────────
 * 注意：V2 ViewModel 需要配合 @ComponentV2 + @Local/@Param 使用
 *
 * ```typescript
 * @Entry
 * @ComponentV2
 * struct LoginIndex {
 *   @Local viewModel: LoginViewModelV2 = new LoginViewModelV2();
 *
 *   aboutToAppear(): void {
 *     this.viewModel.setContext(this.context);
 *   }
 * }
 * ```
 *
 * ─── 架构流向 ─────────────────────────────────────
 *   View (@ComponentV2)
 *     → ViewModel (@ObservedV2) 持有 @Trace state: LoginState
 *     → ViewModel 方法委托 Reducer 修改 state
 *     → Reducer 原地修改 @Trace 属性触发 UI 重渲染
 */
import { BaseViewModel, Log } from 'static_library_common';
import { common } from '@kit.AbilityKit';
import LoginState from '../state/LoginState';
import LoginReducer from '../reducer/LoginReducer';
import { LoginUseCase, LoginParams } from '../usecase/LoginUseCase';
import { LoginRepository } from '../repository/LoginRepository';
import { ServerDHExchangeUseCase } from '../../dh/usecase/ServerDHExchangeUseCase';
import { ServerDHExchangeRepository } from '../../dh/repository/ServerDHExchangeRepository';
import {
  LoginIntent,
  DoLoginIntent,
  UpdateUserNameIntent,
  UpdatePasswordIntent
} from '../intent/LoginIntent';

@ObservedV2
export default class LoginViewModelV2 extends BaseViewModel {
  // ─── 页面统一状态对象（@Trace 实现细粒度刷新） ────────

  /** 统一状态：封装 userName + password */
  @Trace state: LoginState = new LoginState();

  // ─── 依赖注入（简洁起见使用手动构造，正式项目可用 DI 框架） ──
  private loginUseCase: LoginUseCase = new LoginUseCase(new LoginRepository());

  /** DH 密钥交换用例 */
  private serverDHExchangeUseCase: ServerDHExchangeUseCase = new ServerDHExchangeUseCase(new ServerDHExchangeRepository());

  // ─── Reducer（负责状态修改） ──────────────────────
  private reducer: LoginReducer = new LoginReducer();

  // ─── MVI dispatch 模式（统一入口） ────────────
  /**
   * 重写基类 dispatch 方法
   * 使用 instanceof 根据 intent 类型分发到对应处理方法
   * 异步 Intent（如 DoLogin）会 await 执行完成
   *
   * @param intent - 意图
   */
  async dispatch(intent: LoginIntent): Promise<void> {
    if (intent instanceof DoLoginIntent) {
      await this.doLogin()
    } else if (intent instanceof UpdateUserNameIntent) {
      this.updateUserName(intent.value)
    } else if (intent instanceof UpdatePasswordIntent) {
      this.updatePassword(intent.value)
    } else {
      Log.warn(`[LoginViewModelV2] 未处理的 Intent: ${intent}`)
    }
  }

  // ─── 业务方法 ────────────────────────────────────

  /**
   * 更新用户名
   * 委托 Reducer 修改 LoginState
   */
  updateUserName(value: string): void {
    this.reducer.updateUserName(this.state, value);
  }

  /**
   * 更新密码
   * 委托 Reducer 修改 LoginState
   */
  updatePassword(value: string): void {
    this.reducer.updatePassword(this.state, value);
  }

  /**
   * 执行登录
   * 使用 BaseViewModel.safeLoad 统一管理 loading/error 状态
   */
  async doLogin(): Promise<void> {

    await this.safeLoad(async () => {
      const params: LoginParams = {
        userName: this.state.userName,
        password: this.state.password
      };
      const result = await this.loginUseCase.execute(params);
      if (result.success) {
        Log.info(`[LoginViewModelV2] 登录成功: ${result.message}`);
        // 登录成功后触发 DH 密钥交换
        try {
          await this.serverDHExchangeUseCase.execute({ userId: result.userId });
          Log.info(`[LoginViewModelV2] DH 密钥交换完成`);
        } catch (dhError) {
          Log.error(`[LoginViewModelV2] DH 密钥交换失败: ${dhError}`);
        }
      }
    });
  }

  /**
   * 重置登录状态
   * 清空输入字段和错误信息
   */
  resetState(): void {
    this.reducer.clearFields(this.state);
    this.baseState.errorMessage = '';
  }
}
