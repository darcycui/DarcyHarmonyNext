import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { IOnRequest } from '../request/IOnRequest';
import { LogRequestImpl } from '../request/impl/LogRequestImpl';
import { TokenRequestImpl } from '../request/impl/TokenRequestImpl';
import { EncryptRequestImpl } from '../request/impl/EncryptRequestImpl';

const TAG = 'LogRequestInterceptor';

/**
 * 日志拦截器 - 打印请求和响应日志
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
    this.onRequests.forEach(item => item.handleRequest(reqContext, rspContext))
    return Promise.resolve(true);
  }
}

