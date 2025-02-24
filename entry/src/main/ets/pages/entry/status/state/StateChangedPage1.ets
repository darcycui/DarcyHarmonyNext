@Entry
@Component
struct StateChangedPage1 {
  @State son: string = '111';
  @State parent: Parent = new Parent();

  aboutToAppear(): void {
    this.parent.son = this.son;
  }

  build() {
    Column() {
      Text(`${this.son}`); //text1
      Text(`${this.parent.son}`); //text2
      Button('change')
        .onClick(() => {
          this.parent.son = '222'; // text2改变 text1不变
        })
    }
  }
}
class Parent {
  son: string = '000';
}