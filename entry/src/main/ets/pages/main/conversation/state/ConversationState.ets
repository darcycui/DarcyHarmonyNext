/**
 * ConversationState - 会话页面统一状态类
 *
 * 封装会话列表的可观察状态。
 *
 * @ObservedV2 - 标记为可观察类
 * @Trace     - 标记属性为可观察，属性变化时触发关联组件重渲染
 */
import { IState, ScreenState } from 'static_library_common';
import { ConversationResponse } from 'library_network';

@ObservedV2
export default class ConversationState implements IState {
  /** 屏幕状态（加载中/错误/成功等） */
  @Trace screenState: ScreenState = new ScreenState();
  /** 会话列表 */
  @Trace conversationList: ConversationResponse[] = [];
}
