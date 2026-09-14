import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import { IOnRequest } from '../IOnRequest';

const TAG = 'EncryptRequestInterceptor';

/**
 * 加密拦截器 - 对请求参数进行加密
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class EncryptRequestImpl implements IOnRequest {
  handleRequest(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): void {
    if (typeof reqContext.body === 'string') {
      Log.warn(`[${TAG}] ==>Encryped Body: ${reqContext.body}`);
    } else {
      Log.warn(`[${TAG}] ==>Encryped Body: 请求体是非文本类型 不加密`)
    }
  }
}

