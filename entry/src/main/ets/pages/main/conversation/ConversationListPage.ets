import { Log, NavigationUtil, ScreenPhase } from 'static_library_common';
import { ConversationResponse } from 'library_network';
import { PAGE_CHAT_ENTRY } from '../../PageName';
import ConversationListViewModel from './viewmodel/ConversationListViewModel';
import { FetchConversationListIntent } from './intent/ConversationIntent';

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function ConversationListBuilder() {
  ConversationListPage()
}

@ComponentV2
export struct ConversationListPage {
  @Param activeTabIndex: number = 0
  @Local selfTabIndex: number = 0

  @Monitor('activeTabIndex')
  onActiveTabIndexChange(monitor: IMonitor) {
    Log.log(`触发ConversationListPage activeTabIndex`)
    monitor.dirty.forEach((path: string) => {
      Log.log(`path=${path}`)
      Log.log(`changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`)
    })
    if (this.activeTabIndex !== this.selfTabIndex) {
      Log.log('ConversationListPage 无需刷新')
      return
    }
    Log.warn('ConversationListPage 需要刷新')
    this.viewModel.dispatch(new FetchConversationListIntent())
  }

  @Local viewModel: ConversationListViewModel = new ConversationListViewModel();

  // Navigation 路由栈控制器
  @Consumer('HomePathStack') pathStack: NavPathStack = new NavPathStack();

  build() {
    Column() {
      if (this.viewModel.state.screenState.phase === ScreenPhase.LOADING) {
        LoadingProgress()
          .width(48)
          .height(48)
      } else if (this.viewModel.state.screenState.phase === ScreenPhase.ERROR) {
        Column() {
          Text(this.viewModel.state.screenState.errorMessage)
            .fontSize(14)
            .fontColor(Color.Red)
          Button('重试')
            .margin({ top: 16 })
            .onClick(() => {
              this.viewModel.dispatch(new FetchConversationListIntent());
            })
        }
        .justifyContent(FlexAlign.Center)
      } else {
        List() {
          ForEach(this.viewModel.state.conversationList, (item: ConversationResponse, index: number) => {
            ListItem() {
              Row() {
                // 头像
                Image($r('app.media.yes'))
                  .width(48)
                  .height(48)
                  .borderRadius(24)
                  .margin({ left: 16 })

                Column() {
                  Text(item.target.nickname || item.target.username)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color.Black)
                  Text(item.lastMsgContent || '暂无消息')
                    .fontSize(12)
                    .fontColor(Color.Gray)
                    .margin({ top: 4 })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 12 })
                .layoutWeight(1)

                Column() {
                  Text(item.lastMsgTime || '')
                    .fontSize(12)
                    .fontColor(Color.Gray)
                  if (item.unreadCount > 0) {
                    Text(`${item.unreadCount}`)
                      .fontSize(10)
                      .fontColor(Color.White)
                      .backgroundColor(Color.Red)
                      .borderRadius(10)
                      .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                      .margin({ top: 4 })
                  }
                }
                .alignItems(HorizontalAlign.End)
                .margin({ right: 16 })
              }
              .width('100%')
              .height(72)
              .padding({ left: 16, right: 16 })
              .clickEffect({ level: ClickEffectLevel.LIGHT })
            }
            .onClick(() => {
              NavigationUtil.startPage(this.pathStack, PAGE_CHAT_ENTRY, {
                'conversationId': item.conversationId,
                'userName': item.target.nickname || item.target.username
              })
            })
          }, (item: ConversationResponse, index: number) => `${item.conversationId}_${index}`)
        }
        .width('100%')
        .height('100%')
        .divider({ color: Color.Gray, strokeWidth: 0.5, startMargin: 76 })
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
  }

  // 生命周期日志
  pageName = 'ConversationListPage'
  aboutToAppear(): void {
    Log.log(`-->${this.pageName} aboutToAppear`)
    this.viewModel.dispatch(new FetchConversationListIntent());
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
