import { http } from '@kit.NetworkKit';
import { Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { IOnRequest } from '../IOnRequest';
import { TokenManager } from '../../../TokenManager';

const TAG = 'LogRequestInterceptor';

/**
 * Token 拦截器 - 添加 token 到请求头
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class TokenRequestImpl implements IOnRequest {
  handleRequest(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): void {
    Log.error(`[${TAG}] >>>>>>>>>>>> interceptorHandle 被调用 <<<<<<<<<<<<`);
    const token = TokenManager.getTokenSync();
    Log.log(`[${TAG}] token=${token}`);
    if (token) {
      // 初始化 header (若不存在)
      if (!reqContext.header) {
        reqContext.header = {};
      }
      // 添加 token 到请求头
      reqContext.header['Authorization'] = `Bearer ${token}`;
      Log.info(`[${TAG}] 添加 token 到 Authorization header`);
    } else {
      Log.warn(`[${TAG}] token 为空 跳过`);
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

