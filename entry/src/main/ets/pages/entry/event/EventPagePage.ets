import { common } from '@kit.AbilityKit';
import { EntryEvent } from '../../../event/EventName';

@Entry
@Component
struct EventPagePage {
  @State message: string = '点击发送消息给Ability'

  // 获取上下文context
  context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Button(this.message).width('100%')
        .onClick(() => {
          // TODO eventHub Page发送事件给Ability
          this.context.eventHub.emit(EntryEvent.EVENT_CLICK, 'Tom and Jerry from EventPagePage');
        })
    }
    .height('100%')
    .width('100%')
  }
}