import { common } from '@kit.AbilityKit';
import { uiObserver } from '@kit.ArkUI';
import { Log } from 'static_library_common';
import { AbilityHelper } from 'static_library_common/src/main/ets/utils/AbilityHelper';

let TAG = "[Home Struct] ";
let TAG2 = "[textComponent Struct] ";

@Entry
@Component
struct ColumnPage {
  @State messageHome: string = 'Hello World';
  context = getContext(this) as common.UIAbilityContext;

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
    Column() {
      // TODO:使用另一个自定义组件 并传递参数 注意这里的参数需要{}包裹
      textComponent({ text: "Home Page" }).backgroundColor(Color.Gray)
      buttonComponentParent({
        text: "Go EntryAbility",
        clickCallback: this.startEntryAbility
      })
    }.justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .height('100%')
    .width('100%')
  }

  startEntryAbility() {
    AbilityHelper.startAbility(this.context, "EntryAbility", {})
  }
}

@Component
struct textComponent {
  // 自定义组件的参数
  text: string = ""
  // TODO 非入口组件 监听入口组件的生命周期
  // 定义回调函数
  listener: (info: uiObserver.RouterPageInfo) => void = (info: uiObserver.RouterPageInfo) => {
    let routerInfo: uiObserver.RouterPageInfo | undefined = this.queryRouterPageInfo()
    if (info.pageId === routerInfo?.pageId) {
      if (info.state === uiObserver.RouterPageState.ON_PAGE_SHOW) {
        Log.info(TAG2 + "onPageShow callback");
      } else if (info.state === uiObserver.RouterPageState.ON_PAGE_HIDE) {
        Log.info(TAG2 + "onPageHide callback");
      }
    }
  }

  // 生命周期回调:页面显示 只限入口组件
  onPageShow(): void {
    Log.info(TAG2 + "onPageShow");
  }

  // 生命周期回调:页面隐藏 只限入口组件
  onPageHide(): void {
    Log.info(TAG2 + "onPageHide")
  }

  // 生命周期回调:返回键 只限入口组件
  onBackPress(): boolean | void {
    Log.info(TAG2 + "onBackPress");
    return false; // 返回false不消费回退事件
  }

  // 生命周期回调:页面即将显示 所有组件
  aboutToAppear(): void {
    Log.info(TAG2 + "aboutToAppear");
    // 注册监听
    let uiObserver = this.getUIContext().getUIObserver()
    uiObserver.on("routerPageUpdate", this.listener);
  }

  // 生命周期回调:页面build完毕 所有组件
  onDidBuild(): void {
    Log.info(TAG2 + "onDidBuild");
  }

  // 生命周期回调:页面即将消失 所有组件
  aboutToDisappear(): void {
    Log.info(TAG2 + "aboutToDisappear");
    // 取消监听
    let uiObserver = this.getUIContext().getUIObserver()
    uiObserver.off("routerPageUpdate", this.listener)
  }

  build() {
    Text(this.text)
  }
}

@Component
struct buttonComponentParent {
  // 自定义组件的参数
  text: string = "";
  clickCallback?: () => void

  build() {
    Column() {
      Button(this.text).width('100%')
        .margin({ top: 10 })
        .onClick(() => {
          // this.clickCallback?.call;
          // 调用lambda 函数
          if (this.clickCallback) {
            this.clickCallback();
          }
        })
      // 将lambda 函数传递给子组件
      buttonComponentSub({ clickCallback: this.clickCallback })
    }
    .width('auto')
    .height('auto')
  }
}

@Component
struct buttonComponentSub {
  clickCallback?: () => void

  build() {
    Button("Sub Button").width('100%')
      .margin({ top: 10 })
      .onClick(() => {
        // this.callback?.call
        // 调用lambda 函数
        if (this.clickCallback) {
          this.clickCallback();
        }
      })
  }
}
