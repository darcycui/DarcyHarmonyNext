import { promptAction, router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { common, Want } from '@kit.AbilityKit';
import { PAGE_COLUMN } from '../../PageName';
import { Log } from 'static_common';

let TAG = "[InputPage] ";

@Entry
@Component
struct InputPage {
  @State httpText: string = 'default';
  @State inputStr: string = '';
  private context = getContext(this) as common.UIAbilityContext;

  // 生命周期回调:页面显示 只限入口组件
  onPageShow(): void {
    Log.info(TAG + "onPageShow");
  }

  // 生命周期回调:页面隐藏 只限入口组件
  onPageHide(): void {
    Log.info(TAG + "onPageHide")
  }

  // 生命周期回调:返回键 只限入口组件
  onBackPress(): boolean | void {
    Log.info(TAG + "onBackPress");
    return false; // 返回false不消费回退事件
  }

  // 生命周期回调:页面即将显示 所有组件
  aboutToAppear(): void {
    Log.info(TAG + "aboutToAppear");
  }

  // 生命周期回调:页面build完毕 所有组件
  onDidBuild(): void {
    Log.info(TAG + "onDidBuild");
  }

  // 生命周期回调:页面即将消失 所有组件
  aboutToDisappear(): void {
    Log.info(TAG + "aboutToDisappear");
  }

  build() {
    RelativeContainer() {

      // TODO:注意这里的this不能省略
      TextInput({ placeholder: "输入要搜索的内容", text: this.inputStr })
        .id("SearchTextInput")
        .alignRules({
          top: { anchor: 'ButtonFlex', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .margin({ top: 10 })// 外边距
        .onChange((value: string, previewText?: PreviewText) => {
          this.inputStr = value
        })
        .onSubmit((enterKey: EnterKeyType, event: SubmitEvent) => {
          // 吐司 toast
          promptAction.showToast({ message: "完成:" + this.inputStr })
        })

      Text(this.httpText)
        .id("HttpText")
        .alignRules(
          {
            top: { anchor: "SearchTextInput", align: VerticalAlign.Bottom }
          }
        )
        .margin({ top: 10 })
        .visibility(Visibility.Visible)
      // TODO Flex布局
      Flex({
        // 自动换行
        wrap: FlexWrap.Wrap,
        // 主轴对齐方式
        justifyContent: FlexAlign.SpaceEvenly,
        // 交叉轴对齐方式
        alignContent: FlexAlign.SpaceEvenly
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
      }.height(100)
      .id("ButtonFlex")
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })

    }
    .height('100%')
    .width('100%')
    .visibility(Visibility.Visible)

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
      .margin({ left: 10 })// 外边距
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
    Button($r("app.string.HomeAbility"))
      .id("HomeButton")
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // TODO 页面跳转 使用router
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
      .margin({ left: 10 })// 外边距
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
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // TODO 结束当前页面
        let context = getContext(this) as common.UIAbilityContext;
        context.terminateSelf(() => {
          Log.log("Succeed to terminateSelf")
        })
      })
  }
}
