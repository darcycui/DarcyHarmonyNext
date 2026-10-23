/**
 * ChatReducer - 聊天页面状态 Reducer
 *
 * 只负责纯状态转换，不涉及副作用。
 * 通过原地修改 @Trace 属性触发组件重渲染。
 */
import { IReducer } from 'static_library_common';
import { ChatItem } from '../../../../models/ui/im/ChatItem';
import ChatState from '../state/ChatState';

export default class ChatReducer implements IReducer {
  /**
   * 设置消息列表
   *
   * @param state - ChatState 实例
   * @param messages - 消息列表
   */
  setMessages(state: ChatState, messages: ChatItem[]): void {
    state.messages = messages;
  }

  /**
   * 追加一条消息
   *
   * @param state - ChatState 实例
   * @param message - 新消息
   */
  appendMessage(state: ChatState, message: ChatItem): void {
    state.messages = state.messages.concat([message]);
  }

  /**
   * 清空所有字段
   *
   * @param state - ChatState 实例
   */
  clearFields(state: ChatState): void {
    state.messages = [];
  }
}
