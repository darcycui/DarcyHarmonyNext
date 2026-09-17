import { Log, ToastUtil } from 'static_library_common';
import { FriendsItemBean } from '../../../models/ui/im/FriendsItemBean';

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function NavigationBuilder() {
  AcceptFriendPage()
}

@Component
struct AcceptFriendPage {
  @State friendRequests: Array<FriendsItemBean> = [
    new FriendsItemBean(2001, '王五', '五哥', '', 28, 1),
    new FriendsItemBean(2002, '赵六', '六弟', '', 35, 1),
    new FriendsItemBean(2003, '钱七', '七妹', '', 22, 0),
  ]

  // 模拟同意好友申请
  private acceptRequest(friend: FriendsItemBean): void {
    ToastUtil.showToast(this.getUIContext(), `已同意 ${friend.name} 的好友申请`)
    this.friendRequests = this.friendRequests.filter((item: FriendsItemBean) => item.id !== friend.id)
  }

  // 模拟拒绝好友申请
  private rejectRequest(friend: FriendsItemBean): void {
    ToastUtil.showToast(this.getUIContext(), `已拒绝 ${friend.name} 的好友申请`)
    this.friendRequests = this.friendRequests.filter((item: FriendsItemBean) => item.id !== friend.id)
  }

  build() {
    NavDestination() {
      Column() {
        if (this.friendRequests.length === 0) {
          Text('暂无好友申请')
            .fontSize(16)
            .fontColor(Color.Gray)
            .margin({ top: 100 })
        } else {
          List() {
            ForEach(this.friendRequests, (item: FriendsItemBean, index: number) => {
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
                    Text(`ID: ${item.id}`)
                      .fontSize(12)
                      .fontColor(Color.Gray)
                      .margin({ top: 4 })
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
            }, (item: FriendsItemBean, index: number) => `${item.id}_${index}`)
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
      // 从参数中获取路由栈
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
