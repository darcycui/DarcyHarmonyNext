import { JSON } from "@kit.ArkTS";

@Builder
export function NavigationBuilder() {
  ObservedV2Page()
}

@ObservedV2
class OuterClass {
  @Trace
  outAge: number
  @Trace
  innerClass: InnerClass

  constructor(outAge: number, innerClass: InnerClass) {
    this.outAge = outAge
    this.innerClass = innerClass
  }
}

@ObservedV2
class InnerClass {
  @Trace
  innerAge: number

  constructor(innerAge: number) {
    this.innerAge = innerAge
  }
}

@Entry
@ComponentV2
struct ObservedV2Page {
  pathStack: NavPathStack = new NavPathStack();
  @Local outClass: OuterClass = new OuterClass(28, new InnerClass(8))

  build() {
    NavDestination() {
      Column() {
        // 不能使用 JSON.stringify()序列化 (序列化的值还是改变之前的值)
        Text(JSON.stringify(this.outClass))
          .textAlign(TextAlign.Start)
          .width('100%')
        // 直接属性 改变
        Text(`OuterAge=${this.outClass.outAge}`)
          .textAlign(TextAlign.Start)
          .width('100%')
        // 嵌套属性 改变
        Text(`InnerAge=${this.outClass.innerClass.innerAge}`)
          .textAlign(TextAlign.Start)
          .width('100%')
        // 间隔5vp
        Blank().height(5)
        Button('更改直接属性 OuterAge')
          .onClick(() => {
            this.outClass.outAge++
          }).width('100%')
        // 间隔5vp
        Blank().height(5)
        Button('更改嵌套属性 InnerAge')
          .onClick(() => {
            this.outClass.innerClass.innerAge++
          }).width('100%')
        // 间隔5vp
        Blank().height(5)
        Button('重新赋值外部类 outClass')
          .onClick(() => {
            this.outClass = new OuterClass(80, new InnerClass(52))
          }).width('100%')
        // 间隔5vp
        Blank().height(5)
        Button('重新赋值嵌套类 innerClass')
          .onClick(() => {
            this.outClass.innerClass = new InnerClass(20)
          }).width('100%')
      }
      .height('100%')
      .width('100%')
    }.title('ObserverV2 Trace')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}