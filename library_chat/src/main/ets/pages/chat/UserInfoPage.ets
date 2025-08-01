import map from "@hms.core.map.map";

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function ChatUserInfoBuilder() {
  UserInfoPage()
}


@Component
@Preview
export struct UserInfoPage {
  @Prop userName: string = 'Default';
  @State pageParam: Map<string, string> = new Map();
  pathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    
  }

  build() {
    NavDestination() {
      Row() {
        Column() {
          Text(this.userName)
            .fontSize($r('app.float.page_text_font_size'))
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.userName = `Welcome ${this.userName}`;
            })
          Text(this.pageParam['key'])
        }
        .width('100%')
      }
      .height('100%')
    }.title('UserInfoPage')
    .onReady((context: NavDestinationContext) => {
      // 从参数中获取 页面栈
      this.pathStack = context.pathStack;
      this.pageParam = context.pathInfo.param as Map<string, string>;
      // 接收参数
      this.userName = this.pageParam['userName'];
    })
  }
}
