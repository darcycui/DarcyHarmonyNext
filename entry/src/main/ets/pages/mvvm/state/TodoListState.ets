/**
 * TodoListState - TodoList 页面统一状态类
 *
 * 封装 TodoList 页面的所有可观察状态，配合 @ObservedV2 + @Trace 实现细粒度响应式。
 * ViewModel 通过持有此状态实例，并由 Reducer 统一修改状态值，实现状态与行为分离。
 *
 * 继承 BaseState，获得统一的 isLoading / errorMessage / isLoaded 基础状态管理。
 *
 * ─── 架构定位 ─────────────────────────────────────
 *   ViewModel 持有 @Trace state: TodoListState
 *   Reducer 负责修改 state 的属性值（mutate in-place）
 *   View 层通过 state.isChoosen / state.things 读取数据
 *
 * @ObservedV2 - 标记为可观察类
 * @Trace     - 标记属性为可观察，属性变化时触发关联组件重渲染
 */
import ThingsEntity from '../../../models/ThingsEntity';
import BaseState from 'static_library_common/src/main/ets/base/mvvm/BaseState';

@ObservedV2
export default class TodoListState extends BaseState {
  /** 是否全选 */
  @Trace isChoosen: boolean = false;
  /** 事项列表 */
  @Trace things: ThingsEntity[] = [];
}
