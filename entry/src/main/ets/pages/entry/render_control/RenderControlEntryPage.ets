import { RouterHelper } from 'static_library_common'
import { ItemBean } from '../../../models/ItemBean'
import {
  PAGE_RENDER_FOR_EACH_PAGE_1,
  PAGE_RENDER_IF_ELSE, PAGE_RENDER_IF_ELSE_WITH_STATE,
  PAGE_RENDER_IF_ELSE_WITH_STATE_CHANGED,
  PAGE_RENDER_LAZY_FOR_EACH_PAGE_1,
  PAGE_RENDER_LAZY_FOR_EACH_PAGE_2,
  PAGE_RENDER_LAZY_FOR_EACH_PAGE_3} from '../../PageName'

@Entry
@Component
struct RenderControlEntryPage {
  @State itemList: Array<ItemBean> = [
    new ItemBean(PAGE_RENDER_IF_ELSE, $r("app.string.TestRenderIfElsePage")),
    new ItemBean(PAGE_RENDER_IF_ELSE_WITH_STATE, $r("app.string.TestRenderIfElseWithStatePage")),
    new ItemBean(PAGE_RENDER_IF_ELSE_WITH_STATE_CHANGED, $r("app.string.TestRenderIfElseWithStateChangedPage")),
    new ItemBean(PAGE_RENDER_FOR_EACH_PAGE_1, $r("app.string.TestForEachPage1")),
    new ItemBean(PAGE_RENDER_LAZY_FOR_EACH_PAGE_1, $r("app.string.TestLazyForEachPage1")),
    new ItemBean(PAGE_RENDER_LAZY_FOR_EACH_PAGE_2, $r("app.string.TestLazyForEachClassPage2")),
    new ItemBean(PAGE_RENDER_LAZY_FOR_EACH_PAGE_3, $r("app.string.TestLazyForEachReusablePage3")),
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