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
 *   ✅ 状态统一封装到 TodoListState，由 TodoListReducer 负责修改
 *
 * ─── View 层使用示例 ─────────────────────────────────────
 * 注意：V2 ViewModel 需要配合 @ComponentV2 + @Local/@Param 使用
 *
 * ```typescript
 * @Entry
 * @ComponentV2
 * struct TodoListPageV2 {
 *   @Local viewModel: TodoListViewModelV2 = new TodoListViewModelV2();
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
 *         // 通过 state 读取数据
 *         AllChooseComponentV2({
 *           isChoosen: this.viewModel.state.isChoosen,
 *           ...
 *         })
 *       }
 *     }
 *   }
 * }
 * ```
 *
 * ─── 架构流向 ─────────────────────────────────────
 *   View (@ComponentV2)
 *     → ViewModel (@ObservedV2) 持有 @Trace state: TodoListState
 *     → ViewModel 方法委托 Reducer 修改 state
 *     → Reducer 原地修改 @Trace 属性触发 UI 重渲染
 */
import { BaseViewModel } from 'static_library_common/src/main/ets/base/mvvm/BaseViewModel';
import { GetTasksUseCase } from '../usecase/GetTasksUseCase';
import ThingsEntity from '../../../models/ThingsEntity';
import { common } from '@kit.AbilityKit';
import {
  LoadTasksIntent,
  ToggleChooseAllIntent,
  ToggleTaskFinishIntent,
  AddNameSuffixIntent
} from '../intent/TodoListIntent';
import { BaseIntent, Contexts, Log } from 'static_library_common';
import TodoListState from '../state/TodoListState';
import TodoListReducer from '../reducer/TodoListReducer';

@ObservedV2
export default class TodoListViewModelV2 extends BaseViewModel {
  // ─── 页面统一状态对象（@Trace 实现细粒度刷新） ────────

  /** 统一状态：封装 isChoosen + things */
  @Trace state: TodoListState = new TodoListState();

  // ─── 依赖注入（简洁起见使用手动构造，正式项目可用 DI 框架） ──
  private getTasksUseCase: GetTasksUseCase = new GetTasksUseCase();

  // ─── Reducer（负责状态修改） ──────────────────────
  private reducer: TodoListReducer = new TodoListReducer();

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
    await this.safeLoad(async (): Promise<void> => {
      const tasks: ThingsEntity[] = await this.getTasksUseCase.execute(Contexts.getContext());
      this.reducer.setTasks(this.state, tasks);
    });
  }

  /**
   * 切换全选状态
   * 委托 Reducer 修改 TodoListState，利用 @Trace 触发 UI 重渲染
   */
  chooseAll(): void {
    this.reducer.chooseAll(this.state);
  }

  /**
   * 切换单个事项完成状态
   * 委托 Reducer 修改 TodoListState，利用 @Trace 触发 UI 重渲染
   */
  toggleTaskFinish(thingsName: string): void {
    this.reducer.toggleTaskFinish(this.state, thingsName);
  }

  /**
   * 给事项名称添加后缀
   * 委托 Reducer 修改 TodoListState，利用 @Trace 触发 UI 重渲染
   */
  addNameSuffix(thingsName: string): void {
    this.reducer.addNameSuffix(this.state, thingsName);
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
