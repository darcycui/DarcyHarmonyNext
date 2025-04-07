import { BaseUIAbility } from '../base/BaseUIAbility';
import { PAGE_LONG_TASK } from '../pages/PageName';

export default class LongTaskAbility extends BaseUIAbility {
  getInitPageName(): string {
    return PAGE_LONG_TASK
  }

  getLocalStorage(): LocalStorage | null {
    return null
  }

}
