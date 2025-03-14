import { common } from '@kit.AbilityKit';
import { EntryEvent } from '../../../event/EventName';

@Entry
@Component
struct EventPagePage {
  @State message: string = '测试发送消息给Ability'

  // 获取上下文context
  context = getContext(this) as common.UIAbilityContext;

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('EventPagePageHelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          // TODO eventHub Page发送事件给Ability
          this.context.eventHub.emit(EntryEvent.EVENT_CLICK, 'Tom and Jerry from EventPagePage');
        })
    }
    .height('100%')
    .width('100%')
  }
}