@Entry
@Component
struct ComponentPage {
  @State linkCount: number = 100
  @State propCount: number = -100
  @State stateInfo: string = 'state from parent';
  normalInfo: string = 'normal from parent'

  build() {
    Column() {
      Text(`link count=${this.linkCount}`)
      Divider().height(5) // 分隔线
      Text(`prop count=${this.propCount}`)
      Divider().height(5) // 分隔线
      Text(`stateInfo: ${this.stateInfo}`)
      Divider().height(5) // 分隔线
      Text(`normalInfo: ${this.normalInfo}`)
      Blank().height(20) // 空白间隔
      Button('Change Parent State').onClick(() => {
        this.linkCount = this.linkCount + 100
        this.propCount = this.propCount - 100
        this.stateInfo = 'state changed by Parent'
        this.normalInfo = 'normal changed by Parent'
      }).margin({ top: 2 })
      ComponentA({
        linkCount: this.linkCount,
        propCount: this.propCount,
        stateInfo: this.stateInfo,
        normalInfo: this.normalInfo
      })
    }.alignItems(HorizontalAlign.Start)
    .height('100%')
    .width('100%')
  }
}

@Component
struct ComponentA {
  // 父子组件双向同步
  @Link linkCount: number
  // 父组件-->子组件 单向同步
  @Prop propCount: number = 0
  @State stateInfo: string = 'state default'
  normalInfo: string = 'normal default'

  build() {
    Column() {
      Text(`link count=${this.linkCount}`)
      Divider().height(5) // 分隔线
      Text(`prop count=${this.propCount}`)
      Divider().height(5) // 分隔线
      Text(`stateInfo: ${this.stateInfo}`)
      Divider().height(5) // 分隔线
      Text(`normalInfo: ${this.normalInfo}`)
      Blank().height(20) // 空白间隔
      Button('Change State').onClick(() => {
        this.linkCount = 999
        this.propCount = 888
        this.stateInfo = 'state changed by Child'
        this.normalInfo = 'normal changed by Child'
      }).margin({ top: 2 })
      ComponentC({ linkCount: this.linkCount })
    }
    .alignItems(HorizontalAlign.Start)
    .padding(20)
    .backgroundColor($r('app.color.green'))
    .margin({ top: 20 })
    .width('100%')
  }
}

@Component
struct ComponentC {
  @Link linkCount: number

  build() {
    Column() {
      Text(`link count=${this.linkCount}`)
      Blank().height(20) // 空白间隔
      Button('Change State').onClick(() => {
        this.linkCount = 666
      }).margin({ top: 2 })
    }
    .alignItems(HorizontalAlign.Start)
    .padding(20)
    .backgroundColor($r('app.color.red'))
    .margin({ top: 20 })
    .width('100%')
  }
}