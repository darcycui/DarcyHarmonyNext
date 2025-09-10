import { NavigationHelper } from 'static_library_common';
import { ItemBean } from '../../../models/ItemBean';
import {
  PAGE_COMPUTED,
  PAGE_COMPUTED_CLASS,
  PAGE_EVENT_CALLBACK,
  PAGE_LOCAL,
  PAGE_MONITOR,
  PAGE_MONITOR_CLASS,
  PAGE_OBSERVED_V2 as PAGE_OBSERVED_V2, PAGE_ONCE, PAGE_PARAM,
  PAGE_PROVIDER,
  PAGE_PROVIDER_FUNCTION} from '../../PageName';

@Entry
@ComponentV2
struct StatusV2Page {
  @Local params: Map<string, string> = new Map();
  pathStack: NavPathStack = new NavPathStack();
  itemList: Array<ItemBean> = [
    new ItemBean(PAGE_OBSERVED_V2, $r('app.string.observer_v2_page')),
    new ItemBean(PAGE_LOCAL, $r('app.string.local_page')),
    new ItemBean(PAGE_PARAM, $r('app.string.param_page')),
    new ItemBean(PAGE_ONCE, $r('app.string.once_page')),
    new ItemBean(PAGE_EVENT_CALLBACK, $r('app.string.event_callback_page')),
    new ItemBean(PAGE_PROVIDER, $r('app.string.provider_page')),
    new ItemBean(PAGE_PROVIDER_FUNCTION, $r('app.string.provider_function_page')),
    new ItemBean(PAGE_MONITOR, $r('app.string.monitor_page')),
    new ItemBean(PAGE_MONITOR_CLASS, $r('app.string.monitor_class_page')),
    new ItemBean(PAGE_COMPUTED, $r('app.string.computed_page')),
    new ItemBean(PAGE_COMPUTED_CLASS, $r('app.string.computed_class_page')),
  ];

  build() {
    Navigation(this.pathStack) {
      List() {
        ForEach(this.itemList, (item: ItemBean, index: number) => {
          ListItem() {
            Text(item.text).width('100%').textAlign(TextAlign.Center).padding(10)
          }.width('100%').onClick(() => {
            NavigationHelper.startPage(this.pathStack, item.pageName, { 'keyHello': 'Value Hello World' })
          })
        }, (item: ItemBean, index: number) => {
          return `${index} ${JSON.stringify(item)}`
        })
      }.divider({ strokeWidth: 1, color: Color.Gray })
      .height('100%')
      .width('100%')
    }.title('StatusV2')
    .titleMode(NavigationTitleMode.Mini)
  }
}