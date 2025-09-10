class ReferenceType {
  value: string = '';
}

@Component
struct OtherComponent {
  @Prop message: string;

  build() {
    Row() {
      Text(`HelloComponent===${this.message}`)
    }
  }
}

@Entry
@Component
struct LocalBuilderPage2 {
  @State value: string = 'Hello World';

  // TODO 推荐使用 $$作为参数名
  @LocalBuilder
  citeLocalBuilder($$: ReferenceType) {
    Row() {
      Column({ space: 10 }) {
        Text(`citeLocalBuilder===${$$.value}`)
        // TODO @LocalBuilder引用其他组件并传递参数 其他组件可以刷新
        OtherComponent({ message: $$.value })
      }.width('100%')
    }.width('100%')
  }

  build() {
    Column({ space: 20 }) {
      this.citeLocalBuilder({ value: this.value })
      Button('Click me').width('100%').onClick(() => {
        this.value = 'Hi World';
      })
    }.width('100%')
  }
}