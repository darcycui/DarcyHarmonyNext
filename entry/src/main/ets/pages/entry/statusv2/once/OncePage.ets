import { func } from 'static_library_common';
import { LocalBean } from '../local/LocalPage';

@Builder
export function NavigationBuilder() {
  OncePage()
}

@Entry
@ComponentV2
struct OncePage {
  @Local message: string = 'message：原始消息';
  @Local count: number = 1;
  @Local flag: boolean = true
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
        OnceChild({
          count: this.count,
          flag: this.flag,
          message: this.message,
          localBean: this.localBean
        })
      }.justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .height('100%')
      .width('100%')
    }.title('Once')
    .height('100%')
    .width('100%')
    .onReady((context: NavDestinationContext) => {
    })
  }
}

@ComponentV2
struct OnceChild {
  @Require @Once @Param message: string = 'message: default';
  @Require @Once @Param count: number = -1;
  @Require @Once @Param flag: boolean = false;
  @Require @Once @Param localBean: LocalBean = new LocalBean('default', -1)

  build() {
    Column({ space: 5 }) {
      Text(`count=${this.count}`)
      Text(`flag=${this.flag}`)
      Text(this.message)
      Text(JSON.stringify(this.localBean))
      Button('子组件可以修改 count').width('100%').onClick(() => {
        this.count++
      })
      Button('子组件修改 flag').width('100%').onClick(() => {
        this.flag = !this.flag
      })
      Button('子组件修改 message').width('100%').onClick(() => {
        this.message += ' 已改变'
      })
      Button('子组件修改 localBean (无法观察)').width('100%').onClick(() => {
        this.localBean.id++
      })
      Button('子组件重新赋值 localBean').width('100%').onClick(() => {
        this.localBean = new LocalBean('Jerry', 4)
      })
    }.width('100%').height('auto')
  }
}