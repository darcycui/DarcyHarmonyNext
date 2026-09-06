@Component
export struct StaticMainPage {
  @State message: string = 'Component from static library common';

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
