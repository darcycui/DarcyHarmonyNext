/**
 * AllChooseComponentV2 - V2 版全选/取消全选按钮组件
 *
 * 使用 @ComponentV2 + @Param 接收父组件传递的状态与回调。
 * 对比 V1 (@Component + @Link)：
 *   ✅ @Param 单向数据流，状态提升至父组件
 *   ✅ 通过回调函数（@Event 风格）通知父组件状态变更
 *
 * ─── Props ───────────────────────────────────────
 * @Param isChoosen    : boolean   - 当前是否全选
 * @Param onChooseAll  : () => void - 点击按钮的回调
 */
@ComponentV2
export struct AllChooseComponentV2 {
  /**
   * @Param 接收父组件传入的 isChoosen 状态（只读）
   * 与 V1 的 @Link 相比，V2 使用 @Param 实现单向数据流，
   * 子组件不直接修改父组件状态，而是通过回调通知
   */
  @Param isChoosen: boolean = false;

  /**
   * 点击全选按钮的回调函数
   * 由父组件（TodoListPageV2）传入，实际调用 viewModel.chooseAll()
   */
  @Param onChooseAll: () => void = () => {};

  build() {
    Row() {
      Button(`${this.isChoosen ? '取消全选' : '全选'}`, { type: ButtonType.Capsule })
        .onClick(() => {
          this.onChooseAll();
        })
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .backgroundColor('#f7f6cc74')
    }
    .padding({ left: this.isChoosen ? 15 : 0 })
    .width('100%')
    .margin({ top: 10, bottom: 10 })
  }
}
