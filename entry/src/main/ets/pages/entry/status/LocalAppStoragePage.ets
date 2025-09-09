import { NavigationHelper, RouterHelper } from 'static_library_common'
import { ItemBean } from '../../../models/ItemBean'
import {
  PAGE_APP_STORAGE_PAGE_1,
  PAGE_ENVIRONMENT_PAGE,
  PAGE_LOCAL_STORAGE_PAGE_1,
  PAGE_LOCAL_STORAGE_PAGE_2,
  PAGE_LOCAL_STORAGE_PAGE_3,
  PAGE_LOCAL_STORAGE_PAGE_4,
  PAGE_LOCAL_STORAGE_PAGE_5,
  PAGE_PERSISTENT_PAGE
} from '../../PageName'

@Entry
@Component
struct LocalAppStoragePage {
  @State itemList: Array<ItemBean> = [
    new ItemBean(PAGE_LOCAL_STORAGE_PAGE_1, $r('app.string.TestLocalStoragePage1')),
    new ItemBean(PAGE_LOCAL_STORAGE_PAGE_2, $r('app.string.TestLocalStoragePage2')),
    new ItemBean(PAGE_LOCAL_STORAGE_PAGE_3, $r('app.string.TestLocalStoragePage3')),
    new ItemBean(PAGE_LOCAL_STORAGE_PAGE_4, $r('app.string.TestLocalStoragePage4')),
    new ItemBean(PAGE_LOCAL_STORAGE_PAGE_5, $r('app.string.TestLocalStoragePage5')),
    new ItemBean(PAGE_APP_STORAGE_PAGE_1, $r('app.string.TestAppStoragePage1')),
    new ItemBean(PAGE_PERSISTENT_PAGE, $r('app.string.TestPersistentPage')),
    new ItemBean(PAGE_ENVIRONMENT_PAGE, $r('app.string.TestEnvironmentPage')),
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