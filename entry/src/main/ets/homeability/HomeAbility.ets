import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { PAGE_COLUMN } from '../pages/PageName';

const TAG: string = '[HomeAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

export default class HomeAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.debug(DOMAIN_NUMBER, TAG, 'windowStage Create.');
    hilog.info(0x0000, TAG , 'Ability onCreate');
    // 获取want参数
    let name = want.parameters?.["paramsName"];
    let id = want.parameters?.["paramsId"];
    hilog.debug(DOMAIN_NUMBER, TAG, 'paramsName=' + name + ' paramsId=' + id);
    // 遍历want.parameters，获取参数
    Object.keys(want.parameters ?? {}).forEach(key => {
      hilog.info(DOMAIN_NUMBER, TAG, 'key=' + key + ' value=' + want.parameters?.[key]);
    })
  }

  onDestroy(): void {
    hilog.info(0x0000, TAG , 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, TAG , 'Ability onWindowStageCreate');

    windowStage.loadContent(PAGE_COLUMN, (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
    // 生命周期
    windowStage.on('windowStageEvent', (data) => {
      let stageEventType: window.WindowStageEventType = data;
      switch (stageEventType) {
        case window.WindowStageEventType.SHOWN: // 切到前台
          hilog.info(DOMAIN_NUMBER, TAG, 'windowStage foreground.');
          break;
        case window.WindowStageEventType.ACTIVE: // 获焦状态
          hilog.info(DOMAIN_NUMBER, TAG, 'windowStage active.');
          break;
        case window.WindowStageEventType.INACTIVE: // 失焦状态
          hilog.info(DOMAIN_NUMBER, TAG, 'windowStage inactive.');
          break;
        case window.WindowStageEventType.HIDDEN: // 切到后台
          hilog.info(DOMAIN_NUMBER, TAG, 'windowStage background.');
          break;
        default:
          break;
      }
    });
  }

  onWindowStageDestroy(): void {
    hilog.error(DOMAIN_NUMBER, TAG, 'windowStage Destroy.');
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, TAG , 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, TAG , 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, TAG , 'Ability onBackground');
  }
}
