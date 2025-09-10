import { JSON } from '@kit.ArkTS';
import { promptAction } from '@kit.ArkUI';

/**
 * @ObjectLink只能接收被@Observed装饰class的实例，
 * 推荐设计单独的自定义组件来渲染每一个数组或对象。此时，对象数组或嵌套对象（属性是对象的对象称为嵌套对象）需要两个自定义组件，
 * 一个自定义组件呈现外部数组/对象，
 * 另一个自定义组件呈现嵌套在数组/对象内的类对象。
 * 可以观察到：
 * 其属性的数值的变化，其中属性是指Object.keys(observedObject)返回的所有属性，示例请参考嵌套对象。
 * 如果数据源是数组，则可以观察到数组item的替换，如果数据源是class，可观察到class的属性的变化，示例请参考对象数组。
 */
@Entry
@Component
struct ObservedClassPage {
  @State parent: ParentObserved = new ParentObserved(200, new ChildObserved(-100));

  build() {
    Column() {
      Text('父组件')
      Text(JSON.stringify(this.parent))
      // 空白间隔
      Blank().height(10)
      Button('直接属性修改').width('100%')
        .onClick(() => {
          this.parent.count += 100;
          this.parent.child = new ChildObserved(this.parent.child.num -100)
        })
      Blank().height(10)
      Button('嵌套属性修改').width('100%')
        .onClick(() => {
          this.parent.child.num -= 100;
        })
      Blank().height(10)
      Button('整个class修改').width('100%')
        .onClick(() => {
          this.parent = new ParentObserved(888, new ChildObserved(-999));
        })
      Blank().height(20)
      Text('子组件')
      ComponentO({ objectLinkParam: this.parent.child })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct ComponentO {
  // 从父组件初始化
  @ObjectLink objectLinkParam: ChildObserved

  build() {
    Column(){
      Text(`ComponentO ${JSON.stringify(this.objectLinkParam)}`)
      Blank().height(10)
      Button('直接属性修改2').width('100%')
        .onClick(() => {
          this.objectLinkParam.num += 100;
        })
      Blank().height(10)
      Button('整个class修改2').width('100%')
        .onClick(() => {
          // 运行报错 子组件中 不允许修改整个class对象
          // this.objectLinkParam = new ParentObserved(222, new ChildObserved(-111));
          promptAction.showToast({message:'不允许子组件 重新赋值ObjectLink'})
        })
    }
  }
}

@Observed
class ChildObserved {
  public num: number;

  constructor(num: number) {
    this.num = num;
  }
}

@Observed
class ParentObserved {
  public count: number;
  public child: ChildObserved;

  constructor(count: number, child: ChildObserved) {
    this.child = child;
    this.count = count;
  }
}