import { router } from '@kit.ArkUI';
import { Log } from './Log';
import { BusinessError } from '@kit.BasicServicesKit';

export class RouterHelper {
  /**
   * 页面跳转
   * 不替换当前页(默认)
   * 多实例模式(默认)
   * @context 上下文
   * @param url 目标页面 url
   * @param params 参数
   * @replace 是否替换当前页面 默认 false
   * @single 是否单实例模式 默认 false
   */
  static startPage(context: UIContext, url: string, params?: Record<string, string>,
    replace: boolean = false,
    single: boolean = false) {
    let mode: router.RouterMode;
    if (single) {
      mode = router.RouterMode.Single
    } else {
      mode = router.RouterMode.Standard
    }
    if (replace) {
      RouterHelper.routeReplace(context, url, params, mode)
    } else {
      RouterHelper.routePush(context, url, params, mode);
    }
  }

  /**
   * 命名路由
   * 不替换当前页(默认)
   * 多实例模式(默认)
   */
  static startNamedPage(context: UIContext, url: string, params?: Record<string, string>,
    replace: boolean = false,
    single: boolean = false) {
    let mode: router.RouterMode;
    if (single) {
      mode = router.RouterMode.Single
    } else {
      mode = router.RouterMode.Standard
    }
    if (replace) {
      RouterHelper.routeNamedReplace(context, url, params, mode)
    } else {
      RouterHelper.routeNamedPush(context, url, params, mode);
    }
  }

  private static routePush(context: UIContext, url: string, params: Record<string, string> | undefined,
    mode: router.RouterMode) {
    context.getRouter().pushUrl({
      url,
      params
    }, mode).then(() => {
      Log.log("Succeed to push page: " + url);
    }).catch((err: BusinessError) => {
      Log.error("Failed to push page: " + url);
      Log.error(`error:${err.code} ${err.message}`);
    });
  }

  private static routeReplace(context: UIContext, url: string, params: Record<string, string> | undefined,
    mode: router.RouterMode) {
    context.getRouter().replaceUrl({
      url,
      params
    }, mode).then(() => {
      Log.log("Succeed to push page: " + url);
    }).catch((err: BusinessError) => {
      Log.error("Failed to push page: " + url);
      Log.error(`error:${err.code} ${err.message}`);
    });
  }

  private static routeNamedPush(context: UIContext, url: string, params: Record<string, string> | undefined,
    mode: router.RouterMode) {
    context.getRouter().pushNamedRoute({
      name: url,
      params: params
    }, mode).then(() => {
      Log.log("Succeed to start page: " + url);
    }).catch((err: BusinessError) => {
      Log.error("Failed to start page: " + url);
      Log.error(`error:${err.code} ${err.message}`);
    });
  }

  private static routeNamedReplace(context: UIContext, url: string, params: Record<string, string> | undefined,
    mode: router.RouterMode) {
    context.getRouter().replaceNamedRoute({
      name: url,
      params: params
    }, mode).then(() => {
      Log.log("Succeed to start page: " + url);
    }).catch((err: BusinessError) => {
      Log.error("Failed to start page: " + url);
      Log.error(`error:${err.code} ${err.message}`);
    });
  }

  static back(context: UIContext, url?: string, params?: Record<string, string>) {
    context.getRouter().back({
      url,
      params
    })
  }
}
