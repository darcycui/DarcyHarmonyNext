/**
 * ContactReducer - 联系人页面状态 Reducer
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
import { UserResponse } from 'library_network';
import ContactState from '../state/ContactState';

export default class ContactReducer implements IReducer {
  /**
   * 更新搜索手机号
   *
   * @param state - ContactState 实例
   * @param value - 新手机号
   */
  updateSearchPhone(state: ContactState, value: string): void {
    state.searchPhone = value;
  }

  /**
   * 设置搜索结果
   *
   * @param state - ContactState 实例
   * @param results - 搜索结果列表
   */
  setSearchResults(state: ContactState, results: UserResponse[]): void {
    state.searchResults = results;
  }

  /**
   * 清空搜索结果
   *
   * @param state - ContactState 实例
   */
  clearResults(state: ContactState): void {
    state.searchResults = [];
  }

  /**
   * 清空所有字段
   *
   * @param state - ContactState 实例
   */
  clearFields(state: ContactState): void {
    state.searchPhone = '';
    state.searchResults = [];
  }
}
