import { http } from '@kit.NetworkKit';
import { Available } from '@kit.BasicServicesKit';
import { IOnRequest } from '../request/IOnRequest';
import { LogRequestImpl } from '../request/impl/LogRequestImpl';
import { TokenRequestImpl } from '../request/impl/TokenRequestImpl';
import { EncryptRequestImpl } from '../request/impl/EncryptRequestImpl';
import { Log } from 'static_library_common';

const TAG = 'RequestInterceptor';

/**
 * 日志拦截器 - 打印请求日志
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class RequestInterceptor implements http.HttpInterceptor {
  interceptorType: http.InterceptorType = http.InterceptorType.INITIAL_REQUEST;
  private readonly onRequests: IOnRequest[] = [
    new LogRequestImpl(),
    new TokenRequestImpl(),
    new EncryptRequestImpl(),
  ];

  interceptorHandle(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): Promise<http.ChainContinue> {
    reqContext = this.onRequests.reduce((icc, item) => {
      // Log.info(`[${TAG}] [Chain] before: ${JSON.stringify(icc)}`);
      const result = item.handleRequest(icc)
      // Log.info(`[${TAG}] [Chain] after: ${JSON.stringify(result)}`);
      return result
    }, reqContext);
    // 返回true 修改请求体
    return Promise.resolve(true);
  }
}

