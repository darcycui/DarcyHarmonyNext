import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';

const TAG = 'LogResponseInterceptor';

// ==================== 日志拦截器 ====================

/**
 * 日志拦截器 - 打印请求和响应日志
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class LogResponseInterceptor implements http.HttpInterceptor {
  interceptorType: http.InterceptorType = http.InterceptorType.FINAL_RESPONSE;

  interceptorHandle(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): Promise<http.ChainContinue> {
    Log.info(`[${TAG}] <========== RESPONSE <==========`);
    Log.info(`[${TAG}] <==Code: ${rspContext.responseCode}`);
    Log.warn(`[${TAG}] <==header: ${JSON.stringify(rspContext.header)}`);
    if (rspContext.resultType == http.HttpDataType.STRING) {
      Log.log(`[${TAG}] <==Result: ${rspContext.result}`);
    } else {
      Log.warn(`[${TAG}] <==Result: 响应体是非文本类型 不打印`)
    }
    return Promise.resolve(true);
  }
}
