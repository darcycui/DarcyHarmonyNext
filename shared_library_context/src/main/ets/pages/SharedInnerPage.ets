// darcyRefactor: 实现 Navigation 路由函数
@Builder
export function SharedInnerPageBuilder() {
  SharedInnerPage()
}

@Component
export struct SharedInnerPage {
  @State message: string = 'This is SharedInnerPage';

  build() {
    NavDestination() {
      Row() {
        Column() {
          Text(this.message)
            .fontSize(20)
            .margin({ bottom: 10 })
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
      }
      .height('100%')
    }
  }
}