import { AbilityConstant, Want } from '@kit.AbilityKit';
import { PAGE_COLUMN } from '../pages/PageName';
import { HiLog, BaseUIAbility } from 'static_library_common';

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
    HiLog.debug(TAG + 'paramsName=' + name + ' paramsId=' + id);
    // 遍历want.parameters，获取参数
    Object.keys(want.parameters ?? {}).forEach(key => {
      HiLog.info(TAG + 'key=' + key + ' value=' + want.parameters?.[key]);
    })
  }
}
