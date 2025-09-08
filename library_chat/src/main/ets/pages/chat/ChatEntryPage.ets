import { Log, NavigationHelper, RouterHelper, ToastHelper } from 'static_library_common';
import { ChatItem } from '../../models/ChatItem';
import { ChatItemComponent } from '../../views/ChatItemComponent';
import { ChatDataSource } from './datasource/ChatDataSource';
import { window } from '@kit.ArkUI';

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function ChatEntryBuilder() {
  ChatEntryPage()
}

@Component
@Preview
export struct ChatEntryPage {
  @State keyboardHeight: number = 0;
  @State input: string = '';
  @State private message: string = '消息';
  @State private chatList: Array<ChatItem> = [
    new ChatItem(200, 'Jerry', '你好 我是一只小老鼠'),
    new ChatItem(101, 'Tom', '你好 我是一只老猫'),
  ]
  private lazyChatDataSource: ChatDataSource = new ChatDataSource();
  // Navigation 路由 栈控制器 @Consume跨组件传递
  @Consume('appPathStack') pathStack: NavPathStack;

  // 路由参数
  pageParam: Map<string, string> = new Map();
  private scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    this.lazyChatDataSource.pushData(new ChatItem(200, 'Jerry', '你好 我是一只小老鼠'))
    this.lazyChatDataSource.pushData(new ChatItem(101, 'Tom', '你好 我是一只老猫'))
    // 监听软键盘弹出、收起
    let currentWindow = window.getLastWindow(this.getUIContext().getHostContext())
    currentWindow.then(window => {
      window.on('keyboardHeightChange', (height: number) => {
        this.keyboardHeight = height
        Log.info(`keyboardHeightChange: ${height}`)
        if (height > 0) {
          this.scrollToLastItem()
        }
      })
    })
  }

  private scrollToLastItem() {
    this.scroller.scrollEdge(Edge.Bottom)
  }

  build() {
    // NavDestination() {
      Column() {
        Stack() {
          Text(this.message)
            .fontSize(20)
            .fontColor(Color.Black)
          Row() {
            Image($r("app.media.mouse")).width(34).height(34).margin({ left: 16 })
              .onClick(() => {
                // 头像
                ToastHelper.showToast('头像')
              })
          }.width('100%')
        }.width('100%').height(60).backgroundColor(Color.Blue)

        List({ scroller: this.scroller }) {
          LazyForEach(this.lazyChatDataSource, (item: ChatItem, index: number) => {
            ListItem() {
              ChatItemComponent({ model: item })
            }.width('100%').onClick(() => {
              NavigationHelper.startPage(this.pathStack, 'ChatUserInfo', { "key": "value", "userName": item.from })
            })
          }, (item: ChatItem, index: number) => {
            return JSON.stringify(item) + index
          })
        }.width('100%').height('auto').layoutWeight(1).scrollBar(BarState.On)

        Row() {
          TextInput({ placeholder: "输入要发送的内容", text: this.input })
            .onChange((value: string, previewText?: PreviewText) => {
              this.input = value
            })
            .layoutWeight(1)
          Button('发送').fontSize(20).fontColor(Color.Black).margin({ right: 16 })
            .onClick(() => {
              this.lazyChatDataSource.pushData(new ChatItem(101, 'Tom', `来自老猫Tom的消息: ${Math.random() * 1000}`))
              Log.warn(`lazyChatDataSource: ${JSON.stringify(this.lazyChatDataSource)}`)
              this.input = ''
              // 收起键盘
              this.getUIContext().getFocusController().clearFocus()
              // 列表滑动到底部
              this.scrollToLastItem()
            })
        }.width('100%').height(50).backgroundColor(Color.Blue)
      }
      .height('100%')
      .width('100%')
    }
    // .title("聊天")
    // .onReady((context: NavDestinationContext) => {
    //   // 从参数中获取 页面栈
    //   this.pathStack = context.pathStack
    //   // 从参数中获取 路由参数
    //   this.pageParam = context.pathInfo.param as Map<string, string>
    //   Log.info(`pageParam: ${JSON.stringify(this.pageParam)}`)
    // })
  // }
}