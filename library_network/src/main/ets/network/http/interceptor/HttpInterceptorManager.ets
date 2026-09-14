import { Available } from "@kit.BasicServicesKit";
import { http } from "@kit.NetworkKit";
import ErrorUtil from "static_library_common/src/main/ets/utils/ErrorUtil";
import { RequestInterceptor } from "./interceptor/RequestInterceptor";
import { ResponseInterceptor } from "./interceptor/ResponseInterceptor";

export class HttpInterceptorManager {
  // ==================== 拦截器链管理 ====================

  /**
   * 创建默认拦截器链
   * @param tokenProvider 获取 token 的回调函数
   * @param onAuthError 错误回调
   */
  @Available({ minApiVersion: 'OpenHarmony 22' })
  static createDefaultInterceptorChain(): http.HttpInterceptorChain {
    const chain = new http.HttpInterceptorChain();
    try {
      chain.addChain([
        new RequestInterceptor(),
        new ResponseInterceptor(),
      ]);
    } catch (error) {
      ErrorUtil.logError(error)
    }
    return chain;
  }
}