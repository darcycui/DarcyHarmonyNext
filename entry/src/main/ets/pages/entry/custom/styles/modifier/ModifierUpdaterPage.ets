import { MyButtonModifierUpdater, MyTextModifierUpdater } from './Modifiers';

@Entry
@Component
struct ModifierUpdaterPage {
  @State message: string = 'Test ModifierUpdater ';
  // TODO 使用 ModifierUpdater 不需要 @State修饰
  buttonModifierUpdater: MyButtonModifierUpdater = new MyButtonModifierUpdater(true);
  textModifierUpdater: MyTextModifierUpdater = new MyTextModifierUpdater(true);

  build() {
    Column({ space: 10 }) {
      // 跨文件使用ModifierUpdater
      Button(this.message)
        .attributeModifier(this.buttonModifierUpdater)
        .onClick(() => {
          // TODO 通过 AttributeUpdater 直接更新UI 跳过状态管理,违反"单向数据流"原则
          this.buttonModifierUpdater.attribute?.backgroundColor(Color.Blue)
        })
      // 跨文件使用ModifierUpdater
      Text(this.message)
        .fontColor(Color.White)
        .padding(10)
        .attributeModifier(this.textModifierUpdater)
        .onClick(() => {
          // TODO 通过 AttributeUpdater 直接更新组件的构造参数更新UI 跳过状态管理，直接,违反"单向数据流"原则
          this.textModifierUpdater.updateConstructorParams('Text构造函数参数已更新')
        })
    }
    .height('100%')
    .width('100%')
  }
}