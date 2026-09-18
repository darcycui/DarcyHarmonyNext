import { Log, NavigationUtil, ToastUtil } from 'static_library_common';
import { UserItemBean } from '../../../models/ui/im/UserItemBean';
import { UserManager } from 'library_login';
import ApplyFriendViewModel from './viewmodel/ApplyFriendViewModel';
import { ApplyFriendIntent, SearchUserIntent } from './intent/ContactIntent';

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function NavigationBuilder() {
  ApplyFriendPage()
}

@ComponentV2
struct ApplyFriendPage {
  @Local searchText: string = '13800138000'
  @Local searchResults: Array<UserItemBean> = []
  pathStack: NavPathStack = new NavPathStack();
  @Local viewModel: ApplyFriendViewModel = new ApplyFriendViewModel();

  // 搜索用户（调用 ViewModel）
  private async searchUser(): Promise<void> {
    if (this.searchText.length === 0) {
      ToastUtil.showToast(this.getUIContext(), '请输入手机号')
      return
    }
    this.viewModel.updateSearchPhone(this.searchText);
    await this.viewModel.dispatch(new SearchUserIntent(this.searchText));
    // 将搜索结果转换为 UserItemBean
    const results = this.viewModel.state.searchResults;
    this.searchResults = [];
    for (const user of results) {
      this.searchResults.push(
        new UserItemBean(user.id, user.username, user.phone, user.nickname, user.avatar, 0, user.gender)
      );
    }
  }

  // 申请好友（调用 ViewModel）
  private async applyFriend(userId: number): Promise<void> {
    const fromUserId = await UserManager.getUserID();
    if (!fromUserId) {
      ToastUtil.showToast(this.getUIContext(), '请先登录')
      return
    }
    await this.viewModel.dispatch(new ApplyFriendIntent(fromUserId, userId));
    if (!this.viewModel.state.screenState.isError) {
      ToastUtil.showToast(this.getUIContext(), `已向用户 ${userId} 发送好友申请`)
    } else {
      ToastUtil.showToast(this.getUIContext(), `申请失败: ${this.viewModel.state.screenState.errorMessage}`)
    }
  }

  build() {
    NavDestination() {
      Column() {
        // 搜索区域
        Row() {
          TextInput({ placeholder: '输入手机号搜索', text: this.searchText })
            .onChange((value: string) => {
              this.searchText = value
            })
            .layoutWeight(1)
            .height(40)
          Button('搜索')
            .fontSize(14)
            .height(40)
            .margin({ left: 8 })
            .onClick(() => {
              this.searchUser()
            })
        }
        .width('100%')
        .padding(16)

        // 加载状态
        if (this.viewModel.state.screenState.isLoadingPhase) {
          LoadingProgress()
            .width(48)
            .height(48)
        }

        // 错误信息
        if (this.viewModel.state.screenState.isError) {
          Text(this.viewModel.state.screenState.errorMessage)
            .fontSize(14)
            .fontColor(Color.Red)
            .textAlign(TextAlign.Center)
            .width('100%')
            .padding(16)
        }

        // 搜索结果列表
        List() {
          ForEach(this.searchResults, (item: UserItemBean, index: number) => {
            ListItem() {
              Row() {
                // 头像
                Image($r('app.media.yes'))
                  .width(48)
                  .height(48)
                  .borderRadius(24)

                Column() {
                  Text(item.name)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color.Black)
                  Text(`手机: ${item.phone}`)
                    .fontSize(12)
                    .fontColor(Color.Gray)
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 12 })
                .layoutWeight(1)

                Button('申请好友')
                  .fontSize(12)
                  .height(32)
                  .onClick(() => {
                    this.applyFriend(item.id)
                  })
              }
              .width('100%')
              .height(72)
              .padding({ left: 16, right: 16 })
            }
          }, (item: UserItemBean, index: number) => `${item.id}_${index}`)
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ color: Color.Gray, strokeWidth: 0.5, startMargin: 76 })
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
    }
    .title('添加好友')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }

  // 生命周期日志
  pageName = 'ApplyFriendPage'
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
