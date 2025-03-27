import { promptAction } from '@kit.ArkUI';
import { MyButtonModifier } from './Modifiers';

// 定义在全局的@Styles封装的样式 是一个函数
// TODO 只支持通用属性 不能传参数
@Styles
function globalFancy() {
  .width(150)
  .height(100)
  .backgroundColor(Color.Pink)
  .onClick(() => {
    promptAction.showToast({message: "点击了全局样式"})
  })
}

@Entry
@Component
struct StylesPage {
  @State heightValue: number = 100;
  // TODO 使用导入的 Modifier
  @State modifier: MyButtonModifier = new MyButtonModifier();

  // 定义在组件内的@Styles封装的样式
  // TODO 只支持通用属性 不能传参数
  @Styles
  fancy() {
    .width(200)
    .height(this.heightValue)
    .backgroundColor(Color.Yellow)
    .onClick(() => {
      this.heightValue = 200
      promptAction.showToast({message: "点击了内部样式"})
    })
  }

  build() {
    Column({ space: 10 }) {
      // 使用全局的@Styles封装的样式
      Text('FancyA')
        .globalFancy()
        .fontSize(30)
        .align(Alignment.Center)
      // 使用组件内的@Styles封装的样式
      Text('FancyB')
        .fancy()
        .fontSize(30)
      // 跨文件使用Modifier
      Button("Button")
        .attributeModifier(this.modifier)
        .onClick(() => {
          this.modifier.isDark = !this.modifier.isDark
        })
    }
  }
}