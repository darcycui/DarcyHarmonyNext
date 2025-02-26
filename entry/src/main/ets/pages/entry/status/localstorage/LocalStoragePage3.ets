let localStorage1: LocalStorage = new LocalStorage();
localStorage1.setOrCreate('PropA', 'PropA');

let localStorage2: LocalStorage = new LocalStorage();
localStorage2.setOrCreate('PropB', 'PropB');

// 父组件传递LocalStorage给子组件
@Entry(localStorage1)
@Component
struct LocalStoragePage3 {
  // 'PropA'，和localStorage1中'PropA'的双向同步
  @LocalStorageLink('PropA') PropA: string = 'Hello World';
  @State count: number = 100;

  build() {
    Row() {
      Column({space: 10}) {
        Text('父组件使用LocalStorage')
        Text(this.PropA)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Text('子组件使用同一个LocalStorage')
        // 子组件使用同一个LocalStorage
        ChildLocal3()
        Blank().height(10)
        Text('子组件使用另一个LocalStorage')
        // 子组件使用另一个LocalStorage 实例localStorage2
        ChildLocal3({}, localStorage2)
      }.alignItems(HorizontalAlign.Start)
      .width('100%')
    }
    .height('100%')
  }
}

@Component
struct ChildLocal3 {
  @State count: number = 1;
  //  propB 和localStorage2中'PropB'的双向同步，如果localStorage2中没有'PropB'，则使用默认值
  @LocalStorageLink('PropB') propB: string = 'default value propB';

  build() {
    Text(this.propB)
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
  }
}