import { Log } from 'static_library_common';
import { ConversationListPage } from './main/conversation/ConversationListPage';
import { ContactPage } from './main/contact/ContactPage';
import { MinePage } from './main/mine/MinePage';

@Builder
export function NavigationBuilder() {
  Index()
}

@Entry
@ComponentV2
struct Index {
  @Local message: string = 'This is contract page';
  @Local currentIndex: number = 1;
  // navigation路由控制器 @Provider跨页面传递
  @Consumer('HomePathStack') pathStack: NavPathStack = new NavPathStack();

  // 自定义 TabContent
  @Builder
  tabBuilder(targetIndex: number, title: string | Resource, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    NavDestination() {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() {
          ConversationListPage({ activeTabIndex: this.currentIndex }
          )
        }.tabBar(this.tabBuilder(0, $r("app.string.tab_bar_title_chat"), $r('app.media.yes'), $r('app.media.no')))

        TabContent() {
          ContactPage( { activeTabIndex: this.currentIndex } )
        }.tabBar(this.tabBuilder(1, $r("app.string.tab_bar_title_contract"), $r('app.media.yes'), $r('app.media.no')))

        TabContent() {
          MinePage( { activeTabIndex: this.currentIndex } )
        }.tabBar(this.tabBuilder(2, $r("app.string.tab_bar_title_me"), $r('app.media.yes'), $r('app.media.no')))
      }
      .scrollable(true)
      .barMode(BarMode.Fixed)
      // 监听选中页面
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
    .width('100%')
    .height('100%')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }

  pageName = "IndexPage"

  // 生命周期方法
  onPageShow(): void {
    Log.debug(`-->${this.pageName} onPageShow`)
  }

  onPageHide(): void {
    Log.warn(`-->${this.pageName} onPageHide`)
  }

  onBackPress(): boolean | void {
    Log.log(`-->${this.pageName} onBackPress`)
  }

  aboutToAppear(): void {
    Log.log(`-->${this.pageName} aboutToAppear`)
  }

  aboutToDisappear(): void {
    Log.error(`-->${this.pageName} aboutToDisappear`)
  }

  onDidBuild(): void {
    Log.log(`-->${this.pageName} onDidBuild`)
  }
}
