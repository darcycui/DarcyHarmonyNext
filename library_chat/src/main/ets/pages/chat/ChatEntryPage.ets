import { Log, NavigationHelper, RouterHelper } from 'static_library_common';
import { ChatItem } from '../../models/ChatItem';
import { ChatItemComponent } from '../../views/ChatItemComponent';
import { ChatDataSource } from './datasource/ChatDataSource';

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function ChatEntryBuilder() {
  ChatEntryPage()
}

// darcyRefactor: 命名路由 router
@Entry({ routeName: 'pages/static/chat/ChatEntryPage' })
@Component
@Preview
export struct ChatEntryPage {
  @State private message: string = '消息';
  @State private chatList: Array<ChatItem> = [
    new ChatItem(200, 'Jerry', '你好 我是一只小老鼠'),
    new ChatItem(101, 'Tom', '你好 我是一只老猫'),
  ]
  private lazyChatDataSource: ChatDataSource = new ChatDataSource();

  // Navigation 路由 栈控制器
  pathStack: NavPathStack = new NavPathStack();
  // 路由参数
  pageParam: Map<string, string> = new Map();

  aboutToAppear(): void {
    this.lazyChatDataSource.pushData(new ChatItem(200, 'Jerry', '你好 我是一只小老鼠'))
    this.lazyChatDataSource.pushData(new ChatItem(101, 'Tom', '你好 我是一只老猫'))
  }

  build() {
    NavDestination() {
      Column() {
        Stack() {
          Text(this.message)
            .fontSize(20)
            .fontColor(Color.Black)
          Row() {
            Image($r("app.media.left_arrow")).width(34).height(34).margin({ left: 16 })
              .onClick(() => {
                // 返回
                RouterHelper.back(this.getUIContext())
              })
          }.width('100%')
        }.width('100%').height(60).backgroundColor(Color.Blue)

        List() {
          LazyForEach(this.lazyChatDataSource, (item: ChatItem, index: number) => {
            ListItem() {
              ChatItemComponent({ model: item })
            }.width('100%').onClick(() => {
              NavigationHelper.startPage(this.pathStack, 'ChatUserInfo', { "key": "value", "userName": item.from })
            })
          }, (item: ChatItem, index: number) => {
            return JSON.stringify(item) + index
          })
        }.width('100%').height('auto').layoutWeight(1)

        Row() {
          TextInput().layoutWeight(1)
          Button('发送').fontSize(20).fontColor(Color.Black).margin({ right: 16 })
            .onClick(()=>{
              this.lazyChatDataSource.pushData(new ChatItem(101, 'Tom', `来自老猫Tom的消息: ${Math.random() * 1000}`))
              Log.warn(`lazyChatDataSource: ${JSON.stringify(this.lazyChatDataSource)}`)
            })
        }.width('100%').height(50).backgroundColor(Color.Blue)
      }
      .height('100%')
      .width('100%')
    }
    .title("聊天")
    .onReady((context: NavDestinationContext) => {
      // 从参数中获取 页面栈
      this.pathStack = context.pathStack
      // 从参数中获取 路由参数
      this.pageParam = context.pathInfo.param as Map<string, string>
      Log.info(`pageParam: ${JSON.stringify(this.pageParam)}`)
    })
  }
}