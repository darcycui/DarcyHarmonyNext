import { Log } from 'static_common';
import { Article } from '../../../models/Article';

@Entry
@Component
struct ArticleListPage {
  @State message: string = '这是文章列表页面';
  @State articleList: Array<Article> = []
  @State isListReachEnd: boolean = false;
  @State isLoadingMore: boolean = false;

  @State isListReachStart: boolean = false;
  @State isRefreshing: boolean = false;

  aboutToAppear(): void {
    for (let index = 0; index < 20; index++) {
      this.articleList.push(new Article(`${index + 1}`, `第${index + 1}篇文章`, '文章简介内容', false, 100))
    }
  }

  count: number = 100

  loadMoreArticles() {
    if (this.isLoadingMore) {
      return
    }
    this.isLoadingMore = true
    this.isListReachEnd = true
    setTimeout(() => {
      Log.log(`loadMoreArticles ${this.count}`)
      for (let index = 0; index < 10; index++) {
        this.articleList.push(new Article(`${this.count + 1}`, `第${this.count + 1}篇文章`, '文章简介内容', false,
          100));
        this.count++
      }
      this.isLoadingMore = false
      this.isListReachEnd = false
    }, 1_000)
  }
  refreshArticles() {
    if (this.isRefreshing) {
      return
    }
    this.isRefreshing = true;
    this.isListReachStart = true;
    setTimeout(() => {
      Log.log('refreshArticles');
      this.articleList = []; // 清空现有数据
      for (let index = -1; index >- 20; index--) {
        this.articleList.push(new Article(`${index + 1}`, `第${index + 1}篇文章`, '文章简介内容', false, 100));
      }
      this.isRefreshing = false;
      this.isListReachStart = false;
    }, 1000);
  }

  build() {
    Column() {
      Text(this.message)
      List() {
        // 下拉刷新提示
        if (this.isRefreshing) {
          ListItem() {
            Text('Refreshing...')
              .fontSize(36)
              .padding(10)
              .textAlign(TextAlign.Center)
              .width('100%')
          }
        }
        ForEach(this.articleList,
          (item: Article) => {
            ListItem() {
              ArticleCard({ article: item }).margin({ top: 20 })
            }
            // item点击事件
            .onClick(() => {
              Log.log(`列表item onClick ${item.title}`)
            })
          },
          (item: Article) => {
            Log.log(`item key: ${item.hash()}`)
            return item.hash()
          })
        // 加载更多提示
        if (this.isLoadingMore) {
          ListItem() {
            Text('Loading...')
              .fontSize(36)
              .padding(10)
              .textAlign(TextAlign.Center)
              .width('100%')
          }
        }
      }
      .onReachStart(() => {
        Log.log('onReachStart')
        this.isListReachStart = true
      })
      .onReachEnd(() => {
        Log.log('onReachEnd')
        this.isListReachEnd = true
      })
      .onScrollStart(() => {
        Log.log('onScrollStart')
      })
      .onScrollStop(() => {
        Log.log('onScrollStop')
      })
      .onClick(() => {
        Log.log('列表 onClick')
      })
      // 分隔线
      .divider({
        color: Color.Green,
        strokeWidth: 10,
        startMargin: 20,
        endMargin: 20
      })
      // 滚动条
      .scrollBar(BarState.Off)
      // 缓存数量
      // .cachedCount(0)
      // 上拉加载
      .parallelGesture(
        PanGesture({ direction: PanDirection.Up, distance: 80 })
          .onActionStart(() => {
            if (this.isListReachEnd) {
              Log.log('onActionStart is end')
              this.loadMoreArticles();
            } else {
              Log.log('onActionStart is not end')
            }
          })
      )
      // 下拉刷新
      .parallelGesture(
        PanGesture({ direction: PanDirection.Down, distance: 80 })
          .onActionStart(() => {
            if (this.isListReachStart) {
              Log.log('onActionStart is refreshing');
              this.refreshArticles();
            } else {
              Log.log('onActionStart is already refreshing');
            }
          })
      )
      .padding(20)
      .width('100%')
      .height('auto') //高度自适应
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct ArticleCard {
  // @Prop article: Article;
  @ObjectLink @Watch('initItem') article: Article;

  build() {
    Row() {
      Image($r('app.media.app_icon2'))
        .width(80)
        .height(80)
        .margin({ right: 20 })

      Column() {
        Text(this.getArticleTitle())
          .fontSize(20)
          .margin({ bottom: 8 })
        Text(this.article.brief)
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({ bottom: 8 })
        Row() {
          Image(this.article.isLiked ? $r('app.media.yes') : $r('app.media.no'))
            .width(24)
            .height(24)
            .margin({ right: 8 })
          Text(this.article.likesCount.toString())
            .fontSize(16)
        }
        .onClick(() => this.handleLiked())
        .justifyContent(FlexAlign.Center)
      }
      .alignItems(HorizontalAlign.Start)
      .width('80%')
      .height('100%')
    }
    .padding(20)
    .borderRadius(12)
    .backgroundColor('#FFECECEC')
    .height(120)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(() => {
      Log.log(`card click: ${this.article.title}`)
    })
  }

  private getArticleTitle() {
    Log.log(`List item init: ${this.article.title}`)
    return this.article.title;
  }

  handleLiked(): void {
    this.article.isLiked = !this.article.isLiked;
    if (this.article.isLiked) {
      this.article.likesCount++;
    } else {
      this.article.likesCount--;
    }
  }

  initItem(changedPropertyName: string) {
    Log.log(`item Changed: ${this.article.title}`)
  }
}
