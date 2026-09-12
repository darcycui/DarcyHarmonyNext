/**
 * RegisterState - 注册页面统一状态类
 *
 * 封装注册页面的所有可观察状态，配合 @ObservedV2 + @Trace 实现细粒度响应式。
 * ViewModel 通过持有此状态实例，并由 Reducer 统一修改状态值，实现状态与行为分离。
 *
 * 包含 isLoading / errorMessage / isLoaded 基础状态管理能力。
 *
 * ─── 架构定位 ─────────────────────────────────────
 *   ViewModel 持有 @Trace state: RegisterState
 *   Reducer 负责修改 state 的属性值（mutate in-place）
 *   View 层通过 state.xxx 读取数据
 *
 * @ObservedV2 - 标记为可观察类
 * @Trace     - 标记属性为可观察，属性变化时触发关联组件重渲染
 */
import { IState } from "static_library_common";

@ObservedV2
export default class RegisterState implements IState {
  /** 页面是否正在加载（显示 Loading 指示器） */
  @Trace isLoading: boolean = false;
  /** 错误信息（非空时显示错误提示） */
  @Trace errorMessage: string = '';
  /** 是否加载完成（用于区分首次加载与刷新） */
  @Trace isLoaded: boolean = false;
  /** 用户名 */
  @Trace userName: string = '';
  /** 密码 */
  @Trace password: string = '';
  /** 手机号 */
  @Trace phone: string = '';
  /** 昵称 */
  @Trace nickname: string = '';
  /** 邮箱 */
  @Trace email: string = '';
}
