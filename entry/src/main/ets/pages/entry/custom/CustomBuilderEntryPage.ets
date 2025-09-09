import { RouterHelper } from 'static_library_common'
import { ItemBean } from '../../../models/ItemBean'
import {
  PAGE_BUILDER_1,
  PAGE_BUILDER_2,
  PAGE_BUILDER_3,
  PAGE_BUILDER_PARAM_1,
  PAGE_BUILDER_PARAM_2,
  PAGE_BUILDER_PARAM_3,
  PAGE_LOCAL_BUILDER_1,
  PAGE_LOCAL_BUILDER_2,
  PAGE_LOCAL_BUILDER_3,
  PAGE_WRAP_BUILDER_PAGE
} from '../../PageName'

@Entry
@Component
struct CustomBuilderEntryPage {
  @State itemList: Array<ItemBean> = [
    new ItemBean(PAGE_BUILDER_1, $r("app.string.TestBuilderPage1")),
    new ItemBean(PAGE_BUILDER_2, $r("app.string.TestBuilderPage2")),
    new ItemBean(PAGE_BUILDER_3, $r("app.string.TestBuilderPage3")),
    new ItemBean(PAGE_LOCAL_BUILDER_1, $r("app.string.TestLocalBuilderPage1")),
    new ItemBean(PAGE_LOCAL_BUILDER_2, $r("app.string.TestLocalBuilderPage2")),
    new ItemBean(PAGE_LOCAL_BUILDER_3, $r("app.string.TestLocalBuilderPage3")),
    new ItemBean(PAGE_BUILDER_PARAM_1, $r("app.string.TestLocalBuilderParamPage1")),
    new ItemBean(PAGE_BUILDER_PARAM_2, $r("app.string.TestLocalBuilderParamPage2")),
    new ItemBean(PAGE_BUILDER_PARAM_3, $r("app.string.TestLocalBuilderParamPage3")),
    new ItemBean(PAGE_WRAP_BUILDER_PAGE, $r("app.string.TestWrapBuilderPage")),
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