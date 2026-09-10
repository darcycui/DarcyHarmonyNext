import { Log } from "../../utils/Log";

/**
 * BaseViewModel - ViewModel 基类
 *
 * 装饰器：@ObservedV2 + @Trace（V2 状态管理）
 *
 * 职责：
 *  - 统一管理页面级状态（加载中、错误、空数据）
 *  - 提供 MVI 风格的 dispatch(intent) 统一入口（可选）
 *  - 支持纯函数状态转换（局部 Reducer 理念）
 *  - 编排异步副作用（调用 UseCase → Repository）
 *
 * 架构流向：
 *   View (@ComponentV2) → ViewModel (@ObservedV2) → UseCase → Repository
 *
 * 使用示例（基础模式 - 多方法）：
 * ```typescript
 * @ObservedV2
 * export class TaskViewModel extends BaseViewModel {
 *   @Trace tasks: TaskModel[] = [];
 *
 *   async loadTasks(): Promise<void> {
 *     await this.safeLoad(async () => {
 *       this.tasks = await this.getTasksUseCase.execute();
 *     });
 *   }
 *
 *   toggleTask(id: string): void {
 *     this.tasks = this.tasks.map(t =>
 *       t.id === id ? { ...t, done: !t.done } : t
 *     );
 *   }
 * }
 * ```
 *
 * 使用示例（MVI 模式 - dispatch）：
 * ```typescript
 * // 定义页面 Intent
 * class TaskIntent {
 *   static readonly LOAD = 'LOAD';
 *   static readonly TOGGLE_TASK = 'TOGGLE_TASK';
 * }
 *
 * @ObservedV2
 * export class TaskViewModel extends BaseViewModel {
 *   @Trace tasks: TaskModel[] = [];
 *
 *   dispatch(intent: string, payload?: any): void {
 *     switch (intent) {
 *       case TaskIntent.LOAD:
 *         this.safeLoad(async () => {
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
  // ─── 全局状态字段 ─────────────────────────────────────────

  /** 页面是否正在加载（显示 Loading 指示器） */
  @Trace isLoading: boolean = false;

  /** 错误信息（非空时显示错误提示） */
  @Trace errorMessage: string = '';

  /** 是否加载完成（用于区分首次加载与刷新） */
  @Trace isLoaded: boolean = false;

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
   * 安全加载包装器
   * 自动管理 isLoading / errorMessage / isLoaded 状态
   *
   * @param action 实际的异步加载逻辑
   */
  protected async safeLoad(action: () => Promise<void>): Promise<void> {
    if (this.isLoading) {
      return; // 防止重复请求
    }

    this.isLoading = true;
    this.errorMessage = '';

    try {
      await action();
      this.isLoaded = true;
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      this.errorMessage = message;
      Log.error(`[BaseViewModel] 加载失败: ${message}`);
    } finally {
      this.isLoading = false;
    }
  }

  /**
   * 带 Loading 状态的操作包装器（适用于非首次加载的刷新/提交）
   *
   * @param action 实际的异步操作
   */
  protected async safeAction(action: () => Promise<void>): Promise<void> {
    this.errorMessage = '';
    try {
      await action();
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      this.errorMessage = message;
      Log.error(`[BaseViewModel] 操作失败: ${message}`);
    }
  }

  /**
   * 重置错误状态
   */
  clearError(): void {
    this.errorMessage = '';
  }

  /**
   * 重置 ViewModel 到初始状态
   */
  reset(): void {
    this.isLoading = false;
    this.errorMessage = '';
    this.isLoaded = false;
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

