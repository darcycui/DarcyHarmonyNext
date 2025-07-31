import { router } from '@kit.ArkUI';
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
      Log.log("Succeed to start named page: " + url);
    }).catch((err: Error) => {
      Log.error("Failed to start named page: " + url);
      Log.error(`error:${err.name} ${err.message}`)
    });
  }
}
