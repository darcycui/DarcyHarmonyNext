import { common, Want } from '@kit.AbilityKit';
import { Log } from 'static_common';

@Entry
@Component
struct TestPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text(this.message)
        .id('TestPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button($r("app.string.HomePage")).onClick(()=>{
        // TODO entry module页面跳转 使用want
        try {
          let want: Want = {
            deviceId: "", // TODO deviceId为空表示当前设备
            bundleName: "com.darcy.harmonys",
            abilityName: "HomeAbility"
            // abilityName: "EntryAbility"
          };
          let context = getContext(this) as common.UIAbilityContext;
          context.startAbility(want);
          Log.info(`explicit start ability succeed`);
        } catch (error) {
          Log.error(`explicit start ability failed with ${error.code}`);
        }
      })
    }
    .height('100%')
    .width('100%')
  }
}