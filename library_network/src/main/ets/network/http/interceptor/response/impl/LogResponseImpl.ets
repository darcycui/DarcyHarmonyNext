import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { IOnRequest } from '../../request/IOnRequest';
import { IOnResponse } from '../IOnResponse';

const TAG = 'LogRequestInterceptor';

/**
 * 日志拦截器 - 打印请求和响应日志
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class LogResponseImpl implements IOnResponse {
  handleResponse(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): void {
    Log.info(`[${TAG}] ==========> REQUEST ==========>`);
    Log.info(`[${TAG}] ==>URL: ${reqContext.url}`);
    // Log.info(`[${TAG}] Method: ${reqContext.method}`);
    Log.warn(`[${TAG}] ==>Header: ${JSON.stringify(reqContext.header)}`);
    if (typeof reqContext.body === 'string') {
      Log.info(`[${TAG}] ==>Body: ${this.getObjectText(reqContext.body)}`);
    } else {
      Log.warn(`[${TAG}] ==>Body: 请求体是非文本类型 不打印`)
    }
  }

  private getObjectText(obj: Object): string {
    if (typeof obj === 'string') {
      return obj
    } else {
      return JSON.stringify(obj);
    }
  }
}

