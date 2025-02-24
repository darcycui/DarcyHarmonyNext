@Component
struct Child {
  @Prop value: number = 0;

  build() {
    Button(`${this.value} Click`)
      .fontSize(20)
      .margin({ top: 4 })
      .backgroundColor($r('app.color.purple'))
      .onClick(() => {
        this.value++;
      })
  }
}

@Entry
@Component
struct PropChangedPage1 {
  @State arr: number[] = [1, 2, 3];

  build() {
    Row() {
      Column() {
        Child({ value: this.arr[0] })
        Child({ value: this.arr[1] })
        Child({ value: this.arr[2] })
        Button('父组件 replace entire arr')
          .fontSize(20)
          .onClick(() => {
            // 两个数组都包含项“3”。
            this.arr = this.arr[0] == 1 ? [3, 4, 5] : [1, 2, 3];
          }).margin({ top: 4 })

        // 分隔线
        Divider().height(10).backgroundColor($r('app.color.green'))
        // 遍历数组 添加子组件
        ForEach(this.arr,
          (item: number) => {
            Child({ value: item })
          },
          (item: number) => item.toString()
        )
      }
    }
  }
}