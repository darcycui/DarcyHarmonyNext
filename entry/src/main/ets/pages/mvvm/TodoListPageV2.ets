/**
 * TodoListPageV2 - V2 版待办列表页面
 *
 * 使用 @ComponentV2 + @Local 配合 TodoListViewModelV2（@ObservedV2）
 * 展示 V2 状态管理的标准用法：
 *   - 加载中 → LoadingProgress
 *   - 加载完成 → 渲染列表、全选、事项交互
 *   - 加载失败 → 显示错误信息
 *
 * ─── 架构流向 ─────────────────────────────────────
 *   @ComponentV2 View → @ObservedV2 ViewModel → UseCase → Repository
 */
import { common } from '@kit.AbilityKit';

import TodoListViewModelV2 from './viewmodel/TodoListViewModelV2';
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
   * 2. 调用 onInit() 触发首次数据加载（由 BaseViewModel 管理）
   */
  aboutToAppear(): void {
    this.viewModel.setContext(this.context);
    this.viewModel.onInit();
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
              this.viewModel.chooseAll();
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
              this.viewModel.toggleTaskFinish(name);
            },
            onAddSuffix: (name: string) => {
              this.viewModel.addNameSuffix(name);
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
