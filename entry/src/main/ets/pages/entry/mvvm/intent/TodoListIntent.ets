/**
 * TodoList 页面专属 Intent 定义
 *
 * 采用子类继承体系，每个 Intent 为独立子类，携带自身所需数据。
 * 所有子类直接继承 BaseIntent，dispatch 通过 instanceof 进行分支判断。
 *
 * ─── 使用示例 ───────────────────────────────────
 *   dispatch(new LoadTasksIntent())
 *   dispatch(new ToggleTaskFinishIntent(taskName))
 *   dispatch(new AddNameSuffixIntent(taskName))
 */
import { IIntent } from 'static_library_common';

export class TodoListIntent implements IIntent {
}

/**
 * 加载数据 Intent
 */
export class LoadTasksIntent extends TodoListIntent {
}

/**
 * 切换全选 Intent
 */
export class ToggleChooseAllIntent extends TodoListIntent {
}

/**
 * 切换单个事项完成状态 Intent
 */
export class ToggleTaskFinishIntent extends TodoListIntent {
  thingsName: string = ''

  constructor(thingsName: string) {
    super()
    this.thingsName = thingsName;
  }
}

/**
 * 添加事项名称后缀 Intent
 */
export class AddNameSuffixIntent extends TodoListIntent {
  thingsName: string = '';

  constructor(thingsName: string) {
    super();
    this.thingsName = thingsName;
  }
}
