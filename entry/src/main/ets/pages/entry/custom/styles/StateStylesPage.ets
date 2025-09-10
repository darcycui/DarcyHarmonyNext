@Entry
@Component
struct StateStylesPage {
  @State normalColor: ResourceColor = '#ff2787d9'

  // 设置 statesStyles normal
  @Styles
  normalStyle() {
    .backgroundColor('#ff2787d9')
  }

  // 设置 statesStyles focused
  @Styles
  focusedStyle() {
    .backgroundColor('#ffffeef0')
  }

  // 设置 statesStyles pressed
  @Styles
  pressedStyle() {
    .backgroundColor('#ff707070')
  }

  build() {
    Column({ space: 20 }) {
      Button('Button1').width('100%')
        // 设置statesStyles
        .stateStyles({
          // 使用函数给 normal focused pressed 3个状态设置样式
          normal: this.normalStyle
          focused: this.focusedStyle,
          pressed: this.pressedStyle,
        })
      Button('Button2').width('100%')
        .stateStyles({
          normal: {
            // TODO 可以使用状态变量 可以刷新UI
            .backgroundColor(this.normalColor)
          }
          focused: this.focusedStyle,
          pressed: this.pressedStyle,
        })
      Button('Change normal color').width('100%').onClick(() => {
        this.normalColor = '#ff000000'
      })
    }.width('100%')
  }
}