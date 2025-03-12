import { Log } from 'static_common';
import { JSON } from '@kit.ArkTS';

@Entry
@Component
struct ForEachPage {
  @State simpleList: Array<string> = ['one', 'two', 'two', 'three'];

  build() {
    Row() {
      Column({ space: 10 }) {
        ForEach(this.simpleList,
          // 生成子组件
          (item: string) => {
            ChildItem({ item: item })
          },
          // 生成key
          (item: string, index: number) => {
            // return item // TODO:使用item作为key 第二个two不显示 因为key相同
            return index.toString() // TODO 使用index作为key 无法修改item内容 因为key已经存在且未发生变化
          })
        Text('修改第1个数组项的值')
          .fontSize(24)
          .fontColor(Color.Red)
          .onClick(() => {
            this.simpleList[0] = 'new one';
            Log.log(`simpleList=${JSON.stringify(this.simpleList)}`)
          })
        Text('修改重复数组项two的值')
          .fontSize(24)
          .fontColor(Color.Orange)
          .onClick(() => {
            this.simpleList[2] = 'repeat two';
            Log.log(`simpleList=${JSON.stringify(this.simpleList)}`)
          })
        Button() {
          Text('在第1项后插入新项').fontSize(30).padding(16)
        }
        .onClick(() => {
          this.simpleList.splice(1, 0, 'new item');
          Log.log(`simpleList=${JSON.stringify(this.simpleList)}`)
        })
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
    .backgroundColor(0xF1F3F5)
  }
}

@Component
struct ChildItem {
  @Prop item: string;

  build() {
    Text(this.item).fontSize(50)
  }
}