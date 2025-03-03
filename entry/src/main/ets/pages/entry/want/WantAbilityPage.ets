import { Log } from 'static_common';
import { common, Want } from '@kit.AbilityKit';
import { LengthUnit, router } from '@kit.ArkUI';
import { PAGE_COLUMN } from '../../PageName';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct WantAbilityPage {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('WantAbilityPageHelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome';
        })
      // TODO Flex布局
      Flex({
        // 横向
        direction: FlexDirection.Row,
        // 自动换行
        wrap: FlexWrap.Wrap,
        // 主轴对齐方式
        justifyContent: FlexAlign.Start,
        // 交叉轴对齐方式
        alignItems: ItemAlign.Start,
        // 间距
        space: {
          main: {value: 5, unit: LengthUnit.VP},
          cross: {value: 10, unit: LengthUnit.VP}
        }
      }) {
        this.backButton()
        // TODO 跳转到login Feature
        this.startLoginFeatureAbility()
        // 跳转Ability
        this.startHomeAbility()
        // 跳转Page
        this.startHomePage()
        // 结束当前页面
        this.finish()
      }.width('100%')
      .id("ButtonFlex")
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  backButton() {
    Button($r("app.string.Back"))
      .id("BackButton")
      .onClick(() => {
        try {
          // TODO 页面回退
          router.back();
          Log.log("Succeed to back");
        } catch (err) {
          let code = (err as BusinessError).code;
          let message = (err as BusinessError).message;
          Log.error("Failed to back. Code is " + code + " message is " + message);
        }
      })
  }

  @Builder
  startLoginFeatureAbility() {
    Button($r("app.string.LoginFeatureAbility"))
      .id("LoginFeatureButton")
      .onClick((event: ClickEvent) => {
        // TODO feature module页面跳转 使用want
        try {
          let want: Want = {
            deviceId: "", // TODO deviceId为空表示当前设备
            bundleName: "com.darcy.harmonys",
            abilityName: "LoginAbility"
          };
          let context = getContext(this) as common.UIAbilityContext;
          context.startAbility(want);
          Log.info(`explicit start ability succeed`);
        } catch (error) {
          Log.error(`explicit start ability failed with ${error.code}`);
        }
      })
  }

  @Builder
  startHomeAbility() {
    Button($r("app.string.HomeAbility2"))
      .id("HomeButton")
      .onClick((event: ClickEvent) => {
        // TODO Ability页面跳转 使用 want + router
        try {
          let want: Want = {
            deviceId: "", // TODO deviceId为空表示当前设备
            bundleName: "com.darcy.harmonys",
            abilityName: "HomeAbility",
            parameters: { "paramsName": "李四", "paramsId": 2 }
          };
          let context = getContext(this) as common.UIAbilityContext;
          context.startAbility(want);
          Log.info(`explicit start ability succeed`);
        } catch (error) {
          Log.error(`explicit start ability failed with ${error.code}`);
        }
      })
  }

  @Builder
  startHomePage() {
    Button($r("app.string.HomePage"))
      .id("HomeButton")
      .onClick((event: ClickEvent) => {
        // TODO 页面跳转 使用router
        router.pushUrl(
          // url
          { url: PAGE_COLUMN },
          // 启动模式
          router.RouterMode.Standard
        ).then(() => {
          Log.log("Succeed to start page")
        }).catch((err: Error) => {
          Log.error("Failed to start page")
        })
      })
  }

  @Builder
  finish() {
    Button($r("app.string.Terminate"))
      .id("TerminateButton")
      .onClick((event: ClickEvent) => {
        // TODO 结束当前页面
        let context = getContext(this) as common.UIAbilityContext;
        context.terminateSelf(() => {
          Log.log("Succeed to terminateSelf")
        })
      })
  }
}