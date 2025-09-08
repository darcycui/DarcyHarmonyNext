import { ChatEntryPage } from 'library_chat';
import { ContractPage } from 'library_contract';
import { StartPage } from './StartPage';

@Entry
@Component
struct Index {
  @State message: string = 'This is contract page';
  @State currentIndex: number = 0;

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
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
      TabContent() {
        ChatEntryPage()
      }.tabBar(this.tabBuilder(0, $r("app.string.tab_bar_title_chat"), $r('app.media.yes'), $r('app.media.no')))

      TabContent() {
        ContractPage()
      }.tabBar(this.tabBuilder(1, $r("app.string.tab_bar_title_contract"), $r('app.media.yes'), $r('app.media.no')))

      TabContent() {
        StartPage()
      }.tabBar(this.tabBuilder(2, $r('app.string.tab_bar_title_me'), $r('app.media.yes'), $r('app.media.no')))
    }.scrollable(true)
    .barMode(BarMode.Fixed)
    // 监听选中页面
    .onChange((index: number) => {
      this.currentIndex = index
    })
  }
}