import { UserManager } from 'library_login';
import { UserResponse } from 'library_network';
import { Log, NavigationUtil, ToastUtil } from 'static_library_common';
import { UserItemBean } from '../../../models/ui/im/UserItemBean';
import { PAGE_LOGIN, PAGE_START } from '../../PageName';

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function MineBuilder() {
  MinePage()
}

@ComponentV2
export struct MinePage {
  @Consumer('HomePathStack') pathStack: NavPathStack = new NavPathStack();
  // 模拟用户信息
  @Local userInfo: UserResponse = UserManager.getUserSync()

  // 模拟退出登录
  private logout(): void {
    ToastUtil.showToast(this.getUIContext(), '退出登录')
    NavigationUtil.startPage(this.pathStack, PAGE_LOGIN)
  }

  build() {
    Column() {
      // 用户信息区域
      Column() {
        // 头像
        Image($r('app.media.yes'))
          .width(200)
          .height(200)
          .borderRadius(100)
          .margin({ top: 40 })
          .onClick(() => {
            NavigationUtil.startPage(this.pathStack, PAGE_START)
          })

        // 用户名
        Text(this.userInfo.username)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({ top: 20 })

        // 昵称
        Text(`昵称：${this.userInfo.nickname as string}`)
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({ top: 8 })

        // 手机号
        Text(`手机：${this.userInfo.phone as string}`)
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({ top: 8 })

        // 用户ID
        Text(`ID：${this.userInfo.id}`)
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({ top: 8 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)

      // 按钮区域
      Column() {
        Button('登录')
          .width('80%')
          .height(44)
          .fontSize(16)
          .margin({ top: 30 })
          .onClick(() => {
            NavigationUtil.startPage(this.pathStack, PAGE_LOGIN)
          })

        Button('退出登录')
          .width('80%')
          .height(44)
          .fontSize(16)
          .backgroundColor(Color.Red)
          .fontColor(Color.White)
          .margin({ top: 16 })
          .onClick(() => {
            this.logout()
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
  }

  // 生命周期日志
  pageName = 'MinePage'

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
