import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import { IOnRequest } from '../IOnRequest';

const TAG = 'LogRequestInterceptor';

/**
 * 日志拦截器 - 打印请求日志
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class LogRequestImpl implements IOnRequest {
  handleRequest(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): void {
    Log.info(`[${TAG}] ==========> REQUEST ==========>`);
    Log.info(`[${TAG}] ==>URL: ${reqContext.url}`);
    // Log.info(`[${TAG}] Method: ${reqContext.method}`);
    Log.warn(`[${TAG}] ==>Header: ${JSON.stringify(reqContext.header)}`);
    if (typeof reqContext.body === 'string') {
      Log.info(`[${TAG}] ==>Body: ${reqContext.body}`);
    } else {
      Log.warn(`[${TAG}] ==>Body: 请求体是非文本类型 不打印`)
    }
  }
}

