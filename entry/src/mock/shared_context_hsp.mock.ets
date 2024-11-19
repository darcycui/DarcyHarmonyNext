export function add(a: number, b: number) {
  return a + b;
}
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
export class ContextResourceManager {
  static getIcon(): Resource {
    return $r("app.media.background")
  }

  static getString(): Resource {
    return $r("app.string.app_name")
  }
}