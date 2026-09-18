/**
 * ConversationListViewModel - 会话列表页面 ViewModel
 *
 * 展示 V2 版本的 MVI 架构：@ObservedV2 + @Trace + MVI dispatch
 *
 * 架构流向：
 *   View (@ComponentV2)
 *     → ViewModel (@ObservedV2) 持有 @Trace state: ConversationState
 *     → ViewModel 方法委托 Reducer 修改 state
 *     → Reducer 原地修改 @Trace 属性触发 UI 重渲染
 */
import { BaseViewModel, Log, ScreenPhase } from 'static_library_common';
import { ConversationResponse } from 'library_network';
import ConversationState from '../state/ConversationState';
import ConversationReducer from '../reducer/ConversationReducer';
import { FetchConversationListUseCase, FetchConversationListParams } from '../usecase/FetchConversationListUseCase';
import { ConversationRepository } from '../repository/ConversationRepository';
import { ConversationIntent, FetchConversationListIntent, RefreshConversationListIntent } from '../intent/ConversationIntent';
import { UserManager } from 'library_login';

@ObservedV2
export default class ConversationListViewModel extends BaseViewModel {
  // ─── 页面统一状态对象（@Trace 实现细粒度刷新） ────────

  /** 统一状态 */
  @Trace state: ConversationState = new ConversationState();

  // ─── 依赖注入 ──
  private repository: ConversationRepository = new ConversationRepository();
  private fetchConversationListUseCase: FetchConversationListUseCase = new FetchConversationListUseCase(this.repository);

  // ─── Reducer（负责状态修改） ──────────────────────
  private reducer: ConversationReducer = new ConversationReducer();

  // ─── MVI dispatch 模式（统一入口） ────────────
  /**
   * 重写基类 dispatch 方法
   * 使用 instanceof 根据 intent 类型分发到对应处理方法
   *
   * @param intent - 意图
   */
  async dispatch(intent: ConversationIntent): Promise<void> {
    if (intent instanceof FetchConversationListIntent) {
      await this.fetchConversationList();
    } else if (intent instanceof RefreshConversationListIntent) {
      await this.fetchConversationList();
    } else {
      Log.warn(`[ConversationListViewModel] 未处理的 Intent: ${intent}`);
    }
  }

  // ─── 业务方法 ────────────────────────────────────

  /**
   * 获取会话列表
   */
  async fetchConversationList(): Promise<void> {
    await this.safeLoad(this.state.screenState, async () => {
      const currentUserId = await UserManager.getUserID();
      Log.info(`[ConversationListViewModel] 获取会话列表: userId=${currentUserId}`);
      const params: FetchConversationListParams = { userId: currentUserId };
      const result: ConversationResponse[] = await this.fetchConversationListUseCase.execute(params);
      Log.info(`[ConversationListViewModel] 获取会话列表成功: ${result.length} 条`);
      this.reducer.setConversationList(this.state, result);
    });
  }

  /**
   * 重置错误状态
   */
  clearError(): void {
    this.state.screenState.reset();
  }

  /**
   * 重置 ViewModel 到初始状态
   */
  reset(): void {
    this.reducer.clearFields(this.state);
    this.state.screenState.reset();
    this.resetInitialized();
  }
}
