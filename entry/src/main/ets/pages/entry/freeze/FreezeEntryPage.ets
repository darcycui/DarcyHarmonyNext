import { RouterHelper } from 'static_library_common'
import { ItemEntity } from '../../../models/ItemEntity'
import { PAGE_FREEZE_LIST, PAGE_FREEZE_NAVIGATION, PAGE_FREEZE_PAGE_1, PAGE_FREEZE_TAB } from '../../PageName'

@Entry
@Component
struct FreezeEntryPage {
  @State itemList: Array<ItemEntity> = [
    new ItemEntity(PAGE_FREEZE_PAGE_1, $r('app.string.TestFreezePage')),
    new ItemEntity(PAGE_FREEZE_TAB, $r('app.string.TestFreezeTabPage')),
    new ItemEntity(PAGE_FREEZE_LIST, $r('app.string.TestFreezeListPage')),
    new ItemEntity(PAGE_FREEZE_NAVIGATION, $r('app.string.TestNavigationFreezePage')),
  ]

  build() {
    List() {
      ForEach(this.itemList, (item: ItemEntity, index: number) => {
        ListItem() {
          Text(item.text).fontSize(20).fontWeight(FontWeight.Bold).padding(10)
        }.width('100%').onClick(() => {
          RouterHelper.startPage(this.getUIContext(), item.pageName, {})
        })
      }, (item: ItemEntity, index: number) => {
        return `${index} ${JSON.stringify(item)}`
      })
    }.divider({ strokeWidth: 1, color: Color.Gray })
    .height('100%')
    .width('100%')
  }
}