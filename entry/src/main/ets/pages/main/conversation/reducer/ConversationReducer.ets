/**
 * ConversationReducer - 会话页面状态 Reducer
 *
 * 继承 IReducer，负责统一修改 ConversationState 对象的值。
 * 所有方法采用原地修改（mutate in-place）模式，利用 @Trace 的细粒度响应触发组件重渲染。
 *
 * ─── 架构定位 ─────────────────────────────────────
 *   ViewModel 持有 ConversationState 实例 + ConversationReducer 实例
 *   ViewModel 方法内部委托 Reducer 修改状态
 *   Reducer 只负责纯状态转换，不涉及副作用
 */
import { IReducer } from 'static_library_common';
import { ConversationResponse } from 'library_network';
import ConversationState from '../state/ConversationState';

export default class ConversationReducer implements IReducer {
  /**
   * 设置会话列表
   *
   * @param state - ConversationState 实例
   * @param list - 会话列表
   */
  setConversationList(state: ConversationState, list: ConversationResponse[]): void {
    state.conversationList = list;
  }

  /**
   * 清空所有字段
   *
   * @param state - ConversationState 实例
   */
  clearFields(state: ConversationState): void {
    state.conversationList = [];
  }
}
