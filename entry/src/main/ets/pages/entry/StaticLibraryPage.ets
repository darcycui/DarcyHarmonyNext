import { func, func2, Log, StaticMainPage } from 'static_common';
import { PAGE_STATIC_INNER } from '../PageName';
import { getResourceString } from '../../utils/ResourceHelper';
import { startNamedPage } from '../../utils/RouterHelper';

@Entry
@Component
struct StaticLibraryPage {
  @State message: string = getResourceString(this, $r('app.string.StaticLibraryPageTest'));

  build() {
    Column() {
      Text(this.message)
        .id('StaticLibraryText')
        .fontSize(20)
        .margin({ bottom: 10 })
        .fontWeight(FontWeight.Bold)
      // 引用static库中的string
      Button($r("app.string.StaticLibraryCommonName"))
        .margin({ bottom: 10 })
        .onClick(() => {
          // 跳转到静态库页面
          startNamedPage(PAGE_STATIC_INNER, { 'keyHello': 'Hello World' });
        })
      // 引用static库中的图片
      Image($r("app.media.static_icon"))
        .margin({ bottom: 10 })
        .width(100)
        .objectFit(ImageFit.Contain)
      // 调用static库中的方法
      Button($r("app.string.StaticLibraryCommonFunc"))
        .onClick(() => {
          Log.info('har static library common func')
          let info = func() + ' ' + func2()
          Log.info(`call static library common func: info=${info}`)
        })
      StaticMainPage()
    }
    .height('100%')
    .width('100%')
  }
}