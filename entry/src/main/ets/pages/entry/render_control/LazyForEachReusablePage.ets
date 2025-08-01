/** BasicDataSource代码见文档末尾附件: string类型数组的BasicDataSource代码 **/
import { Log, BasicDataSource } from 'static_library_common';
import { JSON, util } from '@kit.ArkTS';

@Observed
class StringData {
  message: string
  imgSrc: Resource
  private hash: string

  constructor(message: string, imgSrc: Resource = $r('app.media.static_icon')) {
    this.message = message
    this.imgSrc = imgSrc
    // TODO 生成唯一hash 用于List唯一标识
    // this.hash = `@${Math.random().toString(36).substring(2, 10)}`
    // darcyRefactor: 使用UUID生成唯一id
    this.hash = util.generateRandomUUID(true)
  }


  // TODO get方法
  public get hashCode(): string {
    Log.log(`message=${this.message} hashCode=${this.hash}`)
    return this.hash
  }
}

class MyDataSourceLazyReusableClass extends BasicDataSource<StringData> {
  public moveDataWithoutNotify(from: number, to: number) {
    let tmp = this.dataArray.splice(from, 1);
    this.dataArray.splice(to, 0, tmp[0])
  }

  public pushData(data: StringData): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public addDataWithIndex(data: StringData, index: number): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
    this.notifyDataReload()
  }
}

@Entry
@Component
struct LazyForEachClassPage {
  private data: MyDataSourceLazyReusableClass = new MyDataSourceLazyReusableClass();

  aboutToAppear() {
    for (let i = 0; i <= 30; i++) {
      this.data.pushData(new StringData(`Data ${i}`))
    }
  }

  build() {
    Column() {
      List({ space: 10 }) {
        LazyForEach(this.data, (item: StringData, index: number) => {
          ListItem() {
            // 包一层组件
            ChildComponent({ data: item })
          }
        },
          (item: StringData, index: number) => {
            // 不涉及到增加或删除item 使用全局唯一key
            return item.hashCode
          }
        )
      }
      .width('100%')
      .height('auto')
      .cachedCount(1)
      .divider({ strokeWidth: 1, color: Color.Gray })
    }.width('100%')
    .height('100%')
  }
}

@Reusable
@Component
struct ChildComponent {
  // TODO 复用组件的状态属性 需要使用@State修饰
  @State data: StringData = new StringData('')

  aboutToAppear(): void {
    Log.log('aboutToAppear: ' + this.data.message);
  }

  aboutToRecycle(): void {
    Log.log('aboutToRecycle: ' + this.data.message);
  }

  // 对复用的组件进行数据更新
  aboutToReuse(params: Record<string, Object>): void {
    this.data = params.data as StringData;
    Log.log('aboutToReuse: ' + this.data.message);
  }

  build() {
    Column() {
      Row({ space: 10 }) {
        Text(this.data.message).fontSize(50)
      }.margin({ left: 10, right: 10 })
    }
    .width('100%')
    .height('auto')
    .onAppear(() => {
      Log.info("appear:" + this.data.message + " " + this.data.hashCode)
    })
  }
}