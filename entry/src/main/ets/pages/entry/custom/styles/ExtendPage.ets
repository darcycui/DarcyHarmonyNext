import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct ExtendPage {
  @State label: string = 'Test Extend '
  @State sizes: number = 20

  build() {
    Column({ space: 10 }) {
      Text(`${this.label}`)
        .fancyText(this.sizes, 100, Color.Blue, () => {
          promptAction.showToast({message: '1'})
        })
      Text(`${this.label}`)
        .fancyText(this.sizes, 200, Color.Pink, () => {
        promptAction.showToast({message: '2'})
      })
      Text(`${this.label}`)
        .fancyText(this.sizes, 300, Color.Orange,() => {
          promptAction.showToast({message: '3'})
        })
      //
      Button('Click change size').onClick(() => {
        // this.label += 'A'
        //
        this.sizes += 10
      })
    }.width('100%')
  }
}

// TODO 设置Text组件的样式 可以传递参数
@Extend(Text)
function fancyText(size: number, fontWeight: number, fontColor: Color, onclick: () => void) {
  .fontSize(size)
  .fontWeight(fontWeight)
  .fontColor(fontColor)
  .onClick(onclick) // TODO 参数可以是function
}