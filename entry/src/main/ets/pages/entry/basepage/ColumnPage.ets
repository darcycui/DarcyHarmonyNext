import { common, Want } from '@kit.AbilityKit';
import { promptAction, uiObserver } from '@kit.ArkUI';
import { Log } from 'static_common';

let TAG = "[Home Struct] ";
let TAG2 = "[textComponent Struct] ";

@Entry
@Component
struct ColumnPage {
  @State messageHome: string = 'Hello World';

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
    }
    .height('100%')
    .width('100%')
  }

  startEntryAbility() {
    try {
      let want: Want = {
        deviceId: "", // TODO deviceId为空表示当前设备
        bundleName: "com.darcy.harmonys",
        abilityName: "EntryAbility",
        // 传参数
        parameters: { "paramsName": "张三", "paramsId": 1 }
      };
      // 吐司 toast
      promptAction.showToast({ message: "Go EntryAbility" })
      let context = getContext(this) as common.UIAbilityContext;
      context.startAbility(want);
      Log.info(`explicit start ability succeed`);
    } catch (error) {
      Log.error(`explicit start ability failed with ${error.code}`);
    }
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
      Button(this.text)
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
    .width('100%')
    .height('100%')
  }
}

@Component
struct buttonComponentSub {
  clickCallback?: () => void

  build() {
    Button("Sub Button")
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
