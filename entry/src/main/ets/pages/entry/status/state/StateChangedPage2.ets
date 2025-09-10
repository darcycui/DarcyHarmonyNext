@Entry
@Component
struct StateChangedPage2 {
  @State son: Son2 = new Son2('222');
  @State parent: Parent2 = new Parent2();

  aboutToAppear(): void {
    this.parent.son = this.son;
  }

  build() {
    Column() {
      Text(`${this.son.value}`); //text1
      Text(`${this.parent.son.value}`); //text2
      Button('change')
        .width('100%').onClick(() => {
          // son的直接属性改变-->text1改变
          // parent的嵌套属性改变 无法观察-->text2不变
          this.parent.son.value = '333';
        })
    }
  }
}

class Son2 {
  value: string = '000';

  constructor(son: string) {
    this.value = son;
  }
}
class Parent2 {
  son: Son2 = new Son2('111');
}