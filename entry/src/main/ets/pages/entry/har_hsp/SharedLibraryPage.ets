import { PAGE_SHARED_INNER } from '../../PageName';
import { getResourceString } from '../../../utils/ResourceHelper';
import { Log, NavigationHelper } from 'static_library_common';
// import { add, ContextResourceManager, SharedMainPage } from 'shared_library_context';

// darcyRefactor: 定义页面路由函数 @Builder
@Builder
export function NavigationBuilder() {
  SharedLibraryPage()
}

@Entry
@Component
struct SharedLibraryPage {
  params: Map<string, string> = new Map();
  @State message: string = getResourceString(this, $r('app.string.SharedLibraryPageTest'));
  // navigation 控制器
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Text(this.message)
          .id('SharedLibraryText')
          .fontSize(16)
          .margin({ bottom: 10 })
          .fontWeight(FontWeight.Bold)
        // // 引用动态库中的string
        // Button(ContextResourceManager.getString()).width('100%')
        //   .margin({ bottom: 10 })
        //   .onClick(() => {
        //     // 跳转到动态库页面
        //     NavigationHelper.startPage(this.pathStack, PAGE_SHARED_INNER, { 'keyHello': 'Hello World' })
        //   })
        // // 引用static库中的图片
        // Image(ContextResourceManager.getIcon())
        //   .margin({ bottom: 10 })
        //   .width(100)
        //   .objectFit(ImageFit.Contain)
        // // 调用动态库中的方法
        // Button($r("app.string.SharedLibraryCommonFunc")).width('100%')
        //   .onClick(() => {
        //     let sum = add(1, 2)
        //     Log.log(`call add from shared library: sum=${sum}`)
        //   })
        // Text(JSON.stringify(this.params))
        // // 使用动态库中的组件
        // SharedMainPage()
      }
      .height('100%')
      .width('100%')
    }.title("动态库调用")
    .onReady((context: NavDestinationContext) => {
      // 获取传递的页面栈
      this.pathStack = context.pathStack
      // 获取参数
      this.params = context.pathInfo.param as Map<string, string>
    })
  }
}