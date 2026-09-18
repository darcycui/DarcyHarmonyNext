import { Log, ToastUtil } from 'static_library_common';
import { ApplyFriendResponse } from 'library_network';
import AcceptFriendViewModel from './viewmodel/AcceptFriendViewModel';
import { AcceptFriendIntent } from './intent/AcceptFriendIntent';

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function NavigationBuilder() {
  AcceptFriendPage()
}

@ComponentV2
struct AcceptFriendPage {
  pathStack: NavPathStack = new NavPathStack();
  @Local viewModel: AcceptFriendViewModel = new AcceptFriendViewModel();

  // 同意好友申请（调用 ViewModel）
  private async acceptRequest(friend: ApplyFriendResponse): Promise<void> {
    ToastUtil.showToast(this.getUIContext(), `正在同意 ${friend.fromUser.username} 的好友申请...`)
    await this.viewModel.dispatch(new AcceptFriendIntent(friend.id, friend.fromUser.id));
    if (!this.viewModel.state.screenState.isError) {
      ToastUtil.showToast(this.getUIContext(), `已同意 ${friend.fromUser.username} 的好友申请`)
    } else {
      ToastUtil.showToast(this.getUIContext(), `同意失败: ${this.viewModel.state.screenState.errorMessage}`)
    }
  }

  // 拒绝好友申请（暂未实现）
  private rejectRequest(friend: ApplyFriendResponse): void {
    ToastUtil.showToast(this.getUIContext(), `已拒绝 ${friend.fromUser.username} 的好友申请`)
  }

  build() {
    NavDestination() {
      Column() {
        // 加载状态
        if (this.viewModel.state.screenState.isLoadingPhase) {
          LoadingProgress()
            .width(48)
            .height(48)
            .margin({ top: 100 })
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

        // 好友请求列表
        if (!this.viewModel.state.screenState.isLoadingPhase &&
          this.viewModel.state.friendRequests.length === 0) {
          Text('暂无好友申请')
            .fontSize(16)
            .fontColor(Color.Gray)
            .margin({ top: 100 })
        } else {
          List() {
            ForEach(this.viewModel.state.friendRequests, (item: ApplyFriendResponse, index: number) => {
              ListItem() {
                Row() {
                  // 头像
                  Image($r('app.media.yes'))
                    .width(48)
                    .height(48)
                    .borderRadius(24)

                  Column() {
                    Text(item.fromUser.username || item.fromUser.nickname || '未知用户')
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(Color.Black)
                    Text(`ID: ${item.fromUser.id}`)
                      .fontSize(12)
                      .fontColor(Color.Gray)
                      .margin({ top: 4 })
                    if (item.greeting) {
                      Text(item.greeting)
                        .fontSize(12)
                        .fontColor(Color.Gray)
                        .margin({ top: 2 })
                    }
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 12 })
                  .layoutWeight(1)

                  Row() {
                    Button('拒绝')
                      .fontSize(12)
                      .height(32)
                      .backgroundColor(Color.Gray)
                      .onClick(() => {
                        this.rejectRequest(item)
                      })
                    Button('同意')
                      .fontSize(12)
                      .height(32)
                      .margin({ left: 8 })
                      .onClick(() => {
                        this.acceptRequest(item)
                      })
                  }
                }
                .width('100%')
                .height(72)
                .padding({ left: 16, right: 16 })
              }
            }, (item: ApplyFriendResponse, index: number) => `${item.id}_${index}`)
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
    .title('好友申请')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }

  // 生命周期日志
  pageName = 'AcceptFriendPage'
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
