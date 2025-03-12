/** BasicDataSource代码见文档末尾附件: string类型数组的BasicDataSource代码 **/
import { Log } from 'static_common';
import { BasicDataSource } from './datasource/DataSources';
import { JSON } from '@kit.ArkTS';

@Observed
class StringData {
  message: string
  imgSrc: Resource
  private hash: string

  constructor(message: string, imgSrc: Resource = $r('app.media.static_icon')) {
    this.message = message
    this.imgSrc = imgSrc
    // TODO 生成唯一hash 用于List唯一标识
    this.hash = `@${Math.random().toString(36).substring(2, 10)}`
  }

  // TODO get方法
  public get hashCode(): string {
    Log.log(`message=${this.message} hashCode=${this.hash}`)
    return this.hash
  }
}

class MyDataSourceLazyClass extends BasicDataSource<StringData> {
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

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
    this.notifyDataReload()
  }

  public changeData(index: number, suffix: string): void {
    this.dataArray[index].message = `${this.dataArray[index].message}${suffix}`;
    this.notifyDataChange(index);
  }

  public modifyAllData(): void {
    this.dataArray = this.dataArray.map((item: StringData) => {
      return new StringData(item.message + '0');
    })
    this.notifyDataReload()
  }

  public operateData(): void {
    const totalCount = this.dataArray.length;
    const batch = 5;
    for (let i = totalCount; i < totalCount + batch; i++) {
      this.dataArray.push(new StringData(`Hello ${i}`))
    }
    // this.notifyDataReload();
    // 使用精准刷新 替换 notifyDataReload
    this.notifyDatasetChange([{ type: DataOperationType.ADD, index: totalCount - 1, count: batch }])
  }

  public reloadData() {
    this.notifyDataReload()
  }
}

@Entry
@Component
struct LazyForEachClassPage {
  private data: MyDataSourceLazyClass = new MyDataSourceLazyClass();

  aboutToAppear() {
    // 模拟重复数据
    this.data.pushData(new StringData(`Data 0`))
    for (let i = 0; i <= 10; i++) {
      this.data.pushData(new StringData(`Data ${i}`))
    }
  }

  build() {
    Column() {
      Row({ space: 10 }) {
        Button('头部增加').onClick(() => {
          this.data.addDataWithIndex(new StringData(`New Head ${this.data.totalCount()}`), 0);
        })
        Button('尾部增加').onClick(() => {
          this.data.pushData(new StringData(`New Tail ${this.data.totalCount()}`));
        })
        Button('其他增加').onClick(() => {
          this.data.addDataWithIndex(new StringData(`New ${this.data.totalCount()}`), 1);
        })
      }
      .alignSelf(ItemAlign.Start)
      .alignItems(VerticalAlign.Top)
      .height('auto')

      Row({ space: 10 }) {
        Button('头部删除').onClick(() => {
          this.data.deleteData(0);
        })
        Button('尾部删除').onClick(() => {
          this.data.deleteData(this.data.totalCount() - 1);
        })
        Button('其他删除').onClick(() => {
          this.data.deleteData(1);
        })
      }.margin({ top: 5 })
      .alignSelf(ItemAlign.Start)
      .alignItems(VerticalAlign.Top)
      .height('auto')

      Row({ space: 10 }) {
        Button('修改单个').onClick(() => {
          this.data.changeData(0, 'A');
        })
        Button('修改全部').onClick(() => {
          this.data.modifyAllData();
        })
      }.margin({ top: 5 })
      .alignSelf(ItemAlign.Start)
      .alignItems(VerticalAlign.Top)
      .height('auto')

      List({ space: 10 }) {
        LazyForEach(this.data, (item: StringData, index: number) => {
          ListItem() {
            // 包一层组件
            ChildComponent({ data: item })
          }.onClick(() => {
            Log.log(`click item=${item.hashCode} index=${index}`)
            this.data.deleteData(index)
          })
          // ListItem显示时触发
          .onAppear(() => {
            console.info("ListItem appear:" + item.message + " " + item.hashCode)
          })
        },
          (item: StringData, index: number) => {
            // 不涉及到增加或删除item 使用全局唯一key
            // return item.hashCode
            // TODO 增加或删除item(index会改变)时 需要index作为key的一部分 触发后边item的index改变 (否则index错乱)
            return item.hashCode + `_${index}`
          }
        )// 拖动排序
          .onMove((from: number, to: number) => {
            Log.log(`from=${from},to=${to}`)
            this.data.moveDataWithoutNotify(from, to);
          })
      }
      .width('100%')
      .height('auto')
      .cachedCount(1)
      .divider({ strokeWidth: 1, color: Color.Gray })
      .onScrollIndex((start, end, center) => {
        Log.log(`start=${start},end=${end},center=${center}`)
        if (end === this.data.totalCount() - 1) {
          Log.log('scroll to end')
          this.data.operateData();
        }
      })
    }.width('100%')
    .height('100%')
  }
}

@Component
struct ChildComponent {
  @ObjectLink data: StringData

  build() {
    Column() {
      Row({ space: 10 }) {
        Text(this.data.message).fontSize(50)
          // Text组件显示时触发
          .onAppear(() => {
            Log.info("Text appear:" + this.data.message + " " + this.data.hashCode)
          })
        Button('Append').onClick(() => {
          this.data.message += 'B'
        })
      }.margin({ left: 10, right: 10 })

      Image(this.data.imgSrc)
        .width(500)
        .height(200)
    }
    .width('100%')
    .height('auto')
    // item组件显示时触发
    .onAppear(() => {
      Log.info("Column appear:" + this.data.message + " " + this.data.hashCode)
    })
  }
}