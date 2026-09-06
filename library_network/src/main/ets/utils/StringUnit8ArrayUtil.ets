/*
 * 提供Uint8Array和String互转操作的两个接口
 */
import { buffer, util } from '@kit.ArkTS';

// 将16进制字符串转换为Uint8Array
export function hexToUint8Array(hex: string): Uint8Array {
  const bytes = new Uint8Array(hex.length / 2);
  for (let i = 0; i < bytes.length; i++) {
    bytes[i] = parseInt(hex.substr(i * 2, 2), 16);
  }
  return bytes;
}

// 将Uint8Array转换为16进制字符串
export function uint8ArrayToHexString(uint8Array: Uint8Array): string {
  let hexString = '';
  for (let i = 0; i < uint8Array.length; i++) {
    const hex = uint8Array[i].toString(16).padStart(2, '0'); // 确保每个字节是两位16进制数
    hexString += hex;
  }
  return hexString;
}


// 字符串转成字节流
export function stringToUint8Array(str: string): Uint8Array {
  return new Uint8Array(buffer.from(str, 'utf-8').buffer);
}

// 字节流转成可理解的字符串
export function uint8ArrayToString(array: Uint8Array): string {
  // 将UTF-8编码转换成Unicode编码
  let str: string = new util.Base64Helper().encodeToStringSync(array)
  return str;
}