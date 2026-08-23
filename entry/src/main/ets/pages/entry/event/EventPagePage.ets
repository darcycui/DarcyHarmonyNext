import { common } from '@kit.AbilityKit';
import { Log } from 'static_library_common';
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

  pageName = "EventPage"

  // 生命周期方法
  onPageShow(): void {
    Log.debug(`-->${this.pageName} onPageShow`)
  }

  onPageHide(): void {
    Log.warn(`-->${this.pageName} onPageHide`)
  }

  onBackPress(): boolean | void {
    Log.log(`-->${this.pageName} onBackPress`)
  }

  aboutToAppear(): void {
    Log.log(`-->${this.pageName} aboutToAppear`)
  }

  aboutToDisappear(): void {
    Log.error(`-->${this.pageName} aboutToDisappear`)
  }

  onDidBuild(): void {
    Log.log(`-->${this.pageName} onDidBuild`)
  }
}