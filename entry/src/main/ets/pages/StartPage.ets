import {
  PAGE_STATIC_CAMERA,
  PAGE_COLUMN,
  PAGE_FILE,
  PAGE_HTTPS,
  PAGE_HTTPS_CERT_PIN,
  PAGE_IMAGE,
  PAGE_INPUT,
  PAGE_PROMISE_ASYNC_WAIT,
  PAGE_RELATIVE,
  PAGE_SHARED_INNER,
  PAGE_SHARED_LIBRARY,
  PAGE_SP,
  PAGE_STATIC_INNER,
  PAGE_STATIC_LIBRARY,
  PAGE_TASK_POOL,
  PAGE_WEBSOCKETS,
  PAGE_WORKER,
  PAGE_UTD,
  PAGE_KEY_VALUE,
  PAGE_DATABASE,
  PAGE_COMPONENT_STATUS,
  PAGE_STATE,
  PAGE_STATE_CHANGED_1,
  PAGE_STATE_CHANGED_2,
  PAGE_STATE_CHANGED_3,
  PAGE_STATE_CHANGED_4,
  PAGE_STATE_CHANGED_5,
  PAGE_PROP_CHANGED_1,
  PAGE_PROP_CHANGED_2,
  PAGE_LINK,
  PAGE_PROVIDE_CONSUME,
  PAGE_PROVIDE_CONSUME_2,
  PAGE_PROVIDE_CONSUME_3,
  PAGE_OBSERVED_CLASS_PAGE,
  PAGE_OBSERVED_CLASS_PAGE_2,
  PAGE_OBSERVED_ARRAY_PAGE,
  PAGE_OBSERVED_ARRAY_PAGE_2,
  PAGE_LOCAL_STORAGE_PAGE_1,
  PAGE_LOCAL_STORAGE_PAGE_2,
  PAGE_LOCAL_STORAGE_PAGE_3,
  PAGE_LOCAL_STORAGE_PAGE_4,
  PAGE_LOCAL_STORAGE_PAGE_5,
  PAGE_APP_STORAGE_PAGE_1,
  PAGE_EMIT_PAGE,
  PAGE_PERSISTENT_PAGE,
  PAGE_ENVIRONMENT_PAGE,
  PAGE_WATCH_PAGE,
  PAGE_WATCH_LINK_PAGE,
  PAGE_WATCH_CHANGE_TIME_PAGE,
  PAGE_$$_PAGE,
  PAGE_TRACK_PAGE,
  PAGE_FREEZE_PAGE_1,
  PAGE_FREEZE_TAB,
  PAGE_FREEZE_LIST,
  PAGE_FREEZE_NAVIGATION,
  PAGE_WANT_ABILITY,
  PAGE_MVVM_TEST,
  PAGE_TEST_LIST,
  PAGE_RENDER_IF_ELSE,
  PAGE_RENDER_IF_ELSE_WITH_STATE,
  PAGE_RENDER_IF_ELSE_WITH_STATE_CHANGED,
  PAGE_ANIMATE_TO,
  PAGE_RENDER_FOR_EACH_PAGE_1,
  PAGE_ARTICLE_LIST,
  PAGE_RENDER_LAZY_FOR_EACH_PAGE_1,
  PAGE_RENDER_LAZY_FOR_EACH_PAGE_2,
  PAGE_RENDER_LAZY_FOR_EACH_PAGE_3
} from './PageName';
import { startNamedPage, startPage } from '../utils/RouterHelper';
import { common } from '@kit.AbilityKit';
import { EntryEvent } from '../event/EventName';
import { inspector, LengthUnit, promptAction, UIContext } from '@kit.ArkUI';
import { nativeAdd } from 'library_camera_static';
import { Student } from '../network/models/HttpBean';
import { Log } from 'static_common';

@Entry
@Component
struct StartPage {
  @State message: string = 'Hello World';
  // 获取上下文context
  context = getContext(this) as common.UIAbilityContext;
  @State stu: Student | undefined = new Student("Tom", 7);
  // 监听组件渲染步骤
  observer: inspector.ComponentObserver = this.getUIContext().getUIInspector().createComponentObserver('scroll');
  onLayout = () => {
    // 布局结束
    console.log('Component layout completed');
  }
  onDraw = () => {
    console.log('Component draw completed');
  }
  // 用于控制Scroll组件的滚动
  scroller = new Scroller()

  build() {
    Scroll(this.scroller) {
      Column() {
        Text(getTextStr())
        Blank().height(5)
        Flex({
          // 主轴方向 横向
          direction: FlexDirection.Row,
          // 多行 自动换行
          wrap: FlexWrap.Wrap,
          // 主轴对齐方式
          justifyContent: FlexAlign.Start,
          // 交叉轴对齐方式
          alignItems: ItemAlign.Start,
          // 交叉轴多行 额外空间对齐
          // alignContent: FlexAlign.Center,
          // 间距
          space: {
            // 主轴间距
            main: { value: 5, unit: LengthUnit.VP },
            // 交叉轴间距
            cross: { value: 10, unit: LengthUnit.VP }
          }
        }) {
          this.buildButtons()
        }
      }
      .width('100%')

      // .height('100%') // Scroll的子组件 不能设置height为100% 否则无法滚动
    }
    .scrollable(ScrollDirection.Vertical)
    .width('100%')
    .height('100%')
    .id('scroll')
    .onAppear(() => {
      Log.log('scroll onAppear')
      // 等待绘制结束 滚动到底部
      setTimeout(() => {
        this.scroller.scrollEdge(Edge.Bottom)
      }, 1_00)
    })
  }

  @Builder
  buildButtons() {
    Button($r('app.string.TestWantAbilityPage'))
      .id('TestWantAbilityPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_WANT_ABILITY, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.RelativePage'))
      .id('RelativePage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_RELATIVE, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.InputPage'))
      .id('InputPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_INPUT, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.ColumnPage'))
      .id('ColumnPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_COLUMN, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.ImagePage'))
      .id('ImagePage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_IMAGE, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.CameraPage'))
      .id('CameraPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        let sum = nativeAdd(1, 2);
        promptAction.showToast({ message: `CameraPage sum=${sum}` });
        startNamedPage(PAGE_STATIC_CAMERA, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.StaticLibraryPage'))
      .id('StaticLibraryPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_STATIC_LIBRARY, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.SharedLibraryPage'))
      .id('SharedLibraryPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_SHARED_LIBRARY, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.TestEventHub'))
      .id('TestEventHub')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        // TODO eventHub Page发送事件给Ability
        this.context.eventHub.emit(EntryEvent.EVENT_CLICK, 'Tom and Jerry from StartPage');
      })
    Button($r('app.string.TestCallFunction'))
      .id('TestCallFunction')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)// .onClick(this.onShow) // 错误:找不到this
      .onClick(() => {
        this.clickFunction();
      })
    Button($r('app.string.TestHttpsCertPin'))
      .id('TestHttpsCertPin')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_HTTPS_CERT_PIN, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.TestHttps'))
      .id('TestHttps')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_HTTPS, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.TestWebsockets'))
      .id('TestWebsockets')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_WEBSOCKETS, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.TestFile'))
      .id('TestFile')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_FILE, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.TestSP'))
      .id('TestSP')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_SP, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.TestKeyValue'))
      .id('TestKeyValue')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_KEY_VALUE, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.TestPromiseSyncWait'))
      .id('TestPromiseSyncWait')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_PROMISE_ASYNC_WAIT, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.TestTaskPoolPage'))
      .id('TestTaskPoolPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_TASK_POOL, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.TestWorkerPage'))
      .id('TestWorkerPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_WORKER, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.TestUTDPage'))
      .id('TestUTDPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_UTD, { 'keyHello': 'Hello World' });
      })
    Button($r('app.string.TestDatabasePage'))
      .id('TestDatabasePage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_DATABASE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestComponentStatusPage"))
      .id('TestComponentStatusPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_COMPONENT_STATUS, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestStatePage"))
      .id('TestStatePage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_STATE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestStateChangedPage1"))
      .id('TestStateChangedPage1')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_STATE_CHANGED_1, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestStateChangedPage2"))
      .id('TestStateChangedPage2')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_STATE_CHANGED_2, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestStateChangedPage3"))
      .id('TestStateChangedPage3')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_STATE_CHANGED_3, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestStateChangedPage4"))
      .id('TestStateChangedPage4')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_STATE_CHANGED_4, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestStateChangedPage5"))
      .id('TestStateChangedPage5')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_STATE_CHANGED_5, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestPropPage1"))
      .id('TestPropChangedPage1')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_PROP_CHANGED_1, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestPropPage2"))
      .id('TestPropChangedPage2')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_PROP_CHANGED_2, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestLinkPage"))
      .id('TestLinkPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_LINK, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestProvidePage"))
      .id('TestProvidePage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_PROVIDE_CONSUME, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestProvidePage2"))
      .id('TestProvidePage2')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_PROVIDE_CONSUME_2, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestProvidePage3"))
      .id('TestProvidePage3')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_PROVIDE_CONSUME_3, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestObservedClassPage"))
      .id('TestObservedClassPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_OBSERVED_CLASS_PAGE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestObservedClassPage2"))
      .id('TestObservedClassPage2')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_OBSERVED_CLASS_PAGE_2, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestObservedArrayPage"))
      .id('TestObservedArrayPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_OBSERVED_ARRAY_PAGE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestObservedArrayPage2"))
      .id('TestObservedArrayPage2')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_OBSERVED_ARRAY_PAGE_2, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestLocalStoragePage1"))
      .id('TestLocalStoragePage1')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_LOCAL_STORAGE_PAGE_1, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestLocalStoragePage3"))
      .id('TestLocalStoragePage3')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_LOCAL_STORAGE_PAGE_3, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestLocalStoragePage4"))
      .id('TestLocalStoragePage4')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_LOCAL_STORAGE_PAGE_4, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestLocalStoragePage5"))
      .id('TestLocalStoragePage5')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_LOCAL_STORAGE_PAGE_5, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestAppStoragePage1"))
      .id('TestAppStoragePage1')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_APP_STORAGE_PAGE_1, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestEmitPage1"))
      .id('TestEmitPage1')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_EMIT_PAGE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestPersistentPage"))
      .id('TestPersistentPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_PERSISTENT_PAGE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestEnvironmentPage"))
      .id('TestEnvironmentPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_ENVIRONMENT_PAGE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestWatchPage"))
      .id('TestWatchPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_WATCH_PAGE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestWatchLinkPage"))
      .id('TestWatchLinkPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_WATCH_LINK_PAGE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestWatchChangeTimePage"))
      .id('TestWatchChangeTimePage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_WATCH_CHANGE_TIME_PAGE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestDollarDollarPage"))
      .id('Test$$Page')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_$$_PAGE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestTrackPage"))
      .id('TestTrackPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_TRACK_PAGE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestFreezePage"))
      .id('TestFreezePage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_FREEZE_PAGE_1, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestFreezeTabPage"))
      .id('TestFreezeTabPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_FREEZE_TAB, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestFreezeListPage"))
      .id('TestFreezeListPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_FREEZE_LIST, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestNavigationFreezePage"))
      .id('TestNavigationFreezePage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_FREEZE_NAVIGATION, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestMVVMPage"))
      .id('TestMVVMPage')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_MVVM_TEST, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestList"))
      .id('TestList')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_TEST_LIST, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestArticleList"))
      .id('TestArticleList')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_ARTICLE_LIST, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestRenderIfElse"))
      .id('TestRenderIfElse')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_RENDER_IF_ELSE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestRenderIfElseWithState"))
      .id('TestRenderIfElseWithState')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_RENDER_IF_ELSE_WITH_STATE, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestRenderIfElseWithStateChanged"))
      .id('TestRenderIfElseWithStateChanged')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_RENDER_IF_ELSE_WITH_STATE_CHANGED, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestAnimateTo"))
      .id('TestAnimateTo')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_ANIMATE_TO, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestForEach1"))
      .id('TestForEach1')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_RENDER_FOR_EACH_PAGE_1, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestLazyForEach1"))
      .id('TestLazyForEach1')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_RENDER_LAZY_FOR_EACH_PAGE_1, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestLazyForEachClass2"))
      .id('TestLazyForEachClass2')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_RENDER_LAZY_FOR_EACH_PAGE_2, { 'keyHello': 'Hello World' });
      })
    Button($r("app.string.TestLazyForEachReusable3"))
      .id('TestLazyForEachReusable3')
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        startPage(PAGE_RENDER_LAZY_FOR_EACH_PAGE_3, { 'keyHello': 'Hello World' });
      })
  }

  // 生命周期方法
  onPageShow(): void {
    Log.log('-->onPageShow')
  }

  onPageHide(): void {
    Log.log('-->onPageHide')
  }

  onBackPress(): boolean | void {
    Log.log('-->onBackPress')
  }

  aboutToAppear(): void {
    Log.log('-->aboutToAppear')
    this.observer.on('layout', this.onLayout);
    this.observer.on('draw', this.onDraw)
  }

  aboutToDisappear(): void {
    Log.log('-->aboutToDisappear')
    this.observer.off('layout', this.onLayout)
    this.observer.off('draw', this.onDraw)
  }

  onDidBuild(): void {
    Log.log('-->onDidBuild')
  }

  clickFunction() {
    console.log(`StartPage onShow this=${this}`);
    console.log(`stu.getName()=${this.stu?.getName()}`);
    console.log(`stu.name=${this.stu?.name}`);
    console.log(`stu.getAge()=${this.stu?.getAge()}`);
    console.log(`stu.age=${this.stu?.age}`);
  }
}

function getTextStr(): string {
  Log.log('-->build getTextStr')
  return 'This is a Harmony api test page.'
}
