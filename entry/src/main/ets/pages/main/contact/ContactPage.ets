import { JSON } from "@kit.ArkTS"
import { Log, NavigationHelper, ToastUtil } from "static_library_common"
import { PAGE_APPLY_FRIEND, PAGE_ACCEPT_FRIEND } from "../../PageName"

@ComponentV2
export struct ContactPage {
  @Local contractList: Array<string> = [
    'Tom',
    'Jerry',
    'Mike',
    'Lucy',
    'Lily',
    'Lucas',
    'Lucifer',
    'Tom',
    'Jerry',
    'Mike',
    'Lucy',
    'Lily',
    'Lucas',
    'Lucifer',
  ]

  // Navigation 路由栈控制器
  @Consumer('appPathStack') pathStack: NavPathStack = new NavPathStack();

  build() {
    Column() {
      // 顶部标题栏（包含左右按钮）
      Row() {
        // 左上角：好友请求按钮
        Text('✉')
          .fontSize(22)
          .margin({ left: 16 })
          .onClick(() => {
            NavigationHelper.startPage(this.pathStack, PAGE_ACCEPT_FRIEND)
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
            NavigationHelper.startPage(this.pathStack, PAGE_APPLY_FRIEND)
          })
      }
      .width('100%')
      .height(50)
      .backgroundColor(Color.White)

      // 联系人列表
      List() {
        ForEach(this.contractList, (item: string, index: number) => {
          ListItem() {
            Column() {
              Text(item)
                .fontSize(20)
                .fontColor(Color.Black)
                .textAlign(TextAlign.Center)
                .margin({ left: 16 })
                .width('100%')
                .height(60)
                .clickEffect({ level: ClickEffectLevel.LIGHT })
            }
          }.onClick((event: ClickEvent) => {
            ToastUtil.showToast(this.getUIContext(), `index:${index} ${item}`)
          })
        }, (item: string, index: number) => index + JSON.stringify(item))
      }
      .width('100%')
      .layoutWeight(1)
      .divider({
        color: Color.Gray,
        strokeWidth: 1,
        startMargin: 0,
        endMargin: 0
      })
      .scrollBar(BarState.On)
    }
    .width('100%')
    .height('100%')
  }

  // 生命周期日志
  pageName = 'ContactPage'
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
