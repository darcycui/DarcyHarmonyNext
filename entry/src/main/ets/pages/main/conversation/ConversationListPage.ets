import { Log, NavigationUtil } from 'static_library_common';
import { ChatListItemBean } from '../../../models/ui/im/ChatListItemBean';
import { PAGE_CHAT_ENTRY } from '../../PageName';

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function ConversationListBuilder() {
  ConversationListPage()
}

@ComponentV2
export struct ConversationListPage {
  @Local conversationList: Array<ChatListItemBean> = [
    new ChatListItemBean(1, 'Tom', '你好，我是Tom', ''),
    new ChatListItemBean(2, 'Jerry', '你好，我是Jerry', ''),
    new ChatListItemBean(3, 'Mike', 'Hello!', ''),
    new ChatListItemBean(4, 'Lucy', 'Hey there!', ''),
  ]

  // Navigation 路由栈控制器
  @Consumer('HomePathStack') pathStack: NavPathStack = new NavPathStack();

  build() {
    Column() {
      List() {
        ForEach(this.conversationList, (item: ChatListItemBean, index: number) => {
          ListItem() {
            Row() {
              // 头像
              Image($r('app.media.yes'))
                .width(48)
                .height(48)
                .borderRadius(24)
                .margin({ left: 16 })

              Column() {
                Text(item.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.Black)
                Text(`ID: ${item.id}`)
                  .fontSize(12)
                  .fontColor(Color.Gray)
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 12 })
              .layoutWeight(1)

              Text(item.subTitle)
                .fontSize(12)
                .fontColor(Color.Gray)
                .margin({ right: 16 })
            }
            .width('100%')
            .height(72)
            .padding({ left: 16, right: 16 })
            .clickEffect({ level: ClickEffectLevel.LIGHT })
          }
          .onClick(() => {
            NavigationUtil.startPage(this.pathStack, PAGE_CHAT_ENTRY, { 'conversationId': `${item.id}`, 'userName': item.title })
          })
        }, (item: ChatListItemBean, index: number) => `${item.id}_${index}`)
      }
      .width('100%')
      .height('100%')
      .divider({ color: Color.Gray, strokeWidth: 0.5, startMargin: 76 })
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
  }

  // 生命周期日志
  pageName = 'ConversationListPage'
  aboutToAppear(): void {
    Log.log(`-->${this.pageName} aboutToAppear`)
  }
  onPageShow(): void {
    Log.debug(`-->${this.pageName} onPageShow`)
  }
  onPageHide(): void {
    Log.warn(`-->${this.pageName} onPageHide`)
  }
  aboutToDisappear(): void {
    Log.error(`-->${this.pageName} aboutToDisappear`)
  }
}
