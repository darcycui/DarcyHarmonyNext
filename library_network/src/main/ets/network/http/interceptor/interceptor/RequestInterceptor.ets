import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { IOnRequest } from '../request/IOnRequest';

const TAG = 'LogRequestInterceptor';

/**
 * 日志拦截器 - 打印请求和响应日志
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class RequestInterceptor implements http.HttpInterceptor {
  interceptorType: http.InterceptorType = http.InterceptorType.INITIAL_REQUEST;
  private readonly onRequests: IOnRequest[] = [
    new
  ];

  interceptorHandle(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): Promise<http.ChainContinue> {
    Log.info(`[${TAG}] ==========> REQUEST ==========>`);
    Log.info(`[${TAG}] ==>URL: ${reqContext.url}`);
    // Log.info(`[${TAG}] Method: ${reqContext.method}`);
    Log.warn(`[${TAG}] ==>Header: ${JSON.stringify(reqContext.header)}`);
    if (typeof reqContext.body === 'string') {
      Log.info(`[${TAG}] ==>Body: ${this.getBodyText(reqContext)}`);
    } else {
      Log.warn(`[${TAG}] ==>Body: 请求体是非文本类型 不打印`)
    }
    return Promise.resolve(true);
  }

  private getBodyText(reqContext: http.HttpRequestContext): string {
    if (typeof reqContext.body === 'string') {
      return reqContext.body
    } else {
      return JSON.stringify(reqContext.body);
    }
  }
}

