import { LocalBean } from '../local/LocalPage'

@Builder
export function NavigationBuilder() {
  ProviderPage()
}

@Entry
@ComponentV2
struct ProviderPage {
  @Provider('message') message: string = 'message: 原始消息'
  @Provider('count') count: number = 1
  @Provider('flag') flag: boolean = true
  @Provider('localBean') localBean: LocalBean = new LocalBean('Tom', 8)

  build() {
    NavDestination() {
      Column({ space: 5 }) {
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
        ProviderChild()
      }.justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .height('100%')
      .width('100%')
    }.title('Provider Consumer')
  }
}

@ComponentV2
struct ProviderChild {
  build() {
    Column({ space: 5 }) {
      Text('子组件')
      ProviderGrandson()
    }.width('100%').height('auto')
  }
}

@ComponentV2
struct ProviderGrandson {
  @Consumer('message') message: string = 'message: default grandson'
  @Consumer('count') count: number = -1
  @Consumer('flag') flag: boolean = false
  @Consumer('localBean') localBean: LocalBean = new LocalBean('default grandson', -1)

  build() {
    Column({ space: 5 }) {
      Text('孙组件')
      Text(`count=${this.count}`)
      Text(`flag=${this.flag}`)
      Text(this.message)
      Text(JSON.stringify(this.localBean))
      Button('孙组件 修改 count').width('100%').onClick(() => {
        this.count++
      })
      Button('孙组件 修改 flag').width('100%').onClick(() => {
        this.flag = !this.flag
      })
      Button('孙组件 修改 message').width('100%').onClick(() => {
        this.message += ' 已改变'
      })
      Button('孙组件 修改 localBean (无法观察)').width('100%').onClick(() => {
        this.localBean.id++
      })
      Button('孙组件 重新赋值 localBean').width('100%').onClick(() => {
        this.localBean = new LocalBean('Jerry', 4)
      })
    }.width('100%').height('auto')
  }
}