import { router } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { Log } from './Log';

export class RouterHelper {
  static startPage(url: string, params?: Record<string, string>) {
    router.pushUrl({
      url,
      params
    }).then(() => {
      Log.log("Succeed to start page: " + url);
    }).catch((err: Error) => {
      Log.error("Failed to start page: " + url);
      Log.error(`error:${err.name} ${err.message}`)
    });
  }

  static startNamedPage(url: string, params?: Record<string, string>) {
    router.pushNamedRoute({
      name: url,
      params: params
    }).then(() => {
      Log.log("Succeed to start page: " + url);
    }).catch((err: Error) => {
      Log.error("Failed to start page: " + url);
    });
  }

  static startAbility(
    context: common.UIAbilityContext,
    abilityName: string,
    parameters: Record<string, string | number>) {
    let want: Want = {
      deviceId: "", // TODO deviceId为空表示当前设备
      bundleName: context.abilityInfo.bundleName,
      abilityName: abilityName,
      parameters: parameters
    };
    context.startAbility(want).then(() => {
      Log.log("Succeed to start ability: " + want.abilityName);
    }).catch((err: Error) => {
      Log.error(`Failed to start ability: ${want.abilityName} err:${err.message}`);
    });
  }
}
