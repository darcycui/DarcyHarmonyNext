import { StaticMainPage } from 'static_library_common';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(20)
        .margin({ bottom: 10 })
        .fontWeight(FontWeight.Bold)

      // 使用静态库的组件
      StaticMainPage()

    }
    .height('100%')
    .width('100%')
  }
}