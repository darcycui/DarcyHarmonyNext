/**
 * TodoListRepository - 待办列表数据仓库
 *
 * 职责：
 *  - 封装待办列表的数据访问逻辑（Rawfile、网络、DB 等）
 *  - 通过 BaseRepository 获得统一的错误处理和重试能力
 *  - 对上层（UseCase）屏蔽数据来源细节
 *
 * 架构流向：
 *   GetTasksUseCase → TodoListRepository → Rawfile / HttpUtil / Dao
 *
 * 使用示例：
 * ```typescript
 * const repo = new TodoListRepository();
 * const tasks = await repo.fetchTasks(context);
 * ```
 */
import { BaseRepository } from 'static_library_common/src/main/ets/base/mvvm/BaseRepository';
import ThingsEntity from '../models/ThingsEntity';
import { common } from '@kit.AbilityKit';
import util from '@ohos.util';
import { Log } from 'static_library_common';

export class TodoListRepository extends BaseRepository {
  /**
   * 从 Rawfile 获取任务列表
   * 使用基类 safeCall 包装，统一异常处理
   *
   * @param context Context 上下文
   * @returns 任务模型数组
   */
  async fetchTasksFromRawFile(context: common.Context): Promise<ThingsEntity[]> {
    return this.safeCall(async () => {
      Log.log(`[TodoListRepository] fetchTasksFromRawFile start`);

      // 模拟网络延迟
      await new Promise<void>(resolve => setTimeout(resolve, 500));

      const rawData = await context.resourceManager.getRawFileContent('defaultTasks.json');
      const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      const jsonString = textDecoder.decodeToString(rawData, { stream: false });

      Log.log(`[TodoListRepository] fetchTasksFromRawFile end`);

      // todo ⚠️ 必须使用 new ThingsModel() 创建实例，而非 JSON.parse 直接转换
      // JSON.parse 返回的普通对象不具备 @ObservedV2 + @Trace 观测能力，
      // 直接用 as 断言得到的普通对象无法触发 UI 刷新（属性变化不会被观测到）
      const rawArray: ThingsEntity[] = JSON.parse(jsonString);
      const result: ThingsEntity[] = [];
      for (let i = 0; i < rawArray.length; i++) {
        const rawItem: ThingsEntity = rawArray[i];
        const model = new ThingsEntity();
        model.thingsName = rawItem.thingsName;
        model.isFinish = rawItem.isFinish;
        result.push(model);
      }
      return result;
    }).catch(() => {
      Log.error('[TodoListRepository] fetchTasksFromRawFile 异常');
      const result: ThingsEntity[] = [];
      return result;
    });
  }

  /**
   * 带重试的获取任务列表
   * 适用于网络不稳定场景
   */
  async fetchTasksWithRetry(context: common.UIAbilityContext): Promise<ThingsEntity[]> {
    return this.safeCallWithRetry(
      () => this.fetchTasksFromRawFile(context),
      2, // 最多重试 2 次
      1000  // 间隔 1 秒
    );
  }

  /**
   * 保存任务列表（示例）
   * 子类可扩展为写入 DB 或 Preferences
   */
  async saveTasks(tasks: ThingsEntity[]): Promise<void> {
    return this.safeCall(async () => {
      Log.log(`[TodoListRepository] saveTasks: ${tasks.length} items`);
      // TODO: 实现实际的持久化逻辑
      // 例如：写入 Preferences / RDB / 网络
    });
  }

  /**
   * 更新单个任务（示例）
   */
  async updateTask(task: ThingsEntity): Promise<void> {
    return this.safeCall(async () => {
      Log.log(`[TodoListRepository] updateTask: ${task.thingsName}`);
      // TODO: 实现实际的更新逻辑
    });
  }

  /**
   * 删除任务（示例）
   */
  async deleteTask(thingsName: string): Promise<void> {
    return this.safeCall(async () => {
      Log.log(`[TodoListRepository] deleteTask: ${thingsName}`);
      // TODO: 实现实际的删除逻辑
    });
  }
}
