import { common, Want } from '@kit.AbilityKit';
import { RouterHelper } from 'static_library_common';

@Entry
@Component
struct TestPage {
  @State message: string = 'Hello World';
  context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Text(this.message)
        .id('TestPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button($r("app.string.HomePage")).onClick(()=>{
        // TODO entry module页面跳转 使用want
        RouterHelper.startAbility(this.context, "HomeAbility", {})
      })
    }
    .height('100%')
    .width('100%')
  }
}