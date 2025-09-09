import { NavigationHelper } from 'static_library_common';
import { PAGE_OBSERVER_V2 } from '../../PageName';

@Entry
@ComponentV2
struct StatusV2Page {
  @Local params: Map<string, string> = new Map();
  pathStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pathStack) {
      Column() {
        Button('ObserverV2')
          .onClick(() => {
            NavigationHelper.startPage(this.pathStack, PAGE_OBSERVER_V2, { 'keyHello': 'Value Hello World' })
          })
          .width('100%')
      }
      .height('100%')
      .width('100%')
    }.title('StatusV2')
    .titleMode(NavigationTitleMode.Mini)
  }
}