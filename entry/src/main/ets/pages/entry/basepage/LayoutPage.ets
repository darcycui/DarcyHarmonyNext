import { RouterHelper } from 'static_library_common'
import { ItemBean } from '../../../models/ItemBean'
import { PAGE_COLUMN, PAGE_IMAGE, PAGE_INPUT, PAGE_RELATIVE } from '../../PageName'

@Entry
@Component
struct LayoutPage {
  @State itemList: Array<ItemBean> = [
    new ItemBean(PAGE_RELATIVE, $r('app.string.RelativePage')),
    new ItemBean(PAGE_INPUT, $r('app.string.InputPage')),
    new ItemBean(PAGE_COLUMN, $r('app.string.ColumnPage')),
    new ItemBean(PAGE_IMAGE, $r('app.string.ImagePage')),
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