import { RouterHelper } from 'static_library_common'
import { ItemBean } from '../../../models/ItemBean'
import { PAGE_FREEZE_LIST, PAGE_FREEZE_NAVIGATION, PAGE_FREEZE_PAGE_1, PAGE_FREEZE_TAB } from '../../PageName'

@Entry
@Component
struct FreezeEntryPage {
  @State itemList: Array<ItemBean> = [
    new ItemBean(PAGE_FREEZE_PAGE_1, $r('app.string.TestFreezePage')),
    new ItemBean(PAGE_FREEZE_TAB, $r('app.string.TestFreezeTabPage')),
    new ItemBean(PAGE_FREEZE_LIST, $r('app.string.TestFreezeListPage')),
    new ItemBean(PAGE_FREEZE_NAVIGATION, $r('app.string.TestNavigationFreezePage')),
  ]

  build() {
    List() {
      ForEach(this.itemList, (item: ItemBean, index: number) => {
        ListItem() {
          Text(item.text).fontSize(20).fontWeight(FontWeight.Bold).padding(10)
        }.width('100%').onClick(() => {
          RouterHelper.startPage(this.getUIContext(), item.pageName, {})
        })
      }, (item: ItemBean, index: number) => {
        return `${index} ${JSON.stringify(item)}`
      })
    }.divider({ strokeWidth: 1, color: Color.Gray })
    .height('100%')
    .width('100%')
  }
}