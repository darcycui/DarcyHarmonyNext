import { Log } from 'static_library_common'
import { base64DecodeToUint8Array, base64Encode } from "../utils/Bese64Util"
import { hexToUint8Array, uint8ArrayToHexString } from "../utils/StringUnit8ArrayUtil"

/**
 * 生成公钥hash的base64
 * 用于证书锁定
 */
export function generatePubkeyHashBase64(pubHashInHex: string): string {
  Log.log("pubHash=" + pubHashInHex)
  let pubHashBase64: string = base64Encode(hexToUint8Array(pubHashInHex))
  Log.log("pubHashBase64=" + pubHashBase64)
  let pubHashDecode: string = uint8ArrayToHexString(base64DecodeToUint8Array(pubHashBase64))
  Log.log("pubHashDecode=" + pubHashDecode)
  return pubHashBase64
}