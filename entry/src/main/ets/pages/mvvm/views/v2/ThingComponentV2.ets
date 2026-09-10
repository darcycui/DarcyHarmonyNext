/**
 * ThingComponentV2 - V2 版待办事项单项组件
 *
 * 使用 @ComponentV2 + @Param 接收单个 ThingsModel 数据及交互回调。
 * 对比 V1 (@Component + @ObjectLink)：
 *   ✅ @Param 单向数据流，Model 使用 @ObservedV2 + @Trace 确保响应式
 *   ✅ 通过回调函数通知父组件执行状态变更
 *   ✅ ViewModel 采用不可变更新模式（replace array），组件随数据刷新
 *
 * ─── Props ───────────────────────────────────────
 * @Param item         : ThingsModel      - 单个待办事项数据
 * @Param onToggleFinish : (name: string) => void - 切换完成状态回调
 * @Param onAddSuffix    : (name: string) => void - 添加名称后缀回调
 */
import ThingsModel from '../../../../models/ThingsModel';
import { Log } from 'static_library_common';

@ComponentV2
export struct ThingComponentV2 {
  /**
   * @Param 接收单个待办事项数据
   * ThingsModel 使用 @ObservedV2 + @Trace，配合父组件替换整个数组触发刷新
   */
  @Param item: ThingsModel = new ThingsModel();

  /**
   * 切换完成状态回调
   * 由父组件传入，实际调用 viewModel.toggleTaskFinish(name)
   */
  @Param onToggleFinish: (name: string) => void = (name: string) => {};

  /**
   * 添加名称后缀回调
   * 由父组件传入，实际调用 viewModel.addNameSuffix(name)
   */
  @Param onAddSuffix: (name: string) => void = (name: string) => {};

  build() {
    Row({ space: 15 }) {
      // 完成状态图标（点击切换完成状态）
      // 注意：直接在 build() 中内联 Image，避免 @Builder 在 @ComponentV2 中
      // 对 @Param 依赖追踪失效导致 onClick 无法触发状态变更的问题
      if (this.item.isFinish) {
        Image($r('app.media.yes'))
          .width(28)
          .height(28)
          .onClick(() => {
            this.onToggleFinish(this.item.thingsName);
          })
      } else {
        Image($r('app.media.no'))
          .width(28)
          .height(28)
          .onClick(() => {
            this.onToggleFinish(this.item.thingsName);
          })
      }

      // 待办事项名称（点击添加后缀）
      Text(`${this.item.thingsName}`)
        .fontSize(20)
        .fontWeight(450)
        .decoration({
          type: this.item.isFinish ? TextDecorationType.LineThrough : TextDecorationType.None
        })
        .onClick(() => {
          this.onAddSuffix(this.item.thingsName);
        })
    }
    .height('8%')
    .width('90%')
    .padding({ left: 15 })
    .opacity(this.item.isFinish ? 0.3 : 1)
    .border({ width: 1 })
    .borderColor(Color.White)
    .borderRadius(25)
    .backgroundColor(Color.White)
  }
}
