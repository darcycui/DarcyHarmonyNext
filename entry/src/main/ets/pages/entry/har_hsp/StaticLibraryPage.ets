import { func, func2, Log, NavigationHelper, StaticMainPage } from 'static_library_common';
import { PAGE_STATIC_INNER } from '../../PageName';
import { getResourceString } from '../../../utils/ResourceHelper';
import { RouterHelper } from 'static_library_common/src/main/ets/utils/RouterHelper';
import { JSON } from '@kit.ArkTS';

@Builder
export function NavigationBuilder(){
  StaticLibraryPage()
}

@Entry
@Component
struct StaticLibraryPage {
  @State params: Map<string, string> = new Map();
  @State message: string = getResourceString(this, $r('app.string.StaticLibraryPageTest'));
  // navigation 控制器
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Text(this.message)
          .id('StaticLibraryText')
          .fontSize(20)
          .margin({ bottom: 10 })
          .fontWeight(FontWeight.Bold)
        // 引用static库中的string
        Button($r("app.string.StaticLibraryCommonName")).width('100%')
          .margin({ bottom: 10 })
          .onClick(() => {
            // 跳转到静态库页面
            NavigationHelper.startPage(this.pathStack, PAGE_STATIC_INNER, { 'keyHello': 'Hello World' })
          })
        // 引用static库中的图片
        Image($r("app.media.static_icon"))
          .margin({ bottom: 10 })
          .width(100)
          .objectFit(ImageFit.Contain)
        // 调用static库中的方法
        Button($r("app.string.StaticLibraryCommonFunc")).width('100%')
          .onClick(() => {
            Log.info('har static library common func')
            let info = func() + ' ' + func2()
            Log.info(`call static library common func: info=${info}`)
          })
        Text(JSON.stringify(this.params))
        StaticMainPage()
      }
      .height('100%')
      .width('100%')
    }.title("静态库调用")
    .onReady((context: NavDestinationContext) => {
      // 从参数中获取 页面栈
      this.pathStack = context.pathStack
      // 接收参数
      this.params = context.pathInfo.param as Map<string, string>
    })
  }
}