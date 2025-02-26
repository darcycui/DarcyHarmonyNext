let count: Record<string, number> = { 'countStorage': 1 };
let storage: LocalStorage = new LocalStorage(count);

@Entry({ storage: storage })
@Component
struct LocalStoragePage5 {
  @LocalStorageLink('countStorage') playCount: number = 0;

  build() {
    Column({space:16}) {
      Row({ space: 10 }) {
        Text('Parent').width(50).height(60).fontSize(12)
        Button(`playCount ${this.playCount} dec by 1`)
          .onClick(() => {
            // 修改父组件中的状态
            this.playCount -= 1;
          })
          .width(250).height(60).fontSize(12)
      }.width(300).height(60)

      Row() {
        Text('LocalStorage').width(50).height(60).fontSize(12)
        Button(`countStorage ${this.playCount} incr by 1`)
          .onClick(() => {
            // 修改storage中的值
            storage.set<number | undefined>('countStorage', Number(storage.get<number>('countStorage')) + 1);
          })
          .width(250).height(60).fontSize(12)
      }.width(300).height(60)
      // 子组件A 子组件B的状态同步
      ChildStorage5({ label: 'ChildA' })
      ChildStorage5({ label: 'ChildB' })

      Text(`playCount in LocalStorage for debug ${storage.get<number>('countStorage')}`)
        .width(300).height(60).fontSize(12)
    }
  }
}

@Component
struct ChildStorage5 {
  // 子组件实例的名字
  label: string = 'no name';
  // 和LocalStorage中“countStorage”的双向绑定数据
  @LocalStorageLink('countStorage') playCountLink: number = 0;

  build() {
    Row() {
      Text(this.label).width(50).height(60).fontSize(12)
      Button(`playCountLink ${this.playCountLink}: inc by 1`)
        .onClick(() => {
          // 修改子组件中的状态
          this.playCountLink += 1;
        })
        .width(200).height(60).fontSize(12)
    }.width(300).height(60)
  }
}