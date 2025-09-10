@Entry
@Component
struct StateChangedPage3 {
  @State son: Son3 = new Son3('333');
  @State parent: Parent3 = new Parent3();

  aboutToAppear(): void {
    this.parent.son = this.son;
  }

  build() {
    Column() {
      Text(`${this.son.value}`); //text1
      Text(`${this.parent.son.value}`); //text2
      Button('change')
        .width('100%').onClick(() => {
          // parent的直接属性改变-->text2改变
          this.parent.son = new Son3('444');
          // 这里改变的是444 不是son-->text1不变
          this.parent.son.value = '555';
        })
    }
  }
}

class Son3 {
  value: string = '000';

  constructor(son: string) {
    this.value = son;
  }
}
class Parent3 {
  son: Son3 = new Son3('111');
}