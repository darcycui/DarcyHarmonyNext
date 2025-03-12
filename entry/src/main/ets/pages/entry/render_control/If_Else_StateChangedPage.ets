import { curves } from '@kit.ArkUI';

class MyData {
  str: string;

  constructor(str: string) {
    this.str = str;
  }
}

@Entry
@Component
struct If_Else_WithStateChanged {
  @State data1: MyData | undefined = new MyData("branch 0");
  @State data2: MyData | undefined = new MyData("branch 1");
  @State animate: boolean = false;
  // 第一步: 声明相关状态变量
  @State rotateValue: number = 0; // 组件一旋转角度

  build() {
    Column() {
      if (this.data1) {
        // 如果在动画中增加/删除，会给Text增加默认转场
        // 对于删除时，增加默认透明度转场后，会延长组件的生命周期，Text组件没有真正删除，而是等转场动画做完后才删除
        Text(this.data1.str).fontColor(Color.Green).id("1")
      } else if (this.data2) {
        // 如果在动画中增加/删除，会给Text增加默认转场
        Text(this.data2.str).fontColor(Color.Red).id("2")
      }

      Button("play with animation")
        .rotate({ angle: this.rotateValue }) // 添加旋转动画
        .onClick(() => {
          animateTo({
            // 设置动画曲线
            curve: curves.springMotion()
          }, () => {
            // 改变属性对应的状态变量
            this.animate = !this.animate;
            this.rotateValue = this.animate ? 90 : 0;
            // 在animateTo中修改if条件，在动画当中，会给if下的第一层组件默认转场
            // if (this.data1) {
            //   this.data1 = undefined;
            //   this.data2 = new MyData("branch 1");
            // } else {
            //   this.data1 = new MyData("branch 0");
            //   this.data2 = undefined;
            // }
          })
        })

      Button("play directly")
        .onClick(() => {
          // 直接改if条件，不在动画当中，可以正常切换，也不会加默认转场
          if (this.data1) {
            this.data1 = undefined;
            this.data2 = new MyData("branch 1");
          } else {
            this.data1 = new MyData("branch 0");
            this.data2 = undefined;
          }
        })
    }.width("100%")
    .padding(10)
  }
}