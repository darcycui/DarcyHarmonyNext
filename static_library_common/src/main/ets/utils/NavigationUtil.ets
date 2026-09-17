import { Log } from './Log';
import { BusinessError } from '@kit.BasicServicesKit';
import ErrorUtil from './ErrorUtil';

export class NavigationUtil {
  static startPage(pathStack: NavPathStack, url: string, params?: Record<string, string>,
    replace: boolean = false,
    single: boolean = false) {
    if (replace) {
      try {
        pathStack.replacePath({ name: url, param: params })
        Log.log("Succeed to replace page: " + url);
      } catch (e) {
        Log.log("Failed to replace page: " + url)
        ErrorUtil.logError(e)
      }
    } else {
      pathStack.pushDestination({ name: url, param: params })
        .then(() => {
          Log.log("Succeed to push page: " + url);
        }).catch((err: BusinessError) => {
        Log.error(`Failed to push page: ${url} ERROR:${err.code} ${err.message}`);
      });
    }
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