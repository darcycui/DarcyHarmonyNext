@Entry
@Component
struct StateChangedPage1 {
  @State son: string = '111';
  @State parent: ParentClass = new ParentClass();

  aboutToAppear(): void {
    this.parent.son = this.son;
  }

  build() {
    Column({ space: 10 }) {
      Text(`son=${this.son}`); //text1
      Text(`parent.son=${this.parent.son}`); //text2
      Button('修改 son')
        .width('100%').onClick(() => {
        this.son = '333'; // text1改变 text2不变
      })
      Button('修改 parent.son')
        .width('100%').onClick(() => {
        this.parent.son = '222'; // text2改变 text1不变
      })
    }
  }
}

class ParentClass {
  son: string = '000';
}