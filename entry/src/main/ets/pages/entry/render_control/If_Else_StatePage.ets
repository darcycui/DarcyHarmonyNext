@Component
struct CounterView {
  @State counter: number = 0;
  label: string = 'unknown';

  build() {
    Column({ space: 20 }) {
      Text(`${this.label}`)
      Button(`counter ${this.counter} +1`).width('100%')
        .onClick(() => {
          this.counter += 1;
        })
    }
    .margin(10)
    .padding(10)
    .border({ width: 1 })
  }
}

@Entry
@Component
struct If_Else_WithState {
  @State toggle: boolean = true;

  build() {
    Column() {
      if (this.toggle) {
        CounterView({ label: 'CounterView #positive' })
      } else {
        CounterView({ label: 'CounterView #negative' })
      }
      Button(`toggle ${this.toggle}`).width('100%')
        .onClick(() => {
          this.toggle = !this.toggle;
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}