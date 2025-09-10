class DataWrap {
  value: string = 'WrapBuilder Test';

  // TODO 通过对象字面量创建的类 不能定义构造函数 不要问为什么
  // constructor(value: string) {
  //   this.value = value;
  // }
}

@Builder
function MyBuilder(data: DataWrap) {
  Text(data.value)
    .fontSize(30)
}

@Builder
function YourBuilder(data: DataWrap) {
  Text(data.value)
    .fontSize(30)
    .fontColor(Color.Pink)
}

// TODO 将多个Builder函数封装成一个数组，并使用ForEach循环遍历数组，依次调用每个Builder函数
const builderArr: WrappedBuilder<[DataWrap]>[] = [wrapBuilder(MyBuilder), wrapBuilder(YourBuilder)];

@Entry
@Component
struct WrapBuilderPage {
  @State data: DataWrap = new DataWrap();

  @Builder
  testBuilder() {
    ForEach(builderArr, (item: WrappedBuilder<[DataWrap]>) => {
      // item.builder(this.data)
      item.builder({ value: this.data.value })
    })
  }

  build() {
    Column({ space: 10 }) {
      this.testBuilder()
      Button('Click to change value').width('100%').onClick(() => {
        this.data.value += 'A'
      })
    }
    .width('100%')
    .height('100%')
  }
}