@Builder
export function NavigationBuilder() {
  ProviderFunctionPage()
}

@Entry
@ComponentV2
struct ProviderFunctionPage {
  @Local childX: number = 0;
  @Local childY: number = 1;
  // 可以修饰函数类型 箭头函数
  @Provider('onClicked') onClicked: (x: number, y: number) => void = (x: number, y: number) => {
    console.info(`onDrag event at x=${x} y:${y}`);
    this.childX = x;
    this.childY = y;
  }

  build() {
    NavDestination() {
      Column() {
        Text(`child position \nx: ${this.childX}\ny: ${this.childY}`)
          .width('100%')
          .height(80)
        ProviderFunctionChild()
      }.width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .title('Provider Function')
  }
}

@ComponentV2
struct ProviderFunctionChild {
  // 可以修饰函数类型 箭头函数
  @Consumer('onClicked') onClicked: (x: number, y: number) => void = (x: number, y: number) => {
  };

  build() {
    Column() {
      Button('点击调用回调函数 ').width('100%').height(50)
        .onClick((event: ClickEvent) => {
          // 当前预览器上不支持通用拖拽事件
          this.onClicked(event.displayX, event.displayY);
        })
    }.width('100%').height('100%')
  }
}