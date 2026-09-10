import { RouterHelper } from 'static_library_common'
import { ItemEntity } from '../../../models/ItemEntity'
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
  @State itemList: Array<ItemEntity> = [
    new ItemEntity(PAGE_BUILDER_1, $r("app.string.TestBuilderPage1")),
    new ItemEntity(PAGE_BUILDER_2, $r("app.string.TestBuilderPage2")),
    new ItemEntity(PAGE_BUILDER_3, $r("app.string.TestBuilderPage3")),
    new ItemEntity(PAGE_LOCAL_BUILDER_1, $r("app.string.TestLocalBuilderPage1")),
    new ItemEntity(PAGE_LOCAL_BUILDER_2, $r("app.string.TestLocalBuilderPage2")),
    new ItemEntity(PAGE_LOCAL_BUILDER_3, $r("app.string.TestLocalBuilderPage3")),
    new ItemEntity(PAGE_BUILDER_PARAM_1, $r("app.string.TestLocalBuilderParamPage1")),
    new ItemEntity(PAGE_BUILDER_PARAM_2, $r("app.string.TestLocalBuilderParamPage2")),
    new ItemEntity(PAGE_BUILDER_PARAM_3, $r("app.string.TestLocalBuilderParamPage3")),
    new ItemEntity(PAGE_WRAP_BUILDER_PAGE, $r("app.string.TestWrapBuilderPage")),
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