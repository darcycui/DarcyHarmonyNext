import { Log } from "../../utils/Log";

/**
 * BaseRepository - 数据仓库基类
 *
 * 职责：
 *  - 统一封装数据访问层（网络请求、本地数据库、文件IO等）
 *  - 统一的错误处理 & 日志记录
 *  - 支持重试策略、缓存策略（按需扩展）
 *
 * 架构流向：
 *   UseCase → Repository → HttpUtil / Dao / RDB / Preferences
 *
 * 使用示例：
 * ```typescript
 * export class TodoListRepository extends BaseRepository {
 *   async fetchTasks(): Promise<TaskModel[]> {
 *     return this.safeCall(async () => {
 *       const raw = await this.httpClient.get('/tasks');
 *       return raw.map((item) => new TaskModel(item));
 *     });
 *   }
 * }
 * ```
 */
export abstract class BaseRepository {
  /**
   * 安全调用包装器
   * 统一捕获异常、格式化错误信息
   * @param action 实际数据访问操作
   * @returns 泛型结果
   * @throws 统一格式化后的 Error
   */
  protected async safeCall<T>(action: () => Promise<T>): Promise<T> {
    try {
      return await action();
    } catch {
      Log.error(`[BaseRepository] 操作失败`);
      throw new Error('操作失败');
    }
  }

  /**
   * 支持重试的调用包装器
   * @param action 实际数据访问操作
   * @param retries 最大重试次数（默认 3）
   * @param delayMs 重试间隔（默认 500ms）
   */
  protected async safeCallWithRetry<T>(
    action: () => Promise<T>,
    retries: number = 3,
    delayMs: number = 500
  ): Promise<T> {
    for (let attempt = 0; attempt <= retries; attempt++) {
      try {
        return await action();
      } catch {
        if (attempt < retries) {
          Log.warn(`[BaseRepository] 第 ${attempt + 1} 次重试`);
          await this.sleep(delayMs);
        }
      }
    }
    const errMsg: string = `重试 ${retries} 次后仍失败`;
    Log.error(`[BaseRepository] ${errMsg}`);
    throw new Error(errMsg);
  }

  /**
   * 格式化错误信息
   * 子类可重写以适配不同数据源（网络、DB等）的错误格式
   */
  protected formatError(error: Error): string {
    return error.message;
  }

  /**
   * 延迟工具方法
   */
  private sleep(ms: number): Promise<void> {
    return new Promise<void>((resolve: () => void): void => {
      setTimeout((): void => {
        resolve();
      }, ms);
    });
  }
}
