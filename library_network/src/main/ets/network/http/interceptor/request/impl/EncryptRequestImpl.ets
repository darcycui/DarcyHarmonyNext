import { http } from '@kit.NetworkKit';
import { ArrayUtil, HexUtil, Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import { IOnRequest } from '../IOnRequest';
import { AADs, ServerDHSecretManager, TransportCipherUtil } from 'library_crypto';
import { UrlUtil } from '../../../../../utils/UrlUtil';

const TAG = 'EncryptRequestInterceptor';

/**
 * 加密拦截器 - 对请求参数进行加密
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class EncryptRequestImpl implements IOnRequest {
  handleRequest(reqContext: http.HttpRequestContext): http.HttpRequestContext {
    if (typeof reqContext.body === 'string') {
      if (ServerDHSecretManager.isSecretReady()) {
        // 对请求体进行加密
        const cipherBody = TransportCipherUtil.encryptSync(
          ArrayUtil.stringToBytes(reqContext.body),
          HexUtil.hexToBytes(ServerDHSecretManager.getDHSecretSync()),
          TransportCipherUtil.getIV(),
          ArrayUtil.stringToBytes(AADs.AAD_PREFIX_POST + UrlUtil.stripUrlToPath(reqContext.url))
        )
        reqContext.body = HexUtil.bytesToHex(cipherBody)
        Log.warn(`[${TAG}] ==>Encryped Body: ${reqContext.body}`);
      } else {
        Log.warn(`[${TAG}] ==>Encryped Body: Server DH密钥未准备好 不加密`)
      }
    } else {
      Log.warn(`[${TAG}] ==>Encryped Body: 请求体是非文本类型 不加密`)
    }
    return reqContext;
  }
}

