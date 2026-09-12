/**
 * ScreenPhase - 屏幕阶段枚举
 *
 * 等价于 Kotlin sealed class ScreenState 中的各个 data object/data class 变体。
 * 配合 @Trace phase 属性使用，实现细粒度的屏幕状态追踪。
 *
 * ─── Kotlin 对照 ─────────────────────────────────────
 *  data object Initial   → ScreenPhase.INITIAL
 *  data object Loading   → ScreenPhase.LOADING
 *  data object Empty     → ScreenPhase.EMPTY
 *  data class Error(...) → ScreenPhase.ERROR（错误信息通过 errorCode / errorMessage 承载）
 *  data object Success   → ScreenPhase.SUCCESS
 *  data object NoData    → ScreenPhase.NO_DATA
 *  data object Refresh   → ScreenPhase.REFRESH
 *  data object LoadMore  → ScreenPhase.LOAD_MORE
 *  data object NoMoreData→ ScreenPhase.NO_MORE_DATA
 */
export enum ScreenPhase {
  /** 初始状态 */
  INITIAL = 'Initial',
  /** 加载中 */
  LOADING = 'Loading',
  /** 数据为空 */
  EMPTY = 'Empty',
  /** 发生错误 */
  ERROR = 'Error',
  /** 加载成功 */
  SUCCESS = 'Success',
  /** 无数据 */
  NO_DATA = 'NoData',
  /** 刷新中 */
  REFRESH = 'Refresh',
  /** 加载更多 */
  LOAD_MORE = 'LoadMore',
  /** 没有更多数据 */
  NO_MORE_DATA = 'NoMoreData',
}

/**
 * ScreenState - 屏幕状态类
 *
 * 使用 @ObservedV2 + @Trace 实现响应式屏幕状态管理，
 * 通过 phase 枚举表示屏幕所处的具体阶段，errorCode 携带错误码，
 * isLoading / errorMessage / isLoaded 提供通用的加载/错误状态追踪能力。
 *
 * ─── 设计说明 ─────────────────────────────────────
 *  Kotlin 的 sealed class + data object 在 ArkTS 中无法直接实现，
 *  此处使用 ScreenPhase 枚举 + 可选 errorCode 来等价表达所有变体。
 *  各个"data object"变体不再需要独立类，通过 phase 的值即可区分。
 *
 * ─── 使用示例 ─────────────────────────────────────
 *  const screenState = new ScreenState();
 *
 *  // 初始状态
 *  screenState.phase = ScreenPhase.INITIAL;
 *
 *  // 加载中
 *  screenState.phase = ScreenPhase.LOADING;
 *
 *  // 错误状态（同时设置错误码与错误信息）
 *  screenState.phase = ScreenPhase.ERROR;
 *  screenState.errorCode = 500;
 *  screenState.errorMessage = 'Server Internal Error';
 *
 *  // 加载成功
 *  screenState.phase = ScreenPhase.SUCCESS;
 *
 *  // 刷新
 *  screenState.phase = ScreenPhase.REFRESH;
 *
 *  // 加载更多
 *  screenState.phase = ScreenPhase.LOAD_MORE;
 */
@ObservedV2
export default class ScreenState {
  /** 当前屏幕阶段（等价于 Kotlin sealed class 的具体变体） */
  @Trace phase: ScreenPhase = ScreenPhase.INITIAL;
  /** 错误码（仅当 phase === ScreenPhase.ERROR 时有意义） */
  @Trace errorCode: number = 0;
  /** 错误信息（仅当 phase === ScreenPhase.ERROR 时有意义） */
  @Trace errorMessage: string = '';

  /**
   * 快捷设置错误状态
   *
   * 等价于 Kotlin 中的 ScreenState.Error(errorCode, errorMessage)
   *
   * @param code  - 错误码
   * @param message - 错误描述
   */
  setError(code: number, message: string): void {
    this.phase = ScreenPhase.ERROR;
    this.errorCode = code;
    this.errorMessage = message;
  }

  /** 重置为初始状态 */
  reset(): void {
    this.phase = ScreenPhase.INITIAL;
    this.errorCode = 0;
    this.errorMessage = '';
  }

  /** 判断当前是否为指定阶段 */
  is(phase: ScreenPhase): boolean {
    return this.phase === phase;
  }

  /** 判断是否处于错误状态 */
  get isError(): boolean {
    return this.phase === ScreenPhase.ERROR;
  }

  /** 判断是否处于加载相关状态（Loading / Refresh / LoadMore） */
  get isLoadingPhase(): boolean {
    return this.phase === ScreenPhase.LOADING
      || this.phase === ScreenPhase.REFRESH
      || this.phase === ScreenPhase.LOAD_MORE;
  }

  /** 判断是否为最终确定状态（Success / Empty / NoData / NoMoreData / Error） */
  get isFinalPhase(): boolean {
    return this.phase === ScreenPhase.SUCCESS
      || this.phase === ScreenPhase.EMPTY
      || this.phase === ScreenPhase.NO_DATA
      || this.phase === ScreenPhase.NO_MORE_DATA
      || this.phase === ScreenPhase.ERROR;
  }
}
