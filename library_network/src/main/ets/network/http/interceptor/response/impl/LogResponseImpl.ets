import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import { IOnResponse } from '../IOnResponse';

const TAG = 'LogRequestInterceptor';

/**
 * 日志拦截器 - 打印响应日志
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class LogResponseImpl implements IOnResponse {
  handleResponse(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): http.HttpResponse {
    Log.info(`[${TAG}] <==ResponseCode: ${rspContext.responseCode}`);
    Log.warn(`[${TAG}] <==Header: ${JSON.stringify(rspContext.header)}`);
    if (rspContext.resultType === http.HttpDataType.STRING) {
      Log.info(`[${TAG}] <==Body: ${rspContext.result}`);
    } else {
      Log.warn(`[${TAG}] <==Body: 请求体是非文本类型 不解密`)
    }
    return rspContext;
  }
}

