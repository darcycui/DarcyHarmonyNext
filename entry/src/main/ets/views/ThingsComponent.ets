import { Log } from "static_common";
import ThingsViewModel from "../viewmodel/ThingsViewModel";

@Component
export struct ThingsComponent {
  // 在Item组件中 观察Item的ViewModel
  // 1.单向绑定 使用@Prop
  // @Prop @Watch('onItemChanged') things: ThingsViewModel;
  // 2.双向绑定使用@ObjectLink
  @ObjectLink @Watch('onItemChanged') things: ThingsViewModel;
  // 3.不可以使用@Link 因为@Link只能通过状态属性初始化
  // @Link @Watch('onItemChanged') things: ThingsViewModel;

  label: string = 'ViewA1';

  onItemChanged(changedPropertyName: string) {
    Log.log(`onItemChanged: ${this.things.thingsName}`)
  }

  @Builder
  displayIcon(icon: Resource) {
    Image(icon)
      .width(28)
      .height(28)
      .onClick(() => {
        this.things.updateIsFinish();
      })
  }

  build() {
    // 待办事项
    Row({ space: 15 }) {
      if (this.things.isFinish) {
        this.displayIcon($r('app.media.yes'));
      } else {
        this.displayIcon($r('app.media.no'));
      }

      Text(`${this.things.thingsName}`)
        .fontSize(getFontSize())
        .fontWeight(450)
        .decoration({ type: this.things.isFinish ? TextDecorationType.LineThrough : TextDecorationType.None })
        .onClick(() => {
          this.things.addSuffixes();
        })
    }
    .height('8%')
    .width('90%')
    .padding({ left: 15 })
    .opacity(this.things.isFinish ? 0.3 : 1)
    .border({ width: 1 })
    .borderColor(Color.White)
    .borderRadius(25)
    .backgroundColor(Color.White)
  }
}

function getFontSize(): string | number  {
  Log.log(`getFontSize start+++`)
  return 24
}
