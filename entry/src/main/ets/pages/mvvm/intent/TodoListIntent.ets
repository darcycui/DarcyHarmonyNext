/**
 * TodoList 页面专属 Intent 定义
 *
 * 集中管理所有页面事件，便于追踪和调试。
 * 适用于复杂页面的 MVI 模式。
 */
export class TodoListIntent {
  /** 加载数据 */
  static readonly LOAD_TASKS: string = 'LOAD_TASKS';
  /** 切换全选 */
  static readonly TOGGLE_CHOOSE_ALL: string = 'TOGGLE_CHOOSE_ALL';
  /** 切换单个事项完成状态 */
  static readonly TOGGLE_TASK_FINISH: string = 'TOGGLE_TASK_FINISH';
  /** 添加事项名称后缀 */
  static readonly ADD_NAME_SUFFIX: string = 'ADD_NAME_SUFFIX';
}