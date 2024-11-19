import { hilog } from '@kit.PerformanceAnalysisKit';
import { router } from '@kit.ArkUI';
import { PAGE_INPUT } from '../PageName';
import { Log } from 'static_common';

let TAG = "[Index Struct] ";

@Entry
  //装饰器 入口组件
@Component
  // 装饰器 自定义组件
struct RelativePage {
  // 装饰器 组件中的状态变量(TODO 状态变化会触发UI刷新)
  @State message: string = 'Hello World  '.repeat(5);

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

  //
  build() {
    // UI描述
    // 相对布局容器
    RelativeContainer() {
      // 文本组件
      Text(this.message)
        .id('HelloWorld')// 控件id
        .fontSize(20)// TODO 单位fp(1fp=1vp)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          // 相对位置
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .textAlign(TextAlign.Start)// 文字对齐方式
        .constraintSize({ maxWidth: 200 }) // TODO 其他宽高约束
      this.buildButton()
      this.buildRow()
      this.buildColumn()
      this.buildLayoutWeight()
      // 页面跳转
      this.startPage()
    }
    .backgroundColor(Color.Orange)
    // 设置宽高 100%为全屏
    .height('100%')
    .width('100%')
  }

  @Builder
  startPage() {
    Button($r("app.string.Next"))
      .alignRules({
        bottom: { anchor: "Button", align: VerticalAlign.Top },
        left: { anchor: "Button", align: HorizontalAlign.Start },
        right: { anchor: "Button", align: HorizontalAlign.End },
      })
      .margin({ bottom: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // TODO 页面跳转 使用router
        router.pushUrl(
          // url
          { url: PAGE_INPUT },
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
  buildLayoutWeight() {
    Row() {
      // 引用string资源
      Button($r('app.string.Left')).margin({ right: 10 })
      Button("Middle").layoutWeight(1) // 设置权重
      Button("Right").margin({ left: 10 })
    }.alignRules({ bottom: { anchor: '__container__', align: VerticalAlign.Bottom } })
  }

  @Builder
  buildColumn() {
    Column() {
      Button("Button4")
      Button("Button5").margin({ top: 10 })
      Button("Button6").margin({ top: 10 })
    }.backgroundColor(Color.Gray)
    .padding(20) // 内边距 TODO 单位vp
    .margin({ top: 80 }) // 外边距
  }

  @Builder
  buildRow() {
    Row() {
      Button("Button1").margin({ right: 10 })
      Button("Button2").margin({ right: 10 })
      Button("Button3")
    }.backgroundColor(Color.Green)
    .padding(20) // 内边距
    .margin({ top: 0 }) // 外边距
  }

  @Builder
  buildButton() {
    Button("Click Me")
      .id("Button")// .width('auto')// 宽度自适应wrap
        // .height('auto')// 高度自适应wrap
      .size({ width: 'auto', height: 'auto' })// 宽高自适应wrap
      .alignRules({
        top: { anchor: 'HelloWorld', align: VerticalAlign.Bottom },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        left: { anchor: 'HelloWorld', align: HorizontalAlign.Start },
        right: { anchor: 'HelloWorld', align: HorizontalAlign.End }
      })// 点击事件
      .onClick((event: ClickEvent) => {
        this.message = "Welcome to ArkUI.";
        // 打印日志log
        hilog.debug(0x0000, TAG, "event--> x=" + event.x + " y=" + event.y);
      })
  }
}