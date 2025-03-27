@Component
struct ChildPage {
  label: string = `Child   Page`;
  @Builder customBuilder() {};
  @BuilderParam customBuilderParam: () => void = this.customBuilder;
  @BuilderParam customChangeThisBuilderParam: () => void = this.customBuilder;

  build() {
    Column() {
      this.customBuilderParam()
      this.customChangeThisBuilderParam()
    }
  }
}

const builder_value: string = 'Hello World';
@Builder function overBuilder2() {
  Row() {
    Text(`全局 Builder: ${builder_value}`)
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
  }
}

@Entry
@Component
struct BuilderParamPage3 {
  label: string = `Parent Page`;

  @Builder componentBuilder() {
    Row(){
      Text(`局部 Builder: ${this.label}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
  }

  build() {
    Column() {
      // 调用this.componentBuilder()时，this指向当前@Entry所装饰的ParentPage组件，所以label变量的值为"Parent Page"。
      this.componentBuilder()
      ChildPage({
        // 把this.componentBuilder传给子组件ChildPage的@BuilderParam customBuilderParam，this指向的是子组件ChildPage，所以label变量的值为"Child Page"。
        customBuilderParam: this.componentBuilder,
        // 把():void=>{this.componentBuilder()}传给子组件ChildPage的@BuilderParam customChangeThisBuilderParam，
        // 因为箭头函数的this指向的是宿主对象，所以label变量的值为"Parent Page"。
        customChangeThisBuilderParam: (): void => { this.componentBuilder() }
      })
      Line()
        .width('100%')
        .height(1)
        .backgroundColor(Color.Black).margin(10)
      // 调用全局overBuilder()时，this指向当前整个活动页，所以展示的内容为"Hello World"。
      overBuilder2()
      ChildPage({
        // 把全局overBuilder传给子组件ChildPage的@BuilderParam customBuilderParam，this指向当前整个活动页，所以展示的内容为"Hello World"。
        customBuilderParam: overBuilder2,
        // 把全局overBuilder传给子组件ChildPage的@BuilderParam customChangeThisBuilderParam，this指向当前整个活动页，所以展示的内容为"Hello World"。
        customChangeThisBuilderParam: overBuilder2
      })
    }
  }
}