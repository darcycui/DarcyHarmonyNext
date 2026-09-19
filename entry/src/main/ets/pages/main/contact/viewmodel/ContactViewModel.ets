/**
 * ContactViewModel - 联系人列表页面 ViewModel
 *
 * 展示 V2 版本的 MVI 架构：@ObservedV2 + @Trace + MVI dispatch
 *
 * 架构流向：
 *   View (@ComponentV2)
 *     → ViewModel (@ObservedV2) 持有 @Trace state: ContactState
 *     → ViewModel 方法委托 Reducer 修改 state
 *     → Reducer 原地修改 @Trace 属性触发 UI 重渲染
 */
import { BaseViewModel, Log } from 'static_library_common';
import { FriendshipResponse, ConversationResponse } from 'library_network';
import ContactState from '../state/ContactState';
import ContactReducer from '../reducer/ContactReducer';
import { FetchFriendsUseCase, FetchFriendsParams } from '../usecase/FetchFriendsUseCase';
import { ContactRepository } from '../repository/ContactRepository';
import { ConversationRepository } from '../../conversation/repository/ConversationRepository';
import { CreateConversationUseCase, CreateConversationParams } from '../../conversation/usecase/CreateConversationUseCase';
import { ContactListIntent, FetchFriendsIntent, CreateConversationIntent } from '../intent/ContactIntent';
import { UserManager } from 'library_login';

@ObservedV2
export default class ContactViewModel extends BaseViewModel {
  // ─── 页面统一状态对象（@Trace 实现细粒度刷新） ────────

  /** 统一状态 */
  @Trace state: ContactState = new ContactState();

  // ─── 依赖注入 ──
  private repository: ContactRepository = new ContactRepository();
  private fetchFriendsUseCase: FetchFriendsUseCase = new FetchFriendsUseCase(this.repository);
  private conversationRepository: ConversationRepository = new ConversationRepository();
  private createConversationUseCase: CreateConversationUseCase = new CreateConversationUseCase(this.conversationRepository);

  // ─── Reducer（负责状态修改） ──────────────────────
  private reducer: ContactReducer = new ContactReducer();

  // ─── MVI dispatch 模式（统一入口） ────────────
  /**
   * 重写基类 dispatch 方法
   * 使用 instanceof 根据 intent 类型分发到对应处理方法
   *
   * @param intent - 意图
   */
  async dispatch(intent: ContactListIntent): Promise<void> {
    if (intent instanceof FetchFriendsIntent) {
      await this.fetchFriends();
    } else if (intent instanceof CreateConversationIntent) {
      await this.createConversation(intent.targetId);
    } else {
      Log.warn(`[ContactViewModel] 未处理的 Intent: ${intent}`);
    }
  }

  // ─── 业务方法 ────────────────────────────────────

  /**
   * 获取好友列表
   */
  async fetchFriends(): Promise<void> {
    await this.safeLoad(this.state.screenState, async () => {
      const currentUserId = await UserManager.getUserID();
      Log.info(`[ContactViewModel] 获取好友列表: userId=${currentUserId}`);
      const params: FetchFriendsParams = { userId: currentUserId };
      const result: FriendshipResponse[] = await this.fetchFriendsUseCase.execute(params);
      Log.info(`[ContactViewModel] 获取好友列表成功: ${result.length} 条`);
      this.reducer.setFriends(this.state, result);
    });
  }

  /**
   * 创建会话（单聊）
   *
   * 点击好友列表项时触发，创建成功后把会话 ID 写入 state 供页面跳转。
   *
   * @param targetId - 目标用户 ID
   */
  async createConversation(targetId: number): Promise<void> {
    await this.safeLoad(this.state.screenState, async () => {
      const currentUserId = await UserManager.getUserID();
      Log.info(`[ContactViewModel] 创建会话: userId=${currentUserId}, targetId=${targetId}`);
      const params: CreateConversationParams = {
        userId: currentUserId,
        targetId: targetId,
        conversationType: 1
      };
      const result: ConversationResponse = await this.createConversationUseCase.execute(params);
      Log.info(`[ContactViewModel] 创建会话成功: conversationId=${result.conversationId}`);
      this.reducer.setCreatedConversationId(this.state, result.conversationId);
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
