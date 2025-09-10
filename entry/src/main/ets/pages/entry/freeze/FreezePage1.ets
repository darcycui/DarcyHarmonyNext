import { RouterHelper } from 'static_library_common/src/main/ets/utils/RouterHelper';
import { PAGE_FREEZE_PAGE_2 } from '../../PageName';

// 测试组件冻结功能 freezeWhenInactive: true
@Entry
@Component({ freezeWhenInactive: true })
struct Page1 {
  @StorageLink('PropA') @Watch("first") storageLink: number = 47;

  first() {
    console.info("first page " + `${this.storageLink}`)
  }

  build() {
    Column({space: 20}) {
      Text(`From first Page ${this.storageLink}`)
      Button('first page storageLink + 1').width('100%')
        .onClick(() => {
          this.storageLink += 1
        })
      Button('go to next page').width('100%')
        .onClick(() => {
          RouterHelper.startPage(this.getUIContext(), PAGE_FREEZE_PAGE_2)
        })
    }
  }
}