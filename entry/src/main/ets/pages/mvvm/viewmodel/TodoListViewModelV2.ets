/**
 * TodoListViewModelV2 - V2 版本的 TodoList ViewModel 示例
 *
 * 展示如何从 V1 (@Observed + @Track) 迁移到 V2 (@ObservedV2 + @Trace)
 * 同时展示两种模式：
 *   - 简单模式：直接调用独立方法
 *   - MVI 模式：通过 dispatch(intent) 统一入口
 *
 * 对比 V1 版本 (TodoListViewModel.ets) 的关键改进：
 *   ✅ 继承 BaseViewModel，获得统一的 loading/error 状态管理
 *   ✅ @ObservedV2 + @Trace → 支持深层嵌套属性追踪
 *   ✅ 通过 UseCase → Repository 分层，ViewModel 不再直接依赖 Model
 *   ✅ 可选的 MVI dispatch 模式，便于复杂页面状态追踪
 *
 * ─── View 层使用示例 ─────────────────────────────────────
 * 注意：V2 ViewModel 需要配合 @ComponentV2 + @Local/@Param 使用
 *
 * ```typescript
 * @Entry
 * @ComponentV2
* struct TodoListPageV2 {
 * @Local viewModel: TodoListViewModelV2 = new TodoListViewModelV2();
 *
 *   aboutToAppear(): void {
 *     this.viewModel.onInit();
 *   }
 *
 *   build() {
 *     Column() {
 *       if (this.viewModel.isLoading) {
 *         LoadingProgress();
 *       } else {
 *         // 渲染列表...
 *       }
 *     }
 *   }
 * }
 * ```
 */
import { BaseViewModel } from 'static_library_common/src/main/ets/base/mvvm/BaseViewModel';
import { GetTasksUseCase } from '../usecase/GetTasksUseCase';
import ThingsModel from '../../../models/ThingsModel';
import { common } from '@kit.AbilityKit';
import {
  LoadTasksIntent,
  ToggleChooseAllIntent,
  ToggleTaskFinishIntent,
  AddNameSuffixIntent
} from '../intent/TodoListIntent';
import { BaseIntent, Log } from 'static_library_common';

@ObservedV2
export default class TodoListViewModelV2 extends BaseViewModel {
  // ─── 页面状态字段（@Trace 实现细粒度刷新） ─────────────

  /** 是否全选 */
  @Trace isChoosen: boolean = false;
  /** 事项列表 */
  @Trace things: ThingsModel[] = [];
  /** UIAbility 上下文（由 View 层注入） */
  private context: common.UIAbilityContext | null = null;
  // ─── 依赖注入（简洁起见使用手动构造，正式项目可用 DI 框架） ──

  private getTasksUseCase: GetTasksUseCase = new GetTasksUseCase();

  /**
   * 设置上下文（由 View 层在 aboutToAppear 中调用）
   */
  setContext(context: common.UIAbilityContext): void {
    this.context = context;
  }

  // ─── MVI dispatch 模式（统一入口） ────────────
  /**
   * 重写基类 dispatch 方法
   * 使用 switch-case 根据 intent 类型 分发到对应处理方法
   *
   * @param intent - 意图
   */
  dispatch(intent: BaseIntent): void {
    if (intent instanceof LoadTasksIntent) {
      this.loadTasks()
    } else if (intent instanceof ToggleChooseAllIntent) {
      this.chooseAll()
    } else if (intent instanceof ToggleTaskFinishIntent) {
      this.toggleTaskFinish(intent.thingsName)
    } else if (intent instanceof AddNameSuffixIntent) {
      this.addNameSuffix(intent.thingsName)
    } else {
      Log.warn(`[TodoListViewModelV2] 未处理的 Intent: ${intent}`)
    }
  }

  /**
   * 加载任务列表
   * 使用基类提供的 safeLoad 自动管理 loading/error 状态
   */
  async loadTasks(): Promise<void> {
    if (this.context === null) {
      this.errorMessage = 'Context 未设置';
      return;
    }
    await this.safeLoad(async (): Promise<void> => {
      const tasks: ThingsModel[] = await this.getTasksUseCase.execute(this.context as common.UIAbilityContext);
      this.things = tasks;
    });
  }

  /**
   * 切换全选状态
   * 利用 @ObservedV2 + @Trace 的细粒度响应能力，直接原地修改属性
   */
  chooseAll(): void {
    this.isChoosen = !this.isChoosen;
    for (let i = 0; i < this.things.length; i++) {
      this.things[i].isFinish = this.isChoosen;
    }
  }

  /**
   * 切换单个事项完成状态
   * 利用 @ObservedV2 + @Trace 的细粒度响应能力，直接原地修改属性
   */
  toggleTaskFinish(thingsName: string): void {
    for (let i = 0; i < this.things.length; i++) {
      const item: ThingsModel = this.things[i];
      if (item.thingsName === thingsName) {
        item.isFinish = !item.isFinish;
        break;
      }
    }
  }

  /**
   * 给事项名称添加后缀
   * 利用 @ObservedV2 + @Trace 的细粒度响应能力，直接原地修改属性
   */
  addNameSuffix(thingsName: string): void {
    for (let i = 0; i < this.things.length; i++) {
      const item: ThingsModel = this.things[i];
      if (item.thingsName === thingsName) {
        item.thingsName = item.thingsName + '啦';
        break;
      }
    }
  }

  // ─── 生命周期 ─────────────────────────────────────────

  /**
   * 页面初始化加载
   * 由 aboutToAppear 调用
   */
  protected async doLoad(): Promise<void> {
    await this.loadTasks();
  }
}
