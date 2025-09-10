/** BasicDataSource代码见文档末尾附件: string类型数组的BasicDataSource代码 **/
import { Log, BasicDataSource } from 'static_library_common';

class MyDataSourceLazy extends BasicDataSource<string> {
  public pushData(data: string): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
  }

  public changeData(index: number, suffix: string): void {
    this.dataArray[index]= `${this.dataArray[index]}${suffix}`;
    this.notifyDataChange(index);
  }
}

@Entry
@Component
struct LazyForEachPage {
  private data: MyDataSourceLazy = new MyDataSourceLazy();

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      this.data.pushData(`Hello ${i}`)
    }
  }

  build() {
    Column() {
      Row({ space: 10 }) {
        Button('增加').width('100%').onClick(() => {
          // 点击追加
          this.data.pushData(`New ${this.data.totalCount()}`);
        })
        Button('删除').width('100%').onClick(() => {
          // 点击删除
          this.data.deleteData(0);
        })
        Button('修改').width('100%').onClick(() => {
          // 点击删除
          this.data.changeData(0, 'A');
        })
      }

      List({ space: 10 }) {
        LazyForEach(this.data, (item: string) => {
          ListItem() {
            Row() {
              Text(item).fontSize(50)
                .onAppear(() => {
                  Log.info("appear:" + item)
                })
            }.margin({ left: 10, right: 10 })
          }
        }, (item: string) => item)
      }.width('100%')
      .height('auto')
      .cachedCount(1)
      .divider({ strokeWidth: 1, color: Color.Gray })
    }.width('100%')
    .height('100%')
  }
}