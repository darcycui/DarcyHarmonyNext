// import { add, ContextResourceManager, SharedMainPage } from 'shared_context';
import { PAGE_SHARED_INNER } from '../../PageName';
import { getResourceString } from '../../../utils/ResourceHelper';
import { RouterHelper } from 'static_library_common/src/main/ets/utils/RouterHelper';
import { Log } from 'static_library_common';

@Entry
@Component
struct SharedLibraryPage {
  @State message: string = getResourceString(this, $r('app.string.SharedLibraryPageTest'));

  build() {
    Column() {
      Text(this.message)
        .id('SharedLibraryText')
        .fontSize(16)
        .margin({ bottom: 10 })
        .fontWeight(FontWeight.Bold)
      // // 引用动态库中的string
      // Button(ContextResourceManager.getString())
      //   .margin({ bottom: 10 })
      //   .onClick(() => {
      //     // 跳转到动态库页面
      //     startNamedPage(PAGE_SHARED_INNER, { 'keyHello': 'Hello World' });
      //   })
      // // 引用static库中的图片
      // Image(ContextResourceManager.getIcon())
      //   .margin({ bottom: 10 })
      //   .width(100)
      //   .objectFit(ImageFit.Contain)
      // // 调用动态库中的方法
      // Button($r("app.string.StaticLibraryCommonFunc"))
      //   .onClick(() => {
      //     let sum = add(1, 2)
      //     Log.log(`call add from shared library: sum=${sum}`)
      //   })
      // // 使用动态库中的组件
      // SharedMainPage()
    }
    .height('100%')
    .width('100%')
  }
}