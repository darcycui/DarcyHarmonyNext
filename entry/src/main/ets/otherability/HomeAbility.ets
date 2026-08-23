import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { PAGE_COLUMN } from '../pages/PageName';
import { BaseUIAbility } from '../base/BaseUIAbility';

const TAG: string = '[HomeAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

export default class HomeAbility extends BaseUIAbility {
  getInitPageName(): string {
    return PAGE_COLUMN
  }

  getLocalStorage(): LocalStorage | null {
    return null
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onCreate(want, launchParam)
    // 获取want参数
    let name = want.parameters?.["paramsName"];
    let id = want.parameters?.["paramsId"];
    hilog.debug(DOMAIN_NUMBER, TAG, 'paramsName=' + name + ' paramsId=' + id);
    // 遍历want.parameters，获取参数
    Object.keys(want.parameters ?? {}).forEach(key => {
      hilog.info(DOMAIN_NUMBER, TAG, 'key=' + key + ' value=' + want.parameters?.[key]);
    })
  }
}
