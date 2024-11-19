@Entry()
@Component
struct SharedIndex {
  @State message: string = 'This is SharedInnerPage';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .margin({ bottom: 10 })
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}