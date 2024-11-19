@Entry
@Component
struct FilePage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      this.httpButton()
      this.resultText()
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  resultText() {
    Text(this.httpText)
      .id('HttpText')
      .fontSize(16)
  }

  @Builder
  httpButton() {
    Button($r("app.string.HttpTest"))
      .id("HttpTest")
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // TODO 访问网络
        this.requestHttp()
      })
  }
}