let count: Record<string, number> = { 'countStorage': 1 };
let localStorage5: LocalStorage = new LocalStorage(count);

@Entry({ storage: localStorage5 })
@Component
struct LocalStoragePage5 {
  @LocalStorageLink('countStorage') playCount: number = 0;

  build() {
    Column({ space: 16 }) {
      Text('Parent')
      Button(`playCount ${this.playCount} dec by 1`)
        .onClick(() => {
          // 修改父组件中的状态
          this.playCount -= 1;
        })

      Text('LocalStorage')
      Button(`countStorage ${this.playCount} incr by 1`)
        .onClick(() => {
          // 修改storage中的值
          localStorage5.set<number | undefined>('countStorage', Number(localStorage5.get<number>('countStorage')) + 1);
        })
      // 子组件A 子组件B的状态同步
      ChildStorage5({ label: 'ChildA' })
      ChildStorage5({ label: 'ChildB' })

      Text(`playCount in LocalStorage for debug ${localStorage5.get<number>('countStorage')}`)
    }.width('100%')
    .height('100%')
  }
}

@Component
struct ChildStorage5 {
  // 子组件实例的名字
  label: string = 'no name';
  // 和LocalStorage中“countStorage”的双向绑定数据
  @LocalStorageLink('countStorage') playCountLink: number = 0;

  build() {
    Column({ space: 10 }) {
      Text(this.label)
      Button(`playCountLink ${this.playCountLink}: inc by 1`)
        .onClick(() => {
          // 修改子组件中的状态
          this.playCountLink += 1;
        })
    }.width('100%')
  }
}