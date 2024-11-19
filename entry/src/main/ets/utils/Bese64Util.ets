
import util from '@ohos.util';
import { Log } from 'static_common';

export function base64DecodeToString(base64Str: string): string {
  try {
    let arr = base64DecodeToUint8Array(base64Str)
    let decoder = util.TextDecoder.create('utf-8');
    let str = decoder.decodeToString(arr)
    return str
  } catch (err) {
    Log.error(`base64Decode err = ${err}`)
  }
  return ''
}

export function base64DecodeToUint8Array(base64Str: string): Uint8Array {
  return new util.Base64Helper().decodeSync(base64Str);
}

export function base64Encode(array: Uint8Array): string {
  try {
    let str = new util.Base64Helper().encodeToStringSync(array)
    return str
  } catch (err) {
    Log.error(`base64Encode err = ${err}`)
  }
  return ''
}