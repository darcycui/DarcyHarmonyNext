import { AbilityConstant, Want } from '@kit.AbilityKit';
import { BaseUIAbility } from 'static_library_common';

export default class LoginAbility extends BaseUIAbility {
  getInitPageName(): string {
    return 'pages/login/LoginIndex'
  }

  getLocalStorage(): LocalStorage | null {
    return null
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onCreate(want, launchParam);
  }
}
