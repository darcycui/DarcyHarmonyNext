import { Log, NavigationUtil, ToastUtil } from 'static_library_common';
import { ChatItem } from '../../../models/ui/im/ChatItem';
import { ChatItemComponent } from './views/ChatItemComponent';
import { ChatDataSource } from './datasource/ChatDataSource';
import ChatEntryViewModel from './viewmodel/ChatEntryViewModel';
import { LoadChatMessagesIntent, SendChatMessageIntent } from './intent/ChatIntent';
import { window } from '@kit.ArkUI';
import { PAGE_USER_INFO } from '../../PageName';

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function ChatEntryBuilder() {
  ChatEntryPage()
}

@Builder
export function NavigationBuilder() {
  ChatEntryPage()
}

@ComponentV2
export struct ChatEntryPage {
  @Local keyboardHeight: number = 0;
  @Local input: string = '';
  @Local private message: string = '消息';
  @Local viewModel: ChatEntryViewModel = new ChatEntryViewModel();
  private lazyChatDataSource: ChatDataSource = new ChatDataSource();
  // Navigation 路由 栈控制器 @Consumer跨组件传递
  @Consumer('HomePathStack') pathStack: NavPathStack = new NavPathStack();

  // 路由参数
  pageParam: Map<string, string> = new Map();
  private scroller: Scroller = new Scroller()

  @Monitor('viewModel.state.messages')
  onMessagesChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      Log.log(`ChatEntryPage messages changed: ${path}`)
    })
    this.lazyChatDataSource.reloadData(this.viewModel.state.messages)
    this.scrollToLastItem()
  }

  aboutToAppear(): void {
    Log.log(`-->ChatEntryPage aboutToAppear`)
    this.viewModel.dispatch(new LoadChatMessagesIntent())
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

  private async sendMessage(): Promise<void> {
    const content: string = this.input.trim()
    if (content.length === 0) {
      ToastUtil.showToast(this.getUIContext(), '请输入发送内容')
      return
    }
    await this.viewModel.dispatch(new SendChatMessageIntent(content))
    if (this.viewModel.state.screenState.isError) {
      ToastUtil.showToast(this.getUIContext(), `发送失败: ${this.viewModel.state.screenState.errorMessage}`)
      return
    }
    this.input = ''
    this.getUIContext().getFocusController().clearFocus()
  }

  build() {
    NavDestination() {
      Column() {
        Stack() {
          Text(this.message)
            .fontSize(20)
            .fontColor(Color.Black)
          Row() {
            Image($r("app.media.mouse")).width(34).height(34).margin({ left: 16 })
              .onClick(() => {
                ToastUtil.showToast(this.getUIContext(), '头像')
              })
          }.width('100%')
        }.width('100%').height(60).backgroundColor(Color.Blue)

        List({ scroller: this.scroller }) {
          LazyForEach(this.lazyChatDataSource, (item: ChatItem, index: number) => {
            ListItem() {
              ChatItemComponent({ model: item })
            }.width('100%').onClick(() => {
              NavigationUtil.startPage(this.pathStack, PAGE_USER_INFO, { "key": "value", "userName": item.from })
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
              this.sendMessage()
            })
        }.width('100%').height(50).backgroundColor(Color.Blue)
      }
      .height('100%')
      .width('100%')
    }
    .title('聊天')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
      this.pageParam = context.pathInfo.param as Map<string, string>
      Log.info(`ChatEntryPage pageParam: ${JSON.stringify(this.pageParam)}`)
    })
  }

  onPageShow(): void {
    Log.debug(`-->ChatEntryPage onPageShow`)
  }

  onPageHide(): void {
    Log.warn(`-->ChatEntryPage onPageHide`)
  }

  aboutToDisappear(): void {
    Log.error(`-->ChatEntryPage aboutToDisappear`)
  }
}
