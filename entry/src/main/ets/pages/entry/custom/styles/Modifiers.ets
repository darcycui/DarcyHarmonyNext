// TODO 实现 AttributeModifier 接口
export class MyButtonModifier implements AttributeModifier<ButtonAttribute> {
  isDark: boolean = false;
  applyNormalAttribute(instance: ButtonAttribute): void {
    if (this.isDark) {
      instance.backgroundColor(Color.Black)
    } else {
      instance.backgroundColor(Color.Brown)
    }
  }
}