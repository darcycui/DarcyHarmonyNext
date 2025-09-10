import { NavigationHelper } from "../utils/NavigationHelper"

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function StaticInnerPageBuilder() {
  StaticInnerPage()
}

@Component
export struct StaticInnerPage {
  pathStack: NavPathStack = new NavPathStack()
  @State params: Map<string, string> = new Map()

  build() {
    NavDestination() {
      Column() {
        Text("StaticInnerPage")
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
        Text(JSON.stringify(this.params))
        Button("返回").width('100%')
          .onClick(() => {
            NavigationHelper.back(this.pathStack)
          })
      }
      .width("100%")
      .height("100%")
    }.title("静态库内部页面")

    .onReady((context: NavDestinationContext) => {
      // 从参数中获取 页面栈
      this.pathStack = context.pathStack
      // 接收参数
      this.params = context.pathInfo.param as Map<string, string>
    })
  }
}