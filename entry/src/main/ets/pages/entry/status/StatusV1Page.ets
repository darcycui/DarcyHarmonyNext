import { ItemBean } from '../../../models/ItemBean';
import { JSON } from '@kit.ArkTS';
import { RouterHelper } from 'static_library_common';
import { common } from '@kit.AbilityKit';
import {
  PAGE_$$_PAGE,
  PAGE_COMPONENT_STATUS,
  PAGE_LINK,
  PAGE_OBSERVED_ARRAY_PAGE,
  PAGE_OBSERVED_ARRAY_PAGE_2,
  PAGE_OBSERVED_CLASS_PAGE,
  PAGE_OBSERVED_CLASS_PAGE_2,
  PAGE_PROP_CHANGED_1,
  PAGE_PROP_CHANGED_2,
  PAGE_PROVIDE_CONSUME,
  PAGE_PROVIDE_CONSUME_2,
  PAGE_PROVIDE_CONSUME_3,
  PAGE_STATE,
  PAGE_STATE_CHANGED_1,
  PAGE_STATE_CHANGED_2,
  PAGE_STATE_CHANGED_3,
  PAGE_STATE_CHANGED_4,
  PAGE_STATE_CHANGED_5,
  PAGE_TRACK_PAGE,
  PAGE_WATCH_CHANGE_TIME_PAGE,
  PAGE_WATCH_LINK_PAGE,
  PAGE_WATCH_PAGE
} from '../../PageName';

@Entry
@Component
struct StatusV1Page {
  @State params: Map<string, string> = new Map();
  pathStack: NavPathStack = new NavPathStack();
  @State itemList: Array<ItemBean> = [
    new ItemBean(PAGE_COMPONENT_STATUS, $r('app.string.TestComponentStatusPage')),
    new ItemBean(PAGE_STATE, $r('app.string.TestStatePage')),
    new ItemBean(PAGE_STATE_CHANGED_1, $r('app.string.TestStateChangedPage1')),
    new ItemBean(PAGE_STATE_CHANGED_2, $r('app.string.TestStateChangedPage2')),
    new ItemBean(PAGE_STATE_CHANGED_3, $r('app.string.TestStateChangedPage3')),
    new ItemBean(PAGE_STATE_CHANGED_4, $r('app.string.TestStateChangedPage4')),
    new ItemBean(PAGE_STATE_CHANGED_5, $r('app.string.TestStateChangedPage5')),
    new ItemBean(PAGE_PROP_CHANGED_1, $r('app.string.TestPropPage1')),
    new ItemBean(PAGE_PROP_CHANGED_2, $r('app.string.TestPropPage2')),
    new ItemBean(PAGE_LINK, $r('app.string.TestLinkPage')),
    new ItemBean(PAGE_PROVIDE_CONSUME, $r('app.string.TestProvidePage')),
    new ItemBean(PAGE_PROVIDE_CONSUME_2, $r('app.string.TestProvidePage2')),
    new ItemBean(PAGE_PROVIDE_CONSUME_3, $r('app.string.TestProvidePage3')),
    new ItemBean(PAGE_OBSERVED_CLASS_PAGE, $r('app.string.TestObservedClassPage')),
    new ItemBean(PAGE_OBSERVED_CLASS_PAGE_2, $r('app.string.TestObservedClassPage2')),
    new ItemBean(PAGE_OBSERVED_ARRAY_PAGE, $r('app.string.TestObservedArrayPage')),
    new ItemBean(PAGE_OBSERVED_ARRAY_PAGE_2, $r('app.string.TestObservedArrayPage2')),
    new ItemBean(PAGE_WATCH_PAGE, $r('app.string.TestWatchPage')),
    new ItemBean(PAGE_WATCH_LINK_PAGE, $r('app.string.TestWatchLinkPage')),
    new ItemBean(PAGE_WATCH_CHANGE_TIME_PAGE, $r('app.string.TestWatchChangeTimePage')),
    new ItemBean(PAGE_$$_PAGE, $r('app.string.TestDollarDollarPage')),
    new ItemBean(PAGE_TRACK_PAGE, $r('app.string.TestTrackPage')),
  ];

  build() {
    Navigation(this.pathStack) {
      List() {
        ForEach(this.itemList, (item: ItemBean, index: number) => {
          ListItem() {
            Text(item.text).fontSize(20).fontWeight(FontWeight.Bold).padding(10)
          }.onClick(() => {
            RouterHelper.startPage(this.getUIContext(), item.pageName, {})
          }).width('100%')
        }, (item: ItemBean, index: number) => {
          return `${index} ${JSON.stringify(item)}`
        })
      }.divider({strokeWidth:1, color:Color.Gray})
      .height('100%')
      .width('100%')
    }.title('状态管理V1(不推荐)')
    .titleMode(NavigationTitleMode.Mini)
  }
}