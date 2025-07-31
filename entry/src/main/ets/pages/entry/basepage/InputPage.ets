import { common } from '@kit.AbilityKit';
import { Log, ToastHelper } from 'static_library_common';

let TAG = "[InputPage] ";

@Entry
@Component
struct InputPage {
  @State message: string = 'test input text';
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
      Text(this.message)
        .id("HttpText")
        .alignRules(
          {
            top: { anchor: "SearchTextInput", align: VerticalAlign.Bottom }
          }
        )
        .margin({ top: 10 })
        .visibility(Visibility.Visible)

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
          ToastHelper.showToast("完成:" + this.inputStr)
          this.message = "完成:" + this.inputStr
        })
    }
    .height('100%')
    .width('100%')
    .visibility(Visibility.Visible)

  }
}
