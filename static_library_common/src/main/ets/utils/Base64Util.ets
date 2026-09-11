import util from '@ohos.util';
import { Log } from './Log';

/**
 * Base64 编解码工具类
 */
export class Base64Util {

  /**
   * 将 Base64 字符串解码为 UTF-8 字符串
   * @param base64Str - Base64 编码的字符串
   * @returns 解码后的 UTF-8 字符串
   */
  static base64DecodeToString(base64Str: string): string {
    try {
      let arr = Base64Util.base64DecodeToUint8Array(base64Str)
      let decoder = util.TextDecoder.create('utf-8');
      let str = decoder.decodeToString(arr)
      return str
    } catch (err) {
      Log.error(`Base64Util.base64DecodeToString err = ${err}`)
    }
    return ''
  }

  /**
   * 将 Base64 字符串解码为 Uint8Array
   * @param base64Str - Base64 编码的字符串
   * @returns 解码后的字节数组
   */
  static base64DecodeToUint8Array(base64Str: string): Uint8Array {
    return new util.Base64Helper().decodeSync(base64Str);
  }

  /**
   * 将 Uint8Array 编码为 Base64 字符串
   * @param array - 待编码的字节数组
   * @returns Base64 编码后的字符串
   */
  static base64Encode(array: Uint8Array): string {
    try {
      let str = new util.Base64Helper().encodeToStringSync(array)
      return str
    } catch (err) {
      Log.error(`Base64Util.base64Encode err = ${err}`)
    }
    return ''
  }
}
