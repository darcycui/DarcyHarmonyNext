import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import { IOnResponse } from '../IOnResponse';

const TAG = 'DecryptResponseImpl';

/**
 * 解密拦截器 - 解密响应数据
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class DecryptResponseImpl implements IOnResponse {
  handleResponse(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): void {
    if (rspContext.resultType === http.HttpDataType.STRING) {
      Log.warn(`[${TAG}] <==Decrypted Body: ${rspContext.result}`);
    } else {
      Log.warn(`[${TAG}] <==Decrypted Body: 请求体是非文本类型 不解密`)
    }
  }
}

