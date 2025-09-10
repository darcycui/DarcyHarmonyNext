@Component
struct CustomContainer {
  @Prop header: string = '';

  @Builder
  closerBuilder() {
  };

  // 使用父组件的尾随闭包{}(@Builder装饰的方法)初始化子组件@BuilderParam
  @BuilderParam closer: () => void = this.closerBuilder;

  build() {
    Column() {
      Text(this.header).fontSize(30)
      this.closer()
    }
  }
}

@Builder
function specificParam(label1: string, label2: string) {
  Column({ space: 10 }) {
    Text(label1).fontSize(30)
    Text(label2).fontSize(30)
  }.margin(10)
  .width('100%')
}

@Entry
@Component
struct BuilderParamPage2 {
  @State text: string = 'header';

  build() {
    Column() {
      // TODO 闭包传递参数给子组件
      CustomContainer({ header: this.text }) {
        Column() {
          specificParam('testA', 'testB')
          Button('Change Header').width('100%').onClick(() => {
            this.text = 'changed header';
          }).margin({ bottom: 10 })
        }.backgroundColor(Color.Yellow)
        .width('100%')
      }
    }
  }
}