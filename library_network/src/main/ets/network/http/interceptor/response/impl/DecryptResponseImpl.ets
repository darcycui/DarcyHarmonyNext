import { http } from '@kit.NetworkKit';
import { ArrayUtil, HexUtil, Log } from 'static_library_common';
import { Available } from '@kit.BasicServicesKit';
import { IOnResponse } from '../IOnResponse';
import { AADs, ServerDHSecretManager, TransformCryptoUtil } from 'library_crypto';
import { UrlUtil } from '../../../../../utils/UrlUtil';

const TAG = 'DecryptResponseImpl';

/**
 * 解密拦截器 - 解密响应数据
 */
@Available({ minApiVersion: 'OpenHarmony 22' })
export class DecryptResponseImpl implements IOnResponse {
  handleResponse(reqContext: http.HttpRequestContext, rspContext: http.HttpResponse): http.HttpResponse {
    Log.info(`[${TAG}] <========== RESPONSE <==========`);
    if (rspContext.resultType === http.HttpDataType.STRING) {
      if (ServerDHSecretManager.isSecretReady()) {
        const cipherBytes = HexUtil.hexToBytes(rspContext.result as string)
        const plainBytes = TransformCryptoUtil.decryptSync(
          cipherBytes,
          HexUtil.hexToBytes(ServerDHSecretManager.getDHSecretSync()),
          ArrayUtil.stringToBytes(AADs.AAD_PREFIX_POST + UrlUtil.stripUrlToPath(reqContext.url))
        )
        if (plainBytes.length > 0) {
          rspContext.result = ArrayUtil.bytesToString(plainBytes)
        }
        Log.warn(`[${TAG}] <==Decrypted Body: ${rspContext.result}`);
      } else {
        Log.warn(`[${TAG}] <==Decrypted Body: Server DH密钥未准备好 不解密`)
      }
    } else {
      Log.warn(`[${TAG}] <==Decrypted Body: 请求体是非文本类型 不解密`)
    }
    return rspContext;
  }
}

