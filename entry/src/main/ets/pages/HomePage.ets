import { Log, NavigationUtil, ToastUtil } from 'static_library_common';
import { PAGE_LOGIN } from './PageName';

@Entry
@ComponentV2
struct HomePage {
  /**
   * navigation 控制器
   */
  @Provider('HomePathStack') pathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    NavigationUtil.startPage(this.pathStack, PAGE_LOGIN, {}, true)
  }

  build() {
    Navigation(this.pathStack) {
      RelativeContainer() {
      }
      .height('100%')
      .width('100%')
    }.hideNavBar(true)
    .hideTitleBar(true)
    .hideToolBar(true)
    .hideBackButton(true)
  }
}