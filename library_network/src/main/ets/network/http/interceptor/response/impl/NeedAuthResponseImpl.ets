import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { IOnRequest } from '../../request/IOnRequest';
import { IOnResponse } from '../IOnResponse';

const TAG = 'NeedAuthResponseImpl';

/**
 * 需要授权的响应拦截器
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class NeedAuthResponseImpl implements IOnResponse {
  handleResponse(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): http.HttpResponse {
    Log.info(`[${TAG}] response code = ${rspContext.responseCode}`);

    // 处理错误码
    if (rspContext.responseCode === 401) {
      Log.error(`[${TAG}] 401 Unauthorized`);
    } else if (rspContext.responseCode === 403) {
      Log.error(`[${TAG}] 403 Forbidden`);
    }
    return rspContext;
  }
}

