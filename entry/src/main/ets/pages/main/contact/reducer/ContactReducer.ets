/**
 * ContactReducer - 联系人列表页面状态 Reducer
 *
 * 继承 IReducer，负责统一修改 ContactState 对象的值。
 * 所有方法采用原地修改（mutate in-place）模式，利用 @Trace 的细粒度响应触发组件重渲染。
 *
 * ─── 架构定位 ─────────────────────────────────────
 *   ViewModel 持有 ContactState 实例 + ContactReducer 实例
 *   ViewModel 方法内部委托 Reducer 修改状态
 *   Reducer 只负责纯状态转换，不涉及副作用
 */
import { IReducer } from 'static_library_common';
import { FriendshipResponse } from 'library_network';
import ContactState from '../state/ContactState';

export default class ContactReducer implements IReducer {
  /**
   * 设置好友列表
   *
   * @param state - ContactState 实例
   * @param friends - 好友列表
   */
  setFriends(state: ContactState, friends: FriendshipResponse[]): void {
    state.friends = friends;
  }

  /**
   * 设置创建成功的会话 ID
   *
   * @param state - ContactState 实例
   * @param conversationId - 会话 ID
   */
  setCreatedConversationId(state: ContactState, conversationId: string): void {
    state.createdConversationId = conversationId;
  }

  /**
   * 清空所有字段
   *
   * @param state - ContactState 实例
   */
  clearFields(state: ContactState): void {
    state.friends = [];
    state.createdConversationId = '';
  }
}
