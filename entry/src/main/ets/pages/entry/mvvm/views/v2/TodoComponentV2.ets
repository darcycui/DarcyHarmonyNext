/**
 * TodoComponentV2 - V2 版"全部待办"标题组件
 *
 * 纯展示性组件，使用 @ComponentV2 装饰。
 * 无状态依赖，仅渲染静态文本。
 */
@ComponentV2
export struct TodoComponentV2 {
  build() {
    Row() {
      Text('全部待办')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
    }
    .padding({ left: 15 })
    .width('50%')
    .margin({ top: 10, bottom: 10 })
  }
}
