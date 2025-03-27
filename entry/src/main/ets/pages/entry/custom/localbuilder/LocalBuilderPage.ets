class ReferenceTypeMessage {
  value: string = ''
}

class ReferenceTypeCount {
  count: number = -1
}

@Entry
@Component
struct LocalBuilderPage {
  @State message: string = 'Hello';
  @State count: number = 100

  // 只能在组件内定义@LocalBuilder函数
  @LocalBuilder
  messageLocalBuilder($$: ReferenceTypeMessage) {
    Row() {
      Text(`引用传递参数: ${$$.value}`)
    }
  };

  @LocalBuilder
  messageLocalBuilder2($$: string) {
    Row() {
      Text(`值传递参数: ${$$}`)
    }
  };

  // 只能在组件内定义@LocalBuilder函数
  @LocalBuilder
  countLocalBuilder($$: ReferenceTypeCount) {
    Row() {
      Text(`引用传递参数: ${$$.count}`)
    }
  };

  build() {
    Column({ space: 10 }) {
      this.messageLocalBuilder({ value: this.message })
      this.messageLocalBuilder2(this.message) // 值传递 UI不刷新
      this.countLocalBuilder({ count: this.count })
      // 这里点击事件的处理 封装到handleClick函数中
      Button('Click me =>').onClick(() => this.handleClick())
    }.width('100%')
  }

  handleClick() {
    this.message += ' World';
    this.count += 100
  }
}