@Component
struct Child {
  @State label: string = `Child`;

  @Builder
  customBuilder() {
  };

  @Builder
  customChangeThisBuilder() {
  };

  @BuilderParam customBuilderParam: () => void = this.customBuilder;
  @BuilderParam customChangeThisBuilderParam: () => void = this.customChangeThisBuilder;

  build() {
    Column({ space: 10 }) {
      this.customBuilderParam()
      this.customChangeThisBuilderParam()
      Button(`子组件 Click ${this.label}`).onClick(()=>{
        this.label += 'C'
      })
    }.width('100%')
  }
}

@Entry
@Component
struct BuildParamPage {
  @State label: string = `Parent`;

  @Builder
  componentBuilder() {
    Text(`${this.label}`).fontSize(30)
      .onClick(() => {
        this.label += `B`
      })
  }

  build() {
    Column({ space: 10 }) {
      Button(`父组件 Click ${this.label}`).onClick(()=>{
        this.label += 'A'
      })
      // 调用this.componentBuilder()时，this指向当前@Entry所装饰的Parent组件，即label变量的值为"Parent"。
      this.componentBuilder()
      Child({
        // 把this.componentBuilder传给子组件Child，this指向的是子组件Child，即label变量的值为"Child"。
        customBuilderParam: this.componentBuilder, // TODO 点击父组件Button UI不刷新
        // 把():void=>{this.componentBuilder()}传给子组件Child
        // 因为箭头函数的this指向的是宿主对象，所以label变量的值为"Parent"。
        customChangeThisBuilderParam: (): void => {
          this.componentBuilder() // TODO 点击父组件Button UI刷新
        }
      }).width('100%')
    }.width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}