import { MyButtonModifier } from './Modifiers';

@Entry
@Component
struct ModifierPage {
  @State message: string = 'Test AttributeModifier';
  // TODO 使用导入的 Modifier 必须使用 @State修饰
  @State modifier: MyButtonModifier = new MyButtonModifier(true);

  build() {
    Column() {
      // 跨文件使用Modifier
      Button(this.message)
        .attributeModifier(this.modifier)
        .onClick(() => {
          this.modifier.isDark = !this.modifier.isDark
        })
    }
    .height('100%')
    .width('100%')
  }
}