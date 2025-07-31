import { common, Want } from "@kit.AbilityKit";
import { Log } from "./Log";

export class AbilityHelper {
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
