import { router } from '@kit.ArkUI';
import { Log } from 'static_library_common';
import { common, Want } from '@kit.AbilityKit';
import { JSON } from '@kit.ArkTS';

export function startPage(url: string, params?: Record<string, string>) {
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

export function startNamedPage(url: string, params?: Record<string, string>) {
  router.pushNamedRoute({
    name: url,
    params: params
  }).then(() => {
    Log.log("Succeed to start named page: " + url);
  }).catch((err: Error) => {
    Log.error("Failed to start named page: " + url);
    Log.error(`error:${err.name} ${err.message}`)
  });
}

export function startAbility(
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