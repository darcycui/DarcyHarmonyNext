import { Log, Base64Util, StringUnit8ArrayUtil } from 'static_library_common'

/**
 * 生成公钥hash的base64
 * 用于证书锁定
 */
export function generatePubkeyHashBase64(pubHashInHex: string): string {
  Log.log("pubHash=" + pubHashInHex)
  let pubHashBase64: string = Base64Util.base64Encode(StringUnit8ArrayUtil.hexToUint8Array(pubHashInHex))
  Log.log("pubHashBase64=" + pubHashBase64)
  let pubHashDecode: string = StringUnit8ArrayUtil.uint8ArrayToHexString(Base64Util.base64DecodeToUint8Array(pubHashBase64))
  Log.log("pubHashDecode=" + pubHashDecode)
  return pubHashBase64
}
