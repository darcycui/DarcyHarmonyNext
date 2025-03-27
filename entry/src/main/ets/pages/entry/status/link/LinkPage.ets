class DataLink {
  size: number = -1;
}

@Component
struct ChildLink {
  @Link items: number[];
  @Link data: DataLink;

  build() {
    Column() {
      Text(`子组件 data: ${this.data.size}`)
      Button('子组件点击 data +1').onClick(() => {
        this.data.size += 1;
      })
      Blank().height(1).color(Color.Gray)
      Button(`Child: push`)
        .margin(12)
        .width(312)
        .height(40)
        .fontColor('#FFFFFF，90%')
        .onClick(() => {
          this.items.push(this.items.length + 1);
        })
      Button(`Child: replace whole item`)
        .margin(12)
        .width(312)
        .height(40)
        .fontColor('#FFFFFF，90%')
        .onClick(() => {
          this.items = [100, 200, 300];
        })
    }
  }
}

@Entry
@Component
struct LinkPage {
  @State arr: number[] = [1, 2, 3];
  @State data: DataLink = new DataLink();

  build() {
    Column() {
      Text(`父组件 data: ${this.data.size}`)
      Button('父组件点击 data +100').onClick(() => {
        this.data.size += 100;
      })
      Blank().height(1).color(Color.Gray)
      ChildLink({ items: $arr, data: this.data })
        .margin(12)
      // ForEach 遍历数组 添加组件
      ForEach(this.arr,
        (item: number) => {
          Button(`${item}`)
            .margin(12)
            .width(312)
            .height(40)
            .backgroundColor('#11a2a2a2')
            .fontColor('#e6000000')
        },
        (item: ForEachInterface) => item.toString()
      )
    }
  }
}