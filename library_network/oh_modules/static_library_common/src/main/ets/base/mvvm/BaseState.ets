/**
 * BaseState - 基础状态类
 *
 * 封装页面通用的三个加载/错误状态字段，配合 @ObservedV2 + @Trace 实现细粒度响应式。
 * 所有子页面状态类（如 LoginState、RegisterState、TodoListState）应继承此类，
 * 获得统一的 isLoading / errorMessage / isLoaded 状态管理能力。
 *
 * ─── 架构定位 ─────────────────────────────────────
 *   BaseViewModel 持有 @Trace baseState: BaseState 用于管理基础加载状态
 *   ViewModel.safeLoad / safeAction / clearError / reset 操作 baseState 的属性
 *   View 层通过 baseState.isLoading / baseState.errorMessage / baseState.isLoaded 读取状态
 *
 * @ObservedV2 - 标记为可观察类
 * @Trace     - 标记属性为可观察，属性变化时触发关联组件重渲染
 */
@ObservedV2
export default class BaseState {
  /** 页面是否正在加载（显示 Loading 指示器） */
  @Trace isLoading: boolean = false;

  /** 错误信息（非空时显示错误提示） */
  @Trace errorMessage: string = '';

  /** 是否加载完成（用于区分首次加载与刷新） */
  @Trace isLoaded: boolean = false;
}
