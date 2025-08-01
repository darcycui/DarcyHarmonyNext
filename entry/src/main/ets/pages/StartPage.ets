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
  PAGE_RENDER_LAZY_FOR_EACH_PAGE_3,
  PAGE_BUILDER_1,
  PAGE_BUILDER_2,
  PAGE_BUILDER_3,
  PAGE_LOCAL_BUILDER_1,
  PAGE_EVENT,
  PAGE_NAPI,
  PAGE_LOCAL_BUILDER_2,
  PAGE_LOCAL_BUILDER_3,
  PAGE_BUILDER_PARAM_1,
  PAGE_BUILDER_PARAM_2,
  PAGE_BUILDER_PARAM_3,
  PAGE_WRAP_BUILDER_PAGE,
  PAGE_STYLES_PAGE,
  PAGE_EXTEND_PAGE,
  PAGE_STATE_STYLES_PAGE,
  PAGE_MODIFIER_PAGE,
  PAGE_MODIFIER_UPDATER_PAGE,
  PAGE_MODIFIER_UPDATER_WEIXIN_PAGE,
  PAGE_TASK_PAGE,
  PAGE_CHAT
} from './PageName';
import { RouterHelper } from 'static_library_common/src/main/ets/utils/RouterHelper';
import { common } from '@kit.AbilityKit';
import { inspector, LengthUnit } from '@kit.ArkUI';
import { Log, NavigationHelper } from 'static_library_common';
import { ItemBean } from '../models/ItemBean';

// 手动导入module中的页面
// import 'library_chat/src/main/ets/pages/chat/ChatEntryPage';
// import 'library_camera/src/main/ets/pages/camera/CameraEntryPage';


@Entry
@Component
struct StartPage {
  @State message: string = 'Hello World';
  // navigation 栈控制器
  pathStack: NavPathStack = new NavPathStack();
  // 获取上下文context
  context = getContext(this) as common.UIAbilityContext;
  // 监听组件渲染步骤
  observer: inspector.ComponentObserver = this.getUIContext().getUIInspector().createComponentObserver('scroll');
  onLayout = () => {
    // 布局结束
    // console.log('Component layout completed');
  }
  onDraw = () => {
    // console.log('Component draw completed');
  }
  // 用于控制Scroll组件的滚动
  scroller = new Scroller()

  build() {
    Navigation(this.pathStack) {


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
            this.buildItems()
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
    }.title("StartPage")
    .titleMode(NavigationTitleMode.Mini)
    .onAppear(() => {
      Log.log('StartPage onAppear')
    })
  }

  pageNameArray: ItemBean[] = [
    new ItemBean(PAGE_EVENT, $r('app.string.TestEventPage')),
    new ItemBean(PAGE_NAPI, $r('app.string.TestNApiPage')),
    new ItemBean(PAGE_WANT_ABILITY, $r('app.string.TestWantAbilityPage')),
    new ItemBean(PAGE_RELATIVE, $r('app.string.RelativePage')),
    new ItemBean(PAGE_INPUT, $r('app.string.InputPage')),
    new ItemBean(PAGE_COLUMN, $r('app.string.ColumnPage')),
    new ItemBean(PAGE_IMAGE, $r('app.string.ImagePage')),
    new ItemBean(PAGE_STATIC_CAMERA, $r('app.string.CameraPage')),
    new ItemBean(PAGE_STATIC_LIBRARY, $r('app.string.StaticLibraryPage')),
    new ItemBean(PAGE_SHARED_LIBRARY, $r('app.string.SharedLibraryPage')),
    new ItemBean(PAGE_HTTPS_CERT_PIN, $r("app.string.TestHttpsCertPinPage")),
    new ItemBean(PAGE_HTTPS, $r("app.string.TestHttpsPage")),
    new ItemBean(PAGE_WEBSOCKETS, $r("app.string.TestWebsocketsPage")),
    new ItemBean(PAGE_FILE, $r("app.string.TestFilePage")),
    new ItemBean(PAGE_SP, $r("app.string.TestSPPage")),
    new ItemBean(PAGE_KEY_VALUE, $r("app.string.TestKeyValuePage")),
    new ItemBean(PAGE_PROMISE_ASYNC_WAIT, $r("app.string.TestPromiseSyncWaitPage")),
    new ItemBean(PAGE_TASK_POOL, $r('app.string.TestTaskPoolPage')),
    new ItemBean(PAGE_WORKER, $r('app.string.TestWorkerPage')),
    new ItemBean(PAGE_UTD, $r('app.string.TestUTDPage')),
    new ItemBean(PAGE_DATABASE, $r('app.string.TestDatabasePage')),
    new ItemBean(PAGE_COMPONENT_STATUS, $r('app.string.TestComponentStatusPage')),
    new ItemBean(PAGE_STATE, $r('app.string.TestStatePage')),
    new ItemBean(PAGE_STATE_CHANGED_1, $r('app.string.TestStateChangedPage1')),
    new ItemBean(PAGE_STATE_CHANGED_2, $r('app.string.TestStateChangedPage2')),
    new ItemBean(PAGE_STATE_CHANGED_3, $r('app.string.TestStateChangedPage3')),
    new ItemBean(PAGE_STATE_CHANGED_4, $r('app.string.TestStateChangedPage4')),
    new ItemBean(PAGE_STATE_CHANGED_5, $r('app.string.TestStateChangedPage5')),
    new ItemBean(PAGE_PROP_CHANGED_1, $r('app.string.TestPropPage1')),
    new ItemBean(PAGE_PROP_CHANGED_2, $r('app.string.TestPropPage2')),
    new ItemBean(PAGE_LINK, $r('app.string.TestLinkPage')),
    new ItemBean(PAGE_PROVIDE_CONSUME, $r('app.string.TestProvidePage')),
    new ItemBean(PAGE_PROVIDE_CONSUME_2, $r('app.string.TestProvidePage2')),
    new ItemBean(PAGE_PROVIDE_CONSUME_3, $r('app.string.TestProvidePage3')),
    new ItemBean(PAGE_OBSERVED_CLASS_PAGE, $r('app.string.TestObservedClassPage')),
    new ItemBean(PAGE_OBSERVED_CLASS_PAGE_2, $r('app.string.TestObservedClassPage2')),
    new ItemBean(PAGE_OBSERVED_ARRAY_PAGE, $r('app.string.TestObservedArrayPage')),
    new ItemBean(PAGE_OBSERVED_ARRAY_PAGE_2, $r('app.string.TestObservedArrayPage2')),
    new ItemBean(PAGE_LOCAL_STORAGE_PAGE_1, $r('app.string.TestLocalStoragePage1')),
    new ItemBean(PAGE_LOCAL_STORAGE_PAGE_2, $r('app.string.TestLocalStoragePage2')),
    new ItemBean(PAGE_LOCAL_STORAGE_PAGE_3, $r('app.string.TestLocalStoragePage3')),
    new ItemBean(PAGE_LOCAL_STORAGE_PAGE_4, $r('app.string.TestLocalStoragePage4')),
    new ItemBean(PAGE_LOCAL_STORAGE_PAGE_5, $r('app.string.TestLocalStoragePage5')),
    new ItemBean(PAGE_APP_STORAGE_PAGE_1, $r('app.string.TestAppStoragePage1')),
    new ItemBean(PAGE_EMIT_PAGE, $r('app.string.TestEmitPage1')),
    new ItemBean(PAGE_PERSISTENT_PAGE, $r('app.string.TestPersistentPage')),
    new ItemBean(PAGE_ENVIRONMENT_PAGE, $r('app.string.TestEnvironmentPage')),
    new ItemBean(PAGE_WATCH_PAGE, $r('app.string.TestWatchPage')),
    new ItemBean(PAGE_WATCH_LINK_PAGE, $r('app.string.TestWatchLinkPage')),
    new ItemBean(PAGE_WATCH_CHANGE_TIME_PAGE, $r('app.string.TestWatchChangeTimePage')),
    new ItemBean(PAGE_$$_PAGE, $r('app.string.TestDollarDollarPage')),
    new ItemBean(PAGE_TRACK_PAGE, $r('app.string.TestTrackPage')),
    new ItemBean(PAGE_FREEZE_PAGE_1, $r('app.string.TestFreezePage')),
    new ItemBean(PAGE_FREEZE_TAB, $r('app.string.TestFreezeTabPage')),
    new ItemBean(PAGE_FREEZE_LIST, $r('app.string.TestFreezeListPage')),
    new ItemBean(PAGE_FREEZE_NAVIGATION, $r('app.string.TestNavigationFreezePage')),
    new ItemBean(PAGE_MVVM_TEST, $r('app.string.TestMVVMPage')),
    new ItemBean(PAGE_TEST_LIST, $r("app.string.TestListPage")),
    new ItemBean(PAGE_RENDER_IF_ELSE, $r("app.string.TestArticleListPage")),
    new ItemBean(PAGE_RENDER_IF_ELSE_WITH_STATE, $r("app.string.TestRenderIfElsePage")),
    new ItemBean(PAGE_RENDER_IF_ELSE_WITH_STATE_CHANGED, $r("app.string.TestRenderIfElseWithStatePage")),
    new ItemBean(PAGE_ANIMATE_TO, $r("app.string.TestRenderIfElseWithStateChangedPage")),
    new ItemBean(PAGE_RENDER_FOR_EACH_PAGE_1, $r("app.string.TestAnimateToPage")),
    new ItemBean(PAGE_ARTICLE_LIST, $r("app.string.TestForEachPage1")),
    new ItemBean(PAGE_RENDER_LAZY_FOR_EACH_PAGE_1, $r("app.string.TestLazyForEachPage1")),
    new ItemBean(PAGE_RENDER_LAZY_FOR_EACH_PAGE_2, $r("app.string.TestLazyForEachClassPage2")),
    new ItemBean(PAGE_RENDER_LAZY_FOR_EACH_PAGE_3, $r("app.string.TestLazyForEachReusablePage3")),
    new ItemBean(PAGE_BUILDER_1, $r("app.string.TestBuilderPage1")),
    new ItemBean(PAGE_BUILDER_2, $r("app.string.TestBuilderPage2")),
    new ItemBean(PAGE_BUILDER_3, $r("app.string.TestBuilderPage3")),
    new ItemBean(PAGE_LOCAL_BUILDER_1, $r("app.string.TestLocalBuilderPage1")),
    new ItemBean(PAGE_LOCAL_BUILDER_2, $r("app.string.TestLocalBuilderPage2")),
    new ItemBean(PAGE_LOCAL_BUILDER_3, $r("app.string.TestLocalBuilderPage3")),
    new ItemBean(PAGE_BUILDER_PARAM_1, $r("app.string.TestLocalBuilderParamPage1")),
    new ItemBean(PAGE_BUILDER_PARAM_2, $r("app.string.TestLocalBuilderParamPage2")),
    new ItemBean(PAGE_BUILDER_PARAM_3, $r("app.string.TestLocalBuilderParamPage3")),
    new ItemBean(PAGE_WRAP_BUILDER_PAGE, $r("app.string.TestWrapBuilderPage")),

    new ItemBean(PAGE_STYLES_PAGE, $r("app.string.TestStylesPage")),
    new ItemBean(PAGE_EXTEND_PAGE, $r("app.string.TestExtendPage")),
    new ItemBean(PAGE_STATE_STYLES_PAGE, $r("app.string.TestStateStylesPage")),
    new ItemBean(PAGE_MODIFIER_PAGE, $r("app.string.TestModifierPage")),
    new ItemBean(PAGE_MODIFIER_UPDATER_PAGE, $r("app.string.TestModifierUpdaterPage")),
    new ItemBean(PAGE_MODIFIER_UPDATER_WEIXIN_PAGE, $r("app.string.TestModifierUpdaterWeiXinPage")),
    new ItemBean(PAGE_TASK_PAGE, $r("app.string.TestTaskPage")),
    new ItemBean(PAGE_CHAT, $r("app.string.ChatPage")),
  ]

  @Builder
  buildItems() {
    ForEach(this.pageNameArray,
      (item: ItemBean, index: number) => {
        if (item.pageName === PAGE_CHAT || item.pageName === PAGE_STATIC_CAMERA) {
          this.buildOneItem(item.pageName, item.text, { 'keyHello': 'Hello World' }, () => {
            // RouterHelper.startNamedPage(this.getUIContext(), item.pageName, { 'keyHello': 'Hello World' })
            NavigationHelper.startPage(this.pathStack, item.pageName, { 'keyHello': 'Hello World' })
          })
        } else {
          this.buildOneItem(item.pageName, item.text, { 'keyHello': 'Hello World' })
        }
      }, (item: string, index: number) => {
        return item + index
      })

  }

  @Builder
  buildOneItem(url: string, text: ResourceStr, params?: Record<string, string>, onclick?: () => void) {
    Button(text)
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .onClick(() => {
        if (onclick) {
          Log.log('-->param onClick')
          onclick()
        } else {
          Log.log(`-->default onClick: start page: ${url}`)
          RouterHelper.startPage(this.getUIContext(), url, params);
        }
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
}

function getTextStr(): string {
  Log.log('-->build getTextStr')
  return 'This is a Harmony api test page.'
}
