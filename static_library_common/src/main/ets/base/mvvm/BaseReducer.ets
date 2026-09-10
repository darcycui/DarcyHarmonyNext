/**
 * BaseReducer - Reducer 基类
 *
 * Reducer 负责纯状态转换（state transformation），即根据当前状态和传入参数，
 * 产生新的状态（或原地修改状态）。
 *
 * 在 V2 状态管理（@ObservedV2 + @Trace）中，Reducer 方法应当直接原地修改
 * （mutate in-place）状态对象的属性，利用 @Trace 的细粒度响应触发组件重渲染。
 *
 * ─── 使用示例 ─────────────────────────────────────
 * ```typescript
 * export class TodoListReducer extends BaseReducer {
 *   chooseAll(state: TodoListState): void {
 *     state.isChoosen = !state.isChoosen;
 *     // ... 其他属性修改
 *   }
 * }
 * ```
 */
export class BaseReducer {
}
