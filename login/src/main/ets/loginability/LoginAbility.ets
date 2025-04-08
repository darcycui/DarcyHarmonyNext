import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { InitCommon } from 'static_library_common';
import { AppInfo } from '../utils/AppInfo';
import BuildProfile from 'BuildProfile';

const TAG: string = '[LoginAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

export default class LoginAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.debug(DOMAIN_NUMBER, TAG, 'windowStage Create.');
    hilog.info(0x0000, TAG, 'Ability onCreate');
    initLibraryCommon()
  }

  onDestroy(): void {
    hilog.info(0x0000, TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, TAG, 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/login/LoginIndex', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });

    // WindowStage事件
    windowStage.on('windowStageEvent', (data) => {
      let stageEventType: window.WindowStageEventType = data;
      switch (stageEventType) {
        case window.WindowStageEventType.SHOWN: // 切到前台
          hilog.info(DOMAIN_NUMBER, TAG, 'windowStage SHOWN.');
          break;
        case window.WindowStageEventType.ACTIVE: // 获焦状态
          hilog.info(DOMAIN_NUMBER, TAG, 'windowStage ACTIVE.');
          break;
        case window.WindowStageEventType.INACTIVE: // 失焦状态
          hilog.info(DOMAIN_NUMBER, TAG, 'windowStage INACTIVE.');
          break;
        case window.WindowStageEventType.HIDDEN: // 切到后台
          hilog.info(DOMAIN_NUMBER, TAG, 'windowStage HIDDEN.');
          break;
        default:
          break;
      }
    });
  }

  onWindowStageDestroy(): void {
    hilog.error(DOMAIN_NUMBER, TAG, 'windowStage Destroy.');
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, TAG, 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, TAG, 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, TAG, 'Ability onBackground');
  }
}

/**
 * 初始化静态库
 */
function initLibraryCommon() {
  // InitCommon.init(BuildProfile.DEBUG)
  InitCommon.init(AppInfo.isDebug())
}
