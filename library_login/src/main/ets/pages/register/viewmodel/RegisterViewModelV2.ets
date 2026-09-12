/**
 * RegisterViewModelV2 - V2 版本的注册 ViewModel
 *
 * 采用 MVI 模式：通过 dispatch(intent) 统一入口
 *
 * ─── 架构特性 ─────────────────────────────────────
 *   ✅ 继承 BaseViewModel，获得统一的 loading/error 状态管理
 *   ✅ @ObservedV2 + @Trace → 支持细粒度属性追踪
 *   ✅ 通过 UseCase → Repository 分层，ViewModel 不再直接处理数据访问
 *   ✅ MVI dispatch 模式，便于复杂页面状态追踪
 *   ✅ 状态统一封装到 RegisterState，由 RegisterReducer 负责修改
 *
 * ─── View 层使用示例 ─────────────────────────────────────
 * ```typescript
 * @Entry
 * @ComponentV2
 * struct RegisterPage {
 *   @Local viewModel: RegisterViewModelV2 = new RegisterViewModelV2();
 * }
 * ```
 *
 * ─── 架构流向 ─────────────────────────────────────
 *   View (@ComponentV2) → dispatch(intent) → @ObservedV2 ViewModel → UseCase → Repository
 *     → ViewModel 方法委托 Reducer 修改 state
 *     → Reducer 原地修改 @Trace 属性触发 UI 重渲染
 */
import { BaseViewModel, Log } from 'static_library_common';
import RegisterState from '../state/RegisterState';
import RegisterReducer from '../reducer/RegisterReducer';
import { RegisterUseCase, RegisterParams } from '../usecase/RegisterUseCase';
import { RegisterRepository } from '../repository/RegisterRepository';
import { ServerDHExchangeUseCase } from '../../dh/usecase/ServerDHExchangeUseCase';
import { ServerDHExchangeRepository } from '../../dh/repository/ServerDHExchangeRepository';
import {
  RegisterIntent,
  DoRegisterIntent,
  UpdateRegisterUserNameIntent,
  UpdateRegisterPasswordIntent,
  UpdatePhoneIntent,
  UpdateNicknameIntent,
  UpdateEmailIntent
} from '../intent/RegisterIntent';

@ObservedV2
export default class RegisterViewModelV2 extends BaseViewModel {
  // ─── 页面统一状态对象（@Trace 实现细粒度刷新） ────────

  /** 统一状态：封装 userName + password + phone + nickname + email */
  @Trace state: RegisterState = new RegisterState();

  // ─── 依赖注入 ──────────────────────────────────
  private registerUseCase: RegisterUseCase = new RegisterUseCase(new RegisterRepository());

  /** DH 密钥交换用例 */
  private serverDHExchangeUseCase: ServerDHExchangeUseCase = new ServerDHExchangeUseCase(new ServerDHExchangeRepository());

  // ─── Reducer（负责状态修改） ──────────────────────
  private reducer: RegisterReducer = new RegisterReducer();

  // ─── MVI dispatch 模式（统一入口） ────────────
  /**
   * 重写基类 dispatch 方法
   * 使用 instanceof 根据 intent 类型分发到对应处理方法
   *
   * @param intent - 意图
   */
  async dispatch(intent: RegisterIntent): Promise<void> {
    if (intent instanceof DoRegisterIntent) {
      await this.doRegister()
    } else if (intent instanceof UpdateRegisterUserNameIntent) {
      this.updateUserName(intent.value)
    } else if (intent instanceof UpdateRegisterPasswordIntent) {
      this.updatePassword(intent.value)
    } else if (intent instanceof UpdatePhoneIntent) {
      this.updatePhone(intent.value)
    } else if (intent instanceof UpdateNicknameIntent) {
      this.updateNickname(intent.value)
    } else if (intent instanceof UpdateEmailIntent) {
      this.updateEmail(intent.value)
    } else {
      Log.warn(`[RegisterViewModelV2] 未处理的 Intent: ${intent}`)
    }
  }

  // ─── 业务方法 ────────────────────────────────────

  /**
   * 更新用户名
   * 委托 Reducer 修改 RegisterState
   */
  updateUserName(value: string): void {
    this.reducer.updateUserName(this.state, value);
  }

  /**
   * 更新密码
   * 委托 Reducer 修改 RegisterState
   */
  updatePassword(value: string): void {
    this.reducer.updatePassword(this.state, value);
  }

  /**
   * 更新手机号
   * 委托 Reducer 修改 RegisterState
   */
  updatePhone(value: string): void {
    this.reducer.updatePhone(this.state, value);
  }

  /**
   * 更新昵称
   * 委托 Reducer 修改 RegisterState
   */
  updateNickname(value: string): void {
    this.reducer.updateNickname(this.state, value);
  }

  /**
   * 更新邮箱
   * 委托 Reducer 修改 RegisterState
   */
  updateEmail(value: string): void {
    this.reducer.updateEmail(this.state, value);
  }

  /**
   * 执行注册
   * 使用 BaseViewModel.safeLoad 统一管理 loading/error 状态
   */
  async doRegister(): Promise<void> {
    await this.safeLoad(async (): Promise<void> => {
      const params: RegisterParams = {
        userName: this.state.userName,
        password: this.state.password,
        phone: this.state.phone,
        nickname: this.state.nickname,
        email: this.state.email
      };
      Log.log(`RegisterViewModelV2 doRegister: ${JSON.stringify(params)}`);
      const result = await this.registerUseCase.execute(params);
      if (result) {
        Log.info(`[RegisterViewModelV2] 注册成功: ${JSON.stringify(result)}`);
        // 注册成功后触发 DH 密钥交换
        try {
          await this.serverDHExchangeUseCase.execute({ userId: result.id });
          Log.info(`[RegisterViewModelV2] DH 密钥交换完成`);
        } catch (dhError) {
          Log.error(`[RegisterViewModelV2] DH 密钥交换失败: ${dhError}`);
        }
      } else {
        Log.error(`[RegisterViewModelV2] 注册失败: ${JSON.stringify(result)}`);
      }
    });
  }
}
