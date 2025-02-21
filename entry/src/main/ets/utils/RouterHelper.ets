import { router } from '@kit.ArkUI';
import { Log } from 'static_common';

export function startPage(url: string, params: Record<string, string>) {
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

export function startNamedPage(url: string, params: Record<string, string>) {
  router.pushNamedRoute({
    name: url,
    params: params
  }).then(() => {
    Log.log("Succeed to start page: " + url);
  }).catch((err: Error) => {
    Log.error("Failed to start page: " + url);
  });
}