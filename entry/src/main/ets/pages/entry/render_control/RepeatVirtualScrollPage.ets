import { ToastHelper } from 'static_library_common'

@Entry
@ComponentV2
struct RepeatVirtualScrollPage {
  @Local listData: Array<string> = ['张三', '李四', '王五', '赵六']

  build() {
    List({ space: 10, initialIndex: 1 }) {
      Repeat<string>(this.listData)
        .each((item: RepeatItem<string>) => {
          ListItem() {
            Text(item.item)
              .fontSize(50)
              .onClick(() => {
                ToastHelper.showToast(this.getUIContext(), item.item)
              })
          }
        })
        .key((item: string, index: number) => {
          return `${item}:${index}`
        })
        // 开启 virtualScroll
        .virtualScroll({totalCount: this.listData.length})
    }.width('100%')
    .height('100%')
  }
}