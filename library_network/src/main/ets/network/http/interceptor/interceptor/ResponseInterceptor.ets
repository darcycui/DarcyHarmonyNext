import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { IOnResponse } from '../response/IOnResponse';
import { LogResponseImpl } from '../response/impl/LogResponseImpl';
import { NeedAuthResponseImpl } from '../response/impl/NeedAuthResponseImpl';
import { DecryptResponseImpl } from '../response/impl/DecryptResponseImpl';

const TAG = 'ResponseInterceptor';

// ==================== 日志拦截器 ====================

/**
 * 日志拦截器 - 打印响应日志
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class ResponseInterceptor implements http.HttpInterceptor {
  interceptorType: http.InterceptorType = http.InterceptorType.FINAL_RESPONSE;
  private readonly onResponses: IOnResponse[] = [
    new DecryptResponseImpl(),
    new LogResponseImpl(),
    new NeedAuthResponseImpl(),
  ];

  interceptorHandle(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): Promise<http.ChainContinue> {
    this.onResponses.forEach((item) => {
      item.handleResponse(reqContext, rspContext);
    });
    // 返回false 修改响应体
    return Promise.resolve(false);
  }
}
