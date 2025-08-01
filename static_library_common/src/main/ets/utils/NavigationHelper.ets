import { Log } from './Log';
import { BusinessError } from '@kit.BasicServicesKit';
export class NavigationHelper {
  static startPage(pathStack: NavPathStack, url: string, params?: Record<string, string>,
    replace: boolean = false,
    single: boolean = false) {
    pathStack.pushDestination({ name: url, param: params })
      .then(() => {
        Log.log("Succeed to start page: " + url);
      }).catch((err: BusinessError) => {
      Log.error(`Failed to start page: ${url} ERROR:${err.code} ${err.message}`);
    });
  }

  static back(pathStack: NavPathStack, url?: string, params?: Record<string, string>, index: number = -1) {
    if (index != -1) {
      pathStack.popToIndex(index)
    } else if (url != null) {
      pathStack.popToName(url)
    } else {
      pathStack.pop()
    }
  }
}