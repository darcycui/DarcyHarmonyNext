/**
 * ChatState - 聊天页面统一状态类
 *
 * @ObservedV2 - 标记为可观察类
 * @Trace     - 标记属性为可观察，属性变化时触发关联组件重渲染
 */
import { IState, ScreenState } from 'static_library_common';
import { ChatItem } from '../../../../models/ui/im/ChatItem';

@ObservedV2
export default class ChatState implements IState {
  /** 屏幕状态（加载中/错误/成功等） */
  @Trace screenState: ScreenState = new ScreenState();
  /** 聊天消息列表 */
  @Trace messages: ChatItem[] = [];
}
