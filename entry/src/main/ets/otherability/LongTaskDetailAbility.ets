import { BaseUIAbility } from '../base/BaseUIAbility';
import { PAGE_LONG_TASK_DETAIL } from '../pages/PageName';

export default class LongTaskDetailAbility extends BaseUIAbility {
  getInitPageName(): string {
    return PAGE_LONG_TASK_DETAIL
  }

  getLocalStorage(): LocalStorage | null {
    return null
  }
}
