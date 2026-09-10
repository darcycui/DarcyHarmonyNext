/**
 * TodoListPageV2 - V2 版待办列表页面
 *
 * 使用 @ComponentV2 + @Local 配合 TodoListViewModelV2（@ObservedV2）
 * 展示 V2 状态管理的标准用法：
 *   - 加载中 → LoadingProgress
 *   - 加载完成 → 渲染列表、全选、事项交互
 *   - 加载失败 → 显示错误信息
 *
 * ─── MVI 架构流向 ─────────────────────────────────────
 *   @ComponentV2 View → dispatch(intent) → @ObservedV2 ViewModel → UseCase → Repository
 *   View 层不直接调用 ViewModel 方法，统一通过 dispatch 发送 Intent
 */
import { common } from '@kit.AbilityKit';

import TodoListViewModelV2 from './viewmodel/TodoListViewModelV2';
import {
  LoadTasksIntent,
  ToggleChooseAllIntent,
  ToggleTaskFinishIntent,
  AddNameSuffixIntent
} from './intent/TodoListIntent';
import { TodoComponentV2 } from './views/v2/TodoComponentV2';
import { AllChooseComponentV2 } from './views/v2/AllChooseComponentV2';
import { TodoListComponentV2 } from './views/v2/TodoListComponentV2';

@Entry
@ComponentV2
struct TodoListPageV2 {
  /**
   * @Local 持有 ViewModel（V2 版 @State）
   * ViewModel 内部使用 @ObservedV2 + @Trace 实现细粒度响应式
   */
  @Local viewModel: TodoListViewModelV2 = new TodoListViewModelV2();

  /**
   * 获取 UIAbilityContext，供 ViewModel 加载 Rawfile 数据
   */
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  /**
   * 页面初始化生命周期
   * 1. 将 Context 注入 ViewModel
   * 2. 通过 dispatch 触发首次数据加载（MVI 统一入口）
   */
  aboutToAppear(): void {
    this.viewModel.setContext(this.context);
    this.viewModel.dispatch(new LoadTasksIntent());
  }

  build() {
    Column() {
      // ── 首次加载中：显示 LoadingProgress ──
      if (this.viewModel.isLoading && !this.viewModel.isLoaded) {
        LoadingProgress()
          .width(50)
          .height(50)
          .layoutWeight(1)
      } else {
        // ── 加载完成：显示内容 ──
        Row({ space: 40 }) {
          // 标题：全部待办
          TodoComponentV2()
          // 全选按钮：传入 isChoosen 状态 + 切换回调
          AllChooseComponentV2({
            isChoosen: this.viewModel.isChoosen,
            onChooseAll: () => {
              this.viewModel.dispatch(new ToggleChooseAllIntent());
            }
          })
        }

        Column() {
          // ── 错误提示 ──
          if (this.viewModel.errorMessage) {
            Text(this.viewModel.errorMessage)
              .fontColor(Color.Red)
              .fontSize(16)
              .margin({ top: 10, bottom: 10 })
          }

          // ── 待办事项列表 ──
          // 传入 things 数组及事项交互回调
          TodoListComponentV2({
            things: this.viewModel.things,
            onToggleFinish: (name: string) => {
              const intent = new ToggleTaskFinishIntent(name);
              this.viewModel.dispatch(intent);
            },
            onAddSuffix: (name: string) => {
              const intent = new AddNameSuffixIntent(name);
              this.viewModel.dispatch(intent);
            }
          })
        }
        .layoutWeight(1)
        .width('100%')
      }
    }
    .height('100%')
    .width('100%')
    .margin({ top: 5, bottom: 5 })
    .backgroundColor('#90f1f3f5')
  }
}
