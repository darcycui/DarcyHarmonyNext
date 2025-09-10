@Builder
export function NavigationBuilder() {
  LocalPage()
}

export class LocalBean {
  name: string
  id: number

  constructor(name: string, id: number) {
    this.name = name
    this.id = id
  }
}

@Entry
@ComponentV2
struct LocalPage {
  @Local count: number = 1
  @Local message: string = 'Local状态变量';
  @Local flag: boolean = false
  // 只能观察到重新赋值 不能观察到类属性的修改
  @Local localBean: LocalBean = new LocalBean('Tom', 8)

  build() {
    NavDestination() {
      Column({space: 10}) {
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
        Button('修改 localBean').width('100%').onClick(() => {
          this.localBean.id++
        })
        Button('重新赋值 localBean').width('100%').onClick(() => {
          this.localBean = new LocalBean('Jerry', 4)
        })
      }
      .height('100%')
      .width('100%')
    }.title('Local')
  }
}