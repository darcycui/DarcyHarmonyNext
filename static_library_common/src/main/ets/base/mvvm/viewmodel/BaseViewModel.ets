import { Log } from "../../../utils/Log";
import ScreenState, { ScreenPhase } from "../state/substate/ScreenState";

/**
 * BaseViewModel - ViewModel 基类
 *
 * 装饰器：@ObservedV2 + @Trace（V2 状态管理）
 *
 * 职责：
 *  - 提供 MVI 风格的 dispatch(intent) 统一入口（可选）
 *  - 支持纯函数状态转换（局部 Reducer 理念）
 *  - 编排异步副作用（调用 UseCase → Repository）
 *  - safeLoad 统一管理 loading/error/success 状态流转（screenState 由子类自己的 State 持有）
 *
 * 架构流向：
 *   View (@ComponentV2) → ViewModel (@ObservedV2) → UseCase → Repository
 *
 * 使用示例（基础模式 - 多方法）：
 * ```typescript
 * @ObservedV2
 * export class TaskViewModel extends BaseViewModel {
 *   @Trace state: TaskState = new TaskState();
 *
 *   async loadTasks(): Promise<void> {
 *     await this.safeLoad(this.state.screenState, async () => {
 *       this.tasks = await this.getTasksUseCase.execute();
 *     });
 *   }
 * }
 * ```
 *
 * 使用示例（MVI 模式 - dispatch）：
 * ```typescript
 * class TaskIntent {
 *   static readonly LOAD = 'LOAD';
 *   static readonly TOGGLE_TASK = 'TOGGLE_TASK';
 * }
 *
 * @ObservedV2
 * export class TaskViewModel extends BaseViewModel {
 *   @Trace state: TaskState = new TaskState();
 *
 *   dispatch(intent: string, payload?: any): void {
 *     switch (intent) {
 *       case TaskIntent.LOAD:
 *         this.safeLoad(this.state.screenState, async () => {
 *           this.tasks = await this.getTasksUseCase.execute();
 *         });
 *         break;
 *       case TaskIntent.TOGGLE_TASK:
 *         this.toggleTask(payload);
 *         break;
 *     }
 *   }
 * }
 * ```
 */
@ObservedV2
export abstract class BaseViewModel {
  /** 首次加载完成标记（避免重复触发 aboutToAppear 逻辑） */
  private _initialized: boolean = false;

  // ─── 生命周期 ─────────────────────────────────────────────

  /**
   * 页面初始化时的默认加载行为
   * 由 aboutToAppear 中调用
   */
  async onInit(): Promise<void> {
    if (this._initialized) {
      return;
    }
    this._initialized = true;
    await this.doLoad();
  }

  /**
   * 页面实际的加载逻辑
   * 子类重写以提供具体的数据加载行为
   */
  protected async doLoad(): Promise<void> {
    // 默认空实现，子类按需覆盖
  }

  // ─── 状态管理工具方法 ─────────────────────────────────────

  /**
   * 安全加载数据 异步
   *
   * @param screenState 子类 State 中持有的 ScreenState 实例
   * @param action 实际的异步加载逻辑
   */
  protected async safeLoad(screenState: ScreenState, action: () => Promise<void>): Promise<void> {
    if (screenState.isLoadingPhase) {
      return; // 防止重复请求
    }

    screenState.phase = ScreenPhase.LOADING;

    try {
      await action();
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      screenState.setError(0, message);
      Log.error(`[BaseViewModel] 加载失败: ${message}`);
    } finally {
      if (!screenState.isError) {
        screenState.phase = ScreenPhase.SUCCESS;
      }
    }
  }

  /**
   * 重置 _initialized 标记（子类可调用以支持重新初始化）
   */
  protected resetInitialized(): void {
    this._initialized = false;
  }

  // ─── MVI Intent 分发（可选，子类可重写） ─────────────────

  /**
   * 分发 Intent 的统一入口（MVI 模式）
   *
   * 对于复杂页面，统一走 dispatch 路径可以让状态变更可追踪。
   * 简单页面直接用独立方法更直观。
   *
   * @param intent  意图标识（建议用静态常量定义在子类中）
   * @param payload 可选参数
   */
  dispatch(intent: string, payload?: object): void {
    // 基类默认空实现，子类重写以支持 Intent 模式
    Log.warn(`[BaseViewModel] dispatch 未实现: intent=${intent}`);
  }
}
