import { AttributeUpdater } from "@kit.ArkUI";
import { Log } from 'static_library_common';

// TODO 实现 AttributeModifier 接口
export class MyButtonModifier implements AttributeModifier<ButtonAttribute> {
  isDark: boolean = false;

  constructor(isDark: boolean) {
    this.isDark = isDark;
  }

  applyNormalAttribute(instance: ButtonAttribute): void {
    if (this.isDark) {
      instance.backgroundColor(Color.Black)
    } else {
      instance.backgroundColor(Color.Brown)
    }
  }
}

export class MyButtonModifierUpdater extends AttributeUpdater<ButtonAttribute> {
  isDark: boolean = false;

  constructor(isDark: boolean) {
    super();
    this.isDark = isDark;
  }

  // 初始化时候调用
  initializeModifier(instance: ButtonAttribute): void {
    instance.backgroundColor(Color.Black)
  }

  // 组件变化时候调用
  onComponentChanged(component: ButtonAttribute): void {
    Log.info("MyButtonModifierUpdater onComponentChanged"); // TODO 不调用？
  }
}

export class MyTextModifierUpdater extends AttributeUpdater<TextAttribute, TextInterface> {
  isDark: boolean = false;

  constructor(isDark: boolean) {
    super();
    this.isDark = isDark;
  }

  // 初始化时候调用
  initializeModifier(instance: TextAttribute): void {
    // this.applyNormalAttribute(instance)
    instance.backgroundColor(Color.Black)
  }

  // 组件变化时候调用
  onComponentChanged(component: TextAttribute): void {
    Log.info("MyTextModifierUpdater onComponentChanged"); // TODO 不调用？
  }
}