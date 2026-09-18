/**
 * AcceptFriendReducer - 好友申请页面状态 Reducer
 *
 * 继承 IReducer，负责统一修改 AcceptFriendState 对象的值。
 * 所有方法采用原地修改（mutate in-place）模式，利用 @Trace 的细粒度响应触发组件重渲染。
 */
import { IReducer } from 'static_library_common';
import { ApplyFriendResponse } from 'library_network';
import AcceptFriendState from '../state/AcceptFriendState';

export default class AcceptFriendReducer implements IReducer {
  /**
   * 设置好友请求列表
   *
   * @param state - AcceptFriendState 实例
   * @param requests - 好友请求列表
   */
  setFriendRequests(state: AcceptFriendState, requests: ApplyFriendResponse[]): void {
    state.friendRequests = requests;
  }

  /**
   * 移除已处理的好友请求
   *
   * @param state - AcceptFriendState 实例
   * @param requestId - 已处理的请求 ID
   */
  removeFriendRequest(state: AcceptFriendState, requestId: number): void {
    state.friendRequests = state.friendRequests.filter(
      (item: ApplyFriendResponse) => item.id !== requestId
    );
  }

  /**
   * 清空所有字段
   *
   * @param state - AcceptFriendState 实例
   */
  clearFields(state: AcceptFriendState): void {
    state.friendRequests = [];
  }
}
