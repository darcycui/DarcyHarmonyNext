import { curves } from '@kit.ArkUI';

@Entry
@Component
struct AnimateToDemo {
  @State animate: boolean = false;
  // 第一步: 声明相关状态变量
  @State rotateValue: number = 0; // 组件一旋转角度
  @State translateX: number = 0; // 组件二偏移量
  @State opacityValue: number = 1; // 组件二透明度

  // 第二步：将状态变量设置到相关可动画属性接口
  build() {
    Row() {
      // 组件一
      Column() {
      }
      .rotate({ angle: this.rotateValue }) // 添加旋转动画
      .backgroundColor('#317AF7')
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .borderRadius(30)
      .onClick(() => {
        // TODO 先获取context 再调用animateTo
        this.getUIContext()?.animateTo({
          // 设置动画曲线
          curve: curves.springMotion()
        }, () => {
          this.animate = !this.animate;
          // 第三步：闭包内通过状态变量改变UI界面
          // 这里可以写任何能改变UI的逻辑比如数组添加，显隐控制，系统会检测改变后的UI界面与之前的UI界面的差异，对有差异的部分添加动画
          // 组件一的rotate属性发生变化
          this.rotateValue = this.animate ? 90 : 0;
          // 组件二的透明度发生变化
          this.opacityValue = this.animate ? 0.6 : 1;
          // 组件二的translate属性发生变化
          this.translateX = this.animate ? 50 : 0;
        })
      })

      // 组件二
      Column() {

      }
      .justifyContent(FlexAlign.Center)
      .width(100)
      .height(100)
      .backgroundColor('#D94838')
      .borderRadius(30)
      .opacity(this.opacityValue) // 添加透明度动画
      .translate({ x: this.translateX }) // 添加偏移动画
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}