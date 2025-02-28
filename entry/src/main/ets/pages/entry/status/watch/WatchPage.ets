import { Log } from 'static_common';

@Entry
@Component
struct WatchPage {
  // @Watch指定回调函数名 初始化不会触发回调函数
  @State @Watch('onMessageChange') message: string = 'Hello World';
  @State @Watch('onMessageChange') name: string = 'Tom';

  // 回调函数必须是组件的成员函数
  onMessageChange(changedPropertyName?: string) {
    // 通过参数区分是哪个属性变化
    Log.log(`WatchPage changedPropertyName: ${changedPropertyName}`);
    Log.log(`WatchPage message: ${this.message}`)
    Log.log(`WatchPage name: ${this.name}`)
  }

  build() {
    RelativeContainer() {
      Column(){
        Text(this.message)
          .id('WatchPageMessage')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message = 'Welcome';
          })
        Text(this.name)
          .id('WatchPageName')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.name = 'Jerry';
          })
      }
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
    }
    .height('100%')
    .width('100%')
  }
}