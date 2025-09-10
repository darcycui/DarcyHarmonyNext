import { Log } from 'static_library_common'
import { LocalBean } from '../local/LocalPage'

@Builder
export function NavigationBuilder() {
  EventPage()
}

@Entry
@ComponentV2
struct EventPage {
  @Local message: string = 'message: 原始消息'
  @Local count: number = 1
  @Local flag: boolean = true
  @Local localBean: LocalBean = new LocalBean('Tom', 8)

  build() {
    NavDestination() {
      Column({ space: 5 }) {
        Text('父组件')
        Text(`count=${this.count}`)
        Text(`flag=${this.flag}`)
        Text(this.message)
        Text(JSON.stringify(this.localBean))
        EventChild({
          message: this.message,
          count: this.count,
          flag: this.flag,
          localBean: this.localBean,
          // 实现回调函数 并传递给子组件
          changeParentEvent: (x: number) => {
            this.message += x
            this.count += x
            this.flag = (x % 2 == 0)
            this.localBean.id += x
            Log.log(`父组件Event: ${this.count}`)
          }
        })
      }.justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .height('100%')
      .width('100%')
    }.title('Event Callback')
  }
}

@ComponentV2
struct EventChild {
  @Require @Param message: string = 'message: default'
  @Require @Param count: number = -1
  @Require @Param flag: boolean = false
  @Require @Once @Param localBean: LocalBean = new LocalBean('default', -1)
  // 定义回调函数 @Event
  @Event changeParentEvent: (x: number) => void = (x: number) => {
  }
  @Local clickNo: number = 0

  build() {
    Column({ space: 5 }) {
      Text('子组件')
      Text(`count=${this.count}`)
      Text(`flag=${this.flag}`)
      Text(this.message)
      Text(JSON.stringify(this.localBean))
      Button('Event修改父组件').width('100%').onClick(() => {
        this.clickNo++
        this.changeParentEvent(this.clickNo)
        Log.log(`子组件Event: ${this.count}`)
      })
    }.width('100%').height('auto')
  }
}