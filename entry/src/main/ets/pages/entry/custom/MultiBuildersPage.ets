class Tmp {
  paramA1: string = '';
}

@Builder
function parentBuilder($$: Tmp) {
  Row() {
    Column({ space: 10 }) {
      Text(`parentBuilder:${$$.paramA1}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      // 引用传递 对象字面量
      HelloComponent({ message: $$.paramA1 })
      Blank().height(1).backgroundColor(Color.Black)
      // 引用传递 对象字面量
      childBuilder({ paramA1: $$.paramA1 })
    }.alignItems(HorizontalAlign.Center)
    .width('100%')
  }
}

@Component
struct HelloComponent {
  @Prop message: string = '';

  build() {
    Row() {
      Text(`Component:${this.message}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
  }
}

@Builder
function childBuilder($$: Tmp) {
  Row() {
    Column({ space: 10 }) {
      Text(`childBuilder:${$$.paramA1}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      HelloChildComponent({ message: $$.paramA1 })
      Blank().height(1).backgroundColor(Color.Black)
      grandsonBuilder({ paramA1: $$.paramA1 })
    }.width('100%')
  }
}

@Component
struct HelloChildComponent {
  @Prop message: string = '';

  build() {
    Row() {
      Text(`ChildComponent:${this.message}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
  }
}

@Builder
function grandsonBuilder($$: Tmp) {
  Row() {
    Column({ space: 10 }) {
      Text(`grandsonBuilder:${$$.paramA1}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      HelloGrandsonComponent({ message: $$.paramA1 })
      Blank().height(1).backgroundColor(Color.Black)
    }.width('100%')
  }
}

@Component
struct HelloGrandsonComponent {
  @Prop message: string;

  build() {
    Row() {
      Text(`GrandsonComponent:${this.message}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
  }
}

@Entry
@Component
struct MultiBuildersPage {
  @State label: string = 'Hello';

  build() {
    Column({ space: 10 }) {
      // 引用传递 对象字面量
      parentBuilder({ paramA1: this.label })
      Button('Click me').onClick(() => {
        this.label = 'ArkUI';
      })
    }
  }
}