/**
 * RegisterReducer - 注册页面状态 Reducer
 *
 * 继承 BaseReducer，负责统一修改 RegisterState 对象的值。
 * 所有方法采用原地修改（mutate in-place）模式，利用 @Trace 的细粒度响应
 * 触发组件重渲染，避免替换整个对象导致 @Param 无法识别新引用的问题。
 *
 * ─── 架构定位 ─────────────────────────────────────
 *   ViewModel 持有 RegisterState 实例 + RegisterReducer 实例
 *   ViewModel 方法内部委托 Reducer 修改状态
 *   Reducer 只负责纯状态转换，不涉及副作用（网络请求、数据库等）
 *
 * ─── 使用示例 ─────────────────────────────────────
 *   this.reducer.updateUserName(this.state, 'admin');
 *   this.reducer.updatePassword(this.state, '123456');
 *   this.reducer.updatePhone(this.state, '13800138000');
 *   this.reducer.updateNickname(this.state, 'nick');
 *   this.reducer.updateEmail(this.state, 'user@example.com');
 */
import { BaseReducer } from 'static_library_common';
import RegisterState from '../state/RegisterState';

export default class RegisterReducer extends BaseReducer {
  /**
   * 更新用户名
   *
   * @param state - RegisterState 实例
   * @param value - 新用户名
   */
  updateUserName(state: RegisterState, value: string): void {
    state.userName = value;
  }

  /**
   * 更新密码
   *
   * @param state - RegisterState 实例
   * @param value - 新密码
   */
  updatePassword(state: RegisterState, value: string): void {
    state.password = value;
  }

  /**
   * 更新手机号
   *
   * @param state - RegisterState 实例
   * @param value - 新手机号
   */
  updatePhone(state: RegisterState, value: string): void {
    state.phone = value;
  }

  /**
   * 更新昵称
   *
   * @param state - RegisterState 实例
   * @param value - 新昵称
   */
  updateNickname(state: RegisterState, value: string): void {
    state.nickname = value;
  }

  /**
   * 更新邮箱
   *
   * @param state - RegisterState 实例
   * @param value - 新邮箱
   */
  updateEmail(state: RegisterState, value: string): void {
    state.email = value;
  }

  /**
   * 清空输入字段
   *
   * @param state - RegisterState 实例
   */
  clearFields(state: RegisterState): void {
    state.userName = '';
    state.password = '';
    state.phone = '';
    state.nickname = '';
    state.email = '';
  }
}
