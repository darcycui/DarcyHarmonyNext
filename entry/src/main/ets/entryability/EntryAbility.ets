import { AbilityConstant, Want } from '@kit.AbilityKit';
import { PAGE_START } from '../pages/PageName';
import { HiLog } from 'static_common';
import { BaseUIAbility } from '../base/BaseUIAbility';
import { EntryEvent } from '../event/EventName';
import { promptAction } from '@kit.ArkUI';

export default class EntryAbility extends BaseUIAbility {
  getInitPageName(): string {
    return PAGE_START
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onCreate(want, launchParam);
    // 获取want参数
    this.getParams(want);
    this.initEventHub()
  }

  private initEventHub() {
    // 添加事件监听
    this.context.eventHub.on(EntryEvent.EVENT_CLICK, (data: string) => {
      HiLog.warn(this.TAG + 'EVENT_CLICK=' + data)
      promptAction.showToast({
        message: data
      })
    })
  }

  private getParams(want: Want) {
    let name = want.parameters?.["paramsName"];
    let id = want.parameters?.["paramsId"];
    HiLog.debug(this.TAG + 'paramsName=' + name + ' paramsId=' + id);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onNewWant(want, launchParam);
    this.getParams(want);
  }

  onDestroy(): void {
    super.onDestroy();
    // 注销事件监听
    this.context.eventHub.off(EntryEvent.EVENT_CLICK)
  }
}
