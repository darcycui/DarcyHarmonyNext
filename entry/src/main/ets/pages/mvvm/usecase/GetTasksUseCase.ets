/**
 * GetTasksUseCase - 获取任务列表的业务用例
 *
 * 职责：
 *  - 编排获取任务列表的完整业务流程
 *  - 组合 Repository 调用 + 数据转换 + 校验逻辑
 *  - 保持 ViewModel 瘦身，业务逻辑集中在此层
 *
 * 架构流向：
 *   TodoListViewModelV2 → GetTasksUseCase → TodoListRepository
 *
 * 使用示例：
 * ```typescript
 * const useCase = new GetTasksUseCase(repository);
 * const tasks = await useCase.execute(context);
 * ```
 */
import { BaseUseCase } from 'static_library_common/src/main/ets/base/mvvm/usecase/BaseUseCase';
import { TodoListRepository } from '../../../repository/TodoListRepository';
import ThingsEntity from '../../../models/ThingsEntity';
import { common } from '@kit.AbilityKit';

/**
 * 获取任务列表用例
 * 入参：common.UIAbilityContext
 * 出参：ThingsModel[]
 */
export class GetTasksUseCase extends BaseUseCase<common.UIAbilityContext, ThingsEntity[]> {
  private repository: TodoListRepository;

  constructor(repository?: TodoListRepository) {
    super();
    // 支持依赖注入，便于单元测试
    this.repository = repository ?? new TodoListRepository();
  }

  /**
   * 实际执行逻辑
   * 可以在此处添加缓存判断、数据转换、权限校验等
   *
   * @param context Context 上下文
   * @returns 校验后的任务列表
   */
  async execute(context: common.Context): Promise<ThingsEntity[]> {
    return this.safeExecute(async () => {
      // Step 1: 尝试从缓存获取（示例）
      // const cached = CacheManager.getTasks();
      // if (cached) return cached;

      // Step 2: 从 Repository 获取数据
      const tasks = await this.repository.fetchTasksFromRawFile(context);

      // Step 3: 数据转换/校验
      const validTasks = this.validateTasks(tasks);

      // Step 4: 更新缓存（示例）
      // CacheManager.setTasks(validTasks);

      return validTasks;
    });
  }

  /**
   * 数据校验
   * 过滤掉无效数据
   */
  private validateTasks(tasks: ThingsEntity[]): ThingsEntity[] {
    return tasks.filter(task => {
      return task.thingsName !== undefined && task.thingsName.trim().length > 0;
    });
  }
}
