/**
 * LoginReducer - 登录页面状态 Reducer
 *
 * 继承 BaseReducer，负责统一修改 LoginState 对象的值。
 * 所有方法采用原地修改（mutate in-place）模式，利用 @Trace 的细粒度响应
 * 触发组件重渲染，避免替换整个对象导致 @Param 无法识别新引用的问题。
 *
 * ─── 架构定位 ─────────────────────────────────────
 *   ViewModel 持有 LoginState 实例 + LoginReducer 实例
 *   ViewModel 方法内部委托 Reducer 修改状态
 *   Reducer 只负责纯状态转换，不涉及副作用（网络请求、数据库等）
 *
 * ─── 使用示例 ─────────────────────────────────────
 *   this.reducer.updateUserName(this.state, 'admin');
 *   this.reducer.updatePassword(this.state, '123456');
 */
import { IReducer } from 'static_library_common';
import LoginState from '../state/LoginState';

export default class LoginReducer implements IReducer {
  /**
   * 更新用户名
   * 直接原地修改 LoginState 的属性，利用 @Trace 触发 UI 重渲染
   *
   * @param state - LoginState 实例
   * @param value - 新用户名
   */
  updateUserName(state: LoginState, value: string): void {
    state.userName = value;
  }

  /**
   * 更新密码
   *
   * @param state - LoginState 实例
   * @param value - 新密码
   */
  updatePassword(state: LoginState, value: string): void {
    state.password = value;
  }

  /**
   * 清空输入字段
   *
   * @param state - LoginState 实例
   */
  clearFields(state: LoginState): void {
    state.userName = '';
    state.password = '';
  }
}
