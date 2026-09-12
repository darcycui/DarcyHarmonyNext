/**
 * TodoListReducer - TodoList 页面状态 Reducer
 *
 * 继承 BaseReducer，负责统一修改 TodoListState 对象的值。
 * 所有方法采用原地修改（mutate in-place）模式，利用 @Trace 的细粒度响应
 * 触发组件重渲染，避免替换整个对象导致 @Param 无法识别新引用的问题。
 *
 * ─── 架构定位 ─────────────────────────────────────
 *   ViewModel 持有 TodoListState 实例 + TodoListReducer 实例
 *   ViewModel 方法内部委托 Reducer 修改状态
 *   Reducer 只负责纯状态转换，不涉及副作用（网络请求、数据库等）
 *
 * ─── 使用示例 ─────────────────────────────────────
 *   this.reducer.chooseAll(this.state);
 *   this.reducer.toggleTaskFinish(this.state, thingsName);
 */
import { IReducer } from 'static_library_common';
import TodoListState from '../state/TodoListState';
import ThingsEntity from '../../../models/ThingsEntity';

export default class TodoListReducer implements IReducer {
  /**
   * 切换全选状态
   * 直接原地修改 TodoListState 的属性，利用 @Trace 触发 UI 重渲染
   *
   * @param state - TodoList 页面状态对象
   */
  chooseAll(state: TodoListState): void {
    state.isChoosen = !state.isChoosen;
    for (let i = 0; i < state.things.length; i++) {
      state.things[i].isFinish = state.isChoosen;
    }
  }

  /**
   * 切换单个事项完成状态
   *
   * @param state      - TodoList 页面状态对象
   * @param thingsName - 待切换的事项名称
   */
  toggleTaskFinish(state: TodoListState, thingsName: string): void {
    for (let i = 0; i < state.things.length; i++) {
      const item: ThingsEntity = state.things[i];
      if (item.thingsName === thingsName) {
        item.isFinish = !item.isFinish;
        break;
      }
    }
  }

  /**
   * 给事项名称添加后缀"啦"
   *
   * @param state      - TodoList 页面状态对象
   * @param thingsName - 待添加后缀的事项名称
   */
  addNameSuffix(state: TodoListState, thingsName: string): void {
    for (let i = 0; i < state.things.length; i++) {
      const item: ThingsEntity = state.things[i];
      if (item.thingsName === thingsName) {
        item.thingsName = item.thingsName + '啦';
        break;
      }
    }
  }

  /**
   * 设置事项列表
   *
   * @param state - TodoList 页面状态对象
   * @param tasks - 新的事项列表
   */
  setTasks(state: TodoListState, tasks: ThingsEntity[]): void {
    state.things = tasks;
  }
}
