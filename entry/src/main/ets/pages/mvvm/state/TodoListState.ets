/**
 * TodoListState - TodoList 页面统一状态类
 *
 * 封装 TodoList 页面的所有可观察状态，配合 @ObservedV2 + @Trace 实现细粒度响应式。
 * ViewModel 通过持有此状态实例，并由 Reducer 统一修改状态值，实现状态与行为分离。
 *
 * 屏幕加载/错误状态由 ScreenState 统一管理，不再在子类中重复定义。
 *
 * ─── 架构定位 ─────────────────────────────────────
 *   ViewModel 持有 @Trace state: TodoListState
 *   Reducer 负责修改 state 的属性值（mutate in-place）
 *   View 层通过 state.isChoosen / state.things 读取数据
 *
 * @ObservedV2 - 标记为可观察类
 * @Trace     - 标记属性为可观察，属性变化时触发关联组件重渲染
 */
import { IState, ScreenState } from 'static_library_common';
import ThingsEntity from '../../../models/ThingsEntity';

@ObservedV2
export default class TodoListState implements IState {
  /** 屏幕状态（加载中/错误/成功等） */
  @Trace screenState: ScreenState = new ScreenState();
  /** 是否全选 */
  @Trace isChoosen: boolean = false;
  /** 事项列表 */
  @Trace things: ThingsEntity[] = [];
}
