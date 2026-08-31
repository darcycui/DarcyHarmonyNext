@Entry
@ComponentV2
struct RepeatPage {
  @Local listData: Array<string> = ['张三', '李四', '王五', '赵六']

  build() {
    List({ space: 15, initialIndex: 0 }) {
      Repeat<string>(this.listData)
        .each((item: RepeatItem<string>) => {
          ListItem() {
            Text(item.item).fontSize(20)
          }
        })
        .key((item: string, index: number) => `${item}:${index}`)
    }.width('100%')
    .height('100%')
  }
}