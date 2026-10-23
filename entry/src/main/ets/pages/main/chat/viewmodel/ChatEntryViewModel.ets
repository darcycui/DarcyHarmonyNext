/**
 * ChatEntryViewModel - 聊天页面 ViewModel
 *
 * 架构流向：
 *   View (@ComponentV2)
 *     → ViewModel (@ObservedV2) 持有 @Trace state: ChatState
 *     → ViewModel 通过 UseCase 处理业务逻辑
 *     → Reducer 修改 @Trace 属性触发 UI 重渲染
 */
import { BaseViewModel, Log } from 'static_library_common';
import { ChatItem } from '../../../../models/ui/im/ChatItem';
import ChatState from '../state/ChatState';
import ChatReducer from '../reducer/ChatReducer';
import { ChatRepository } from '../repository/ChatRepository';
import { LoadChatMessagesUseCase } from '../usecase/LoadChatMessagesUseCase';
import { SendChatMessageUseCase, SendChatMessageParams } from '../usecase/SendChatMessageUseCase';
import { ChatIntent, LoadChatMessagesIntent, SendChatMessageIntent } from '../intent/ChatIntent';

@ObservedV2
export default class ChatEntryViewModel extends BaseViewModel {
  /** 统一状态 */
  @Trace state: ChatState = new ChatState();

  // ─── 依赖注入 ──
  private repository: ChatRepository = new ChatRepository();
  private loadChatMessagesUseCase: LoadChatMessagesUseCase = new LoadChatMessagesUseCase(this.repository);
  private sendChatMessageUseCase: SendChatMessageUseCase = new SendChatMessageUseCase(this.repository);

  // ─── Reducer（负责状态修改） ──────────────────────
  private reducer: ChatReducer = new ChatReducer();

  // ─── MVI dispatch 模式（统一入口） ────────────
  /**
   * 重写基类 dispatch 方法
   *
   * @param intent - 意图
   */
  async dispatch(intent: ChatIntent): Promise<void> {
    if (intent instanceof LoadChatMessagesIntent) {
      await this.loadMessages();
    } else if (intent instanceof SendChatMessageIntent) {
      await this.sendMessage(intent.message);
    } else {
      Log.warn(`[ChatEntryViewModel] 未处理的 Intent: ${intent}`);
    }
  }

  // ─── 业务方法 ────────────────────────────────────

  /**
   * 加载聊天消息
   */
  async loadMessages(): Promise<void> {
    await this.safeLoad(this.state.screenState, async () => {
      const result: ChatItem[] = await this.loadChatMessagesUseCase.execute();
      Log.info(`[ChatEntryViewModel] 加载聊天消息成功: ${result.length} 条`);
      this.reducer.setMessages(this.state, result);
    });
  }

  /**
   * 发送聊天消息
   *
   * @param message - 消息内容
   */
  async sendMessage(message: string): Promise<void> {
    await this.safeLoad(this.state.screenState, async () => {
      const params: SendChatMessageParams = { message };
      const result: ChatItem = await this.sendChatMessageUseCase.execute(params);
      Log.info(`[ChatEntryViewModel] 发送聊天消息成功: ${result.message}`);
      this.reducer.appendMessage(this.state, result);
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
