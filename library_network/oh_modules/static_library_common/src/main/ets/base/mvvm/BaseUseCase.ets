import { Log } from "../../utils/Log";

/**
 * BaseUseCase - 业务用例基类
 *
 * 职责：
 *  - 编排单一业务场景的完整流程
 *  - 组合多个 Repository 调用、数据转换、校验逻辑
 *  - 保持 ViewModel 瘦身，业务逻辑下沉到此层
 *
 * 架构流向：
 *   ViewModel → UseCase → Repository → HttpUtil / Dao
 *
 * 使用示例：
 * ```typescript
 * export class GetTasksUseCase extends BaseUseCase<void, TaskModel[]> {
 *   constructor(private todoRepo: TodoListRepository) {
 *     super();
 *   }
 *
 *   async execute(params: void): Promise<TaskModel[]> {
 *     // 可在此处做缓存判断、数据校验、多源合并等
 *     return this.todoRepo.fetchTasks();
 *   }
 * }
 * ```
 *
 * 泛型说明：
 *  @template T - 入参类型（无参数时使用 void）
 *  @template R - 返回值类型
 */
export abstract class BaseUseCase<T, R> {
  /**
   * 执行业务用例
   * @param params 业务入参
   * @returns 业务结果
   */
  abstract execute(params: T): Promise<R>;

  /**
   * 带错误包装的安全执行
   * 子类可直接使用，统一处理异常
   */
  protected async safeExecute(action: () => Promise<R>): Promise<R> {
    try {
      return await action();
    } catch {
      Log.error(`[BaseUseCase] 用例执行失败`);
      throw new Error('业务异常');
    }
  }
}

/**
 * 无参用例的便捷基类
 * 适用于无需参数的查询场景
 */
export abstract class BaseNoParamUseCase<R> extends BaseUseCase<void, R> {
  execute(params: void): Promise<R> {
    return this.build();
  }

  protected abstract build(): Promise<R>;
}
