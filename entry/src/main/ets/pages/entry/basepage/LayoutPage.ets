import { RouterHelper } from 'static_library_common'
import { ItemEntity } from '../../../models/ItemEntity'
import { PAGE_COLUMN, PAGE_IMAGE, PAGE_INPUT, PAGE_RELATIVE } from '../../PageName'

@Entry
@Component
struct LayoutPage {
  @State itemList: Array<ItemEntity> = [
    new ItemEntity(PAGE_RELATIVE, $r('app.string.RelativePage')),
    new ItemEntity(PAGE_INPUT, $r('app.string.InputPage')),
    new ItemEntity(PAGE_COLUMN, $r('app.string.ColumnPage')),
    new ItemEntity(PAGE_IMAGE, $r('app.string.ImagePage')),
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