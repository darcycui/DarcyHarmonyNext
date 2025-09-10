import { LocalBean } from '../local/LocalPage';

@Builder
export function NavigationBuilder() {
  ParamPage()
}

@Entry
@ComponentV2
struct ParamPage {
  @Local message: string = 'message: 这是一条消息';
  @Local count: number = 1;
  @Local flag: boolean = true;
  // 只能观察到重新赋值 不能观察到类属性的修改
  @Local localBean: LocalBean = new LocalBean('Tom', 8)

  build() {
    NavDestination() {
      Column({ space: 5 }) {
        // 父组件
        Text('父组件')
        Text(`count=${this.count}`)
        Text(`flag=${this.flag}`)
        Text(this.message)
        Text(JSON.stringify(this.localBean))
        Button('修改 count').width('100%').onClick(() => {
          this.count++
        })
        Button('修改 flag').width('100%').onClick(() => {
          this.flag = !this.flag
        })
        Button('修改 message').width('100%').onClick(() => {
          this.message += ' 已改变'
        })
        Button('修改 localBean (无法观察)').width('100%').onClick(() => {
          this.localBean.id++
        })
        Button('重新赋值 localBean').width('100%').onClick(() => {
          this.localBean = new LocalBean('Jerry', 4)
        })
        // 子组件
        Text('子组件')
        ParamChild({
          count: this.count,
          flag: this.flag,
          message: this.message,
          localBean: this.localBean
        })
      }.justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .height('100%')
      .width('100%')
    }.title('Param')
    .height('100%')
    .width('100%')
    .onReady((context: NavDestinationContext) => {
    })
  }
}

@ComponentV2
struct ParamChild {
  @Require @Param message: string = 'message: default';
  @Require @Param count: number = -1;
  @Require @Param flag: boolean = false;
  @Require @Param localBean: LocalBean = new LocalBean('default', -1)

  build() {
    Column({ space: 5 }) {
      Text(`count=${this.count}`)
      Text(`flag=${this.flag}`)
      Text(this.message)
      Text(JSON.stringify(this.localBean))
      Button('子组件不能修改 count').width('100%').onClick(() => {
        // this.count++  // 编译错误
      })
    }.width('100%').height('auto')
  }
}