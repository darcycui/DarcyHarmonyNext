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
  PAGE_EMIT_PAGE,
  PAGE_WANT_ABILITY,
  PAGE_MVVM_TEST,
  PAGE_TEST_LIST,
  PAGE_ANIMATE_TO,
  PAGE_ARTICLE_LIST,
  PAGE_EVENT,
  PAGE_NAPI,
  PAGE_STYLES_PAGE,
  PAGE_EXTEND_PAGE,
  PAGE_STATE_STYLES_PAGE,
  PAGE_MODIFIER_PAGE,
  PAGE_MODIFIER_UPDATER_PAGE,
  PAGE_MODIFIER_UPDATER_WEIXIN_PAGE,
  PAGE_TASK_PAGE,
  PAGE_CHAT,
  PAGE_STATUS_V2,
  PAGE_STATUS_V1,
  PAGE_LOCAL_APP_STORAGE_PAGE,
  PAGE_BUILDER_ENTRY,
  PAGE_FREEZE_ENTRY,
  PAGE_RENDER_ENTRY,
  PAGE_LAYOUT
} from './PageName';
import { RouterHelper } from 'static_library_common/src/main/ets/utils/RouterHelper';
import { common } from '@kit.AbilityKit';
import { inspector, LengthUnit } from '@kit.ArkUI';
import { Log, NavigationHelper, ToastHelper } from 'static_library_common';
import { ItemBean } from '../models/ItemBean';

@Entry
@Component
export struct StartPage {
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
  // 菜单栏(右上角)
  menuItem1: NavigationMenuItem = {
    value: $r('app.string.start_menu_1'),
    icon: $r('app.media.yes'),
    isEnabled: true,
    action: () => {
      ToastHelper.showToast($r('app.string.start_menu_1'))
    }
  }
  menuItem2: NavigationMenuItem = {
    value: $r('app.string.start_menu_2'),
    icon: $r('app.media.no'),
    isEnabled: true,
    action: () => {
      ToastHelper.showToast($r('app.string.start_menu_2'))
    }
  }
  // 工具栏(底部)
  toolbarItem1: ToolbarItem = {
    value: $r('app.string.start_toolbar_1'),
    icon: $r('app.media.yes'),
    status: ToolbarItemStatus.ACTIVE,
    action: () => {
      ToastHelper.showToast($r('app.string.start_toolbar_1'))
    }
  }
  toolbarItem2: ToolbarItem = {
    value: $r('app.string.start_toolbar_2'),
    icon: $r('app.media.yes'),
    status: ToolbarItemStatus.NORMAL,
    action: () => {
      ToastHelper.showToast($r('app.string.start_toolbar_2'))
      NavigationHelper.startPage(this.pathStack, PAGE_CHAT, { "key": "value" })
    }
  }

  build() {
    Navigation(this.pathStack) {
      Scroll(this.scroller) {
        Column() {
          Text(getTextStr()).visibility(Visibility.None)
          Flex({
            // 主轴方向 横向
            direction: FlexDirection.Row,
            // 多行 自动换行
            wrap: FlexWrap.Wrap,
            // 主轴对齐方式
            justifyContent: FlexAlign.Start,
            // 交叉轴对齐方式(单行)
            alignItems: ItemAlign.Start,
            // 交叉轴对齐方式(多行)
            alignContent: FlexAlign.Start,
            // 间距
            space: {
              // 主轴间距
              main: { value: 5, unit: LengthUnit.VP },
              // 交叉轴间距
              cross: { value: 5, unit: LengthUnit.VP }
            }
          }) {
            this.buildItems()
          }.width('100%').height('100%')
        }.width('100%')
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
    .mode(NavigationMode.Auto)
    .title("StartPage")
    .hideBackButton(true)
    .titleMode(NavigationTitleMode.Mini)
    // 菜单栏(右上角)
    .menus([this.menuItem1, this.menuItem2])
    // 工具栏(底部)
    // .toolbarConfiguration([this.toolbarItem1, this.toolbarItem2])
    .onAppear(() => {
      Log.log('StartPage onAppear')
    })
  }

  pageNameArray: ItemBean[] = [
    new ItemBean(PAGE_EVENT, $r('app.string.TestEventPage')),
    new ItemBean(PAGE_NAPI, $r('app.string.TestNApiPage')),
    new ItemBean(PAGE_WANT_ABILITY, $r('app.string.TestWantAbilityPage')),
    new ItemBean(PAGE_LAYOUT, $r('app.string.TestLayoutPage')),
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
    new ItemBean(PAGE_STATUS_V1, $r('app.string.TestStatusV1Page')),
    new ItemBean(PAGE_EMIT_PAGE, $r('app.string.TestEmitPage1')),
    new ItemBean(PAGE_LOCAL_APP_STORAGE_PAGE, $r('app.string.TestLocalAppStoragePage')),
    new ItemBean(PAGE_FREEZE_ENTRY, $r('app.string.TestFreezeEntryPage')),
    new ItemBean(PAGE_RENDER_ENTRY, $r('app.string.TestRenderEntryPage')),
    new ItemBean(PAGE_MVVM_TEST, $r('app.string.TestMVVMPage')),
    new ItemBean(PAGE_TEST_LIST, $r("app.string.TestListPage")),
    new ItemBean(PAGE_ARTICLE_LIST, $r("app.string.TestForEachPage1")),
    new ItemBean(PAGE_ANIMATE_TO, $r("app.string.TestAnimateToPage")),
    new ItemBean(PAGE_BUILDER_ENTRY, $r("app.string.TestBuilderEntryPage")),
    new ItemBean(PAGE_STYLES_PAGE, $r("app.string.TestStylesPage")),
    new ItemBean(PAGE_EXTEND_PAGE, $r("app.string.TestExtendPage")),
    new ItemBean(PAGE_STATE_STYLES_PAGE, $r("app.string.TestStateStylesPage")),
    new ItemBean(PAGE_MODIFIER_PAGE, $r("app.string.TestModifierPage")),
    new ItemBean(PAGE_MODIFIER_UPDATER_PAGE, $r("app.string.TestModifierUpdaterPage")),
    new ItemBean(PAGE_MODIFIER_UPDATER_WEIXIN_PAGE, $r("app.string.TestModifierUpdaterWeiXinPage")),
    new ItemBean(PAGE_TASK_PAGE, $r("app.string.TestTaskPage")),
    new ItemBean(PAGE_STATUS_V2, $r("app.string.StatusV2Page")),
  ]

  @Builder
  buildItems() {
    ForEach(this.pageNameArray,
      (item: ItemBean, index: number) => {
        if (item.pageName === PAGE_STATIC_CAMERA || item.pageName === PAGE_STATIC_LIBRARY ||
          item.pageName === PAGE_SHARED_LIBRARY) {
          this.buildOneItem(item.pageName, item.text, { 'keyHello': 'Hello World' }, () => {
            // 使用 Navigation 跳转 支持相同模块、不同模块
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
          RouterHelper.startPage(this.getUIContext(), url, params)
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
