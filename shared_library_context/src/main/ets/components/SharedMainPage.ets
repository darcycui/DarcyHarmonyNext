@Component
export struct SharedMainPage {
  @State message: string = 'Component from shared library context';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }.backgroundColor(Color.Gray)
    .height('100%')
  }
}