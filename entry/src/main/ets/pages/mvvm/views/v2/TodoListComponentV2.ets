/**
 * TodoListComponentV2 - V2 版待办事项列表组件
 *
 * 使用 @ComponentV2 + @Param 接收事项数组及交互回调。
 * 对比 V1 (@Component + @ObjectLink)：
 *   ✅ @Param 单向数据流，父组件通过替换数组触发刷新
 *   ✅ 通过回调函数通知父组件执行事项操作
 *   ✅ 与 V2 ViewModel 的不可变更新模式（replace array）完美配合
 *
 * ─── Props ───────────────────────────────────────
 * @Param things         : ThingsModel[]          - 待办事项列表
 * @Param onToggleFinish : (name: string) => void - 切换完成状态回调
 * @Param onAddSuffix    : (name: string) => void - 添加名称后缀回调
 */
import ThingsEntity from '../../../../models/ThingsEntity';
import { ThingComponentV2 } from './ThingComponentV2';

@ComponentV2
export struct TodoListComponentV2 {
  /**
   * @Param 接收事项数组
   * 当父组件中 viewModel.things 被替换为新数组时，
   * @Trace 触发父组件重渲染，此处自动获取最新数据
   */
  @Param things: ThingsEntity[] = [];

  /**
   * 切换完成状态回调
   */
  @Param onToggleFinish: (name: string) => void = (name: string) => {};

  /**
   * 添加名称后缀回调
   */
  @Param onAddSuffix: (name: string) => void = (name: string) => {};

  build() {
    Column() {
      List() {
        ForEach(this.things,
          (item: ThingsEntity) => {
            ListItem() {
              ThingComponentV2({
                item: item,
                onToggleFinish: (name: string) => {
                  this.onToggleFinish(name);
                },
                onAddSuffix: (name: string) => {
                  this.onAddSuffix(name);
                }
              }).margin(5)
            }
          },
          (item: ThingsEntity) => {
            return item.thingsName;
          })
      }
      .width('100%')
    }
  }
}
