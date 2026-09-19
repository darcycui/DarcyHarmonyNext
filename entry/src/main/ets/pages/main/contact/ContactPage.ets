import { Log, NavigationUtil, ScreenPhase, ToastUtil } from 'static_library_common';
import { FriendshipResponse } from 'library_network';
import { PAGE_APPLY_FRIEND, PAGE_ACCEPT_FRIEND, PAGE_CHAT_ENTRY } from '../../PageName';
import ContactViewModel from './viewmodel/ContactViewModel';
import { FetchFriendsIntent, CreateConversationIntent } from './intent/ContactIntent';

@ComponentV2
export struct ContactPage {
  @Param activeTabIndex: number = 0
  @Local selfTabIndex: number = 1

  @Monitor('activeTabIndex')
  onActiveTabIndexChange(monitor: IMonitor) {
    Log.log(`触发ContactPage activeTabIndex`)
    monitor.dirty.forEach((path: string) => {
      Log.log(`path=${path}`)
      Log.log(`changed from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`)
    })
    if (this.activeTabIndex !== this.selfTabIndex) {
      Log.log('ContactPage 无需刷新')
      return
    }
    Log.warn('ContactPage 需要刷新')
    this.viewModel.dispatch(new FetchFriendsIntent())
  }

  @Local viewModel: ContactViewModel = new ContactViewModel();

  // Navigation 路由栈控制器
  @Consumer('HomePathStack') pathStack: NavPathStack = new NavPathStack();

  // 获取好友展示名（优先昵称，其次用户名）
  private getFriendName(item: FriendshipResponse): string {
    return item.friend.username || item.friend.nickname || `用户${item.friend.id}`;
  }

  // 点击好友：先创建会话，成功后跳转聊天页
  private async openChatWithFriend(item: FriendshipResponse): Promise<void> {
    await this.viewModel.dispatch(new CreateConversationIntent(item.friend.id));
    if (!this.viewModel.state.screenState.isError) {
      const conversationId = this.viewModel.state.createdConversationId;
      NavigationUtil.startPage(this.pathStack, PAGE_CHAT_ENTRY, {
        'conversationId': conversationId,
        'userName': this.getFriendName(item)
      });
    } else {
      ToastUtil.showToast(this.getUIContext(), `创建会话失败: ${this.viewModel.state.screenState.errorMessage}`);
    }
  }

  build() {
    Column() {
      // 顶部标题栏（包含左右按钮）
      Row() {
        // 左上角：好友请求按钮
        Text('✉')
          .fontSize(22)
          .margin({ left: 16 })
          .onClick(() => {
            NavigationUtil.startPage(this.pathStack, PAGE_ACCEPT_FRIEND)
          })

        Text('联系人')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 右上角：添加好友按钮
        Text('+')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ right: 16 })
          .onClick(() => {
            NavigationUtil.startPage(this.pathStack, PAGE_APPLY_FRIEND)
          })
      }
      .width('100%')
      .height(50)
      .backgroundColor(Color.White)

      // 好友列表内容区
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
              this.viewModel.dispatch(new FetchFriendsIntent())
            })
        }
        .justifyContent(FlexAlign.Center)
      } else if (this.viewModel.state.friends.length === 0) {
        Text('暂无好友')
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({ top: 100 })
      } else {
        List() {
          ForEach(this.viewModel.state.friends, (item: FriendshipResponse, index: number) => {
            ListItem() {
              Row() {
                // 头像
                Image($r('app.media.yes'))
                  .width(48)
                  .height(48)
                  .borderRadius(24)
                  .margin({ left: 16 })

                Column() {
                  Text(this.getFriendName(item))
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color.Black)
                  Text(`ID: ${item.friend.id}`)
                    .fontSize(12)
                    .fontColor(Color.Gray)
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 12 })
                .layoutWeight(1)
              }
              .width('100%')
              .height(72)
              .padding({ left: 16, right: 16 })
              .clickEffect({ level: ClickEffectLevel.LIGHT })
            }
            .onClick(() => {
              this.openChatWithFriend(item)
            })
          }, (item: FriendshipResponse, index: number) => `${item.friend.id}_${index}`)
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ color: Color.Gray, strokeWidth: 0.5, startMargin: 76 })
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
  }

  // 生命周期日志
  pageName = 'ContactPage'
  aboutToAppear(): void {
    Log.log(`-->${this.pageName} aboutToAppear`)
    this.viewModel.dispatch(new FetchFriendsIntent())
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
