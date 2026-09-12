/*
 * 提供Uint8Array和String互转操作的工具类
 */
import { buffer, util } from '@kit.ArkTS';
import ErrorUtil from './ErrorUtil';

/**
 * Uint8Array 与 String 互转工具类
 */
export class StringUnit8ArrayUtil {
  /**
   * 字符串转成字节流
   * @param str - 输入字符串
   * @returns 字节数组
   */
  static stringToUint8Array(str: string): Uint8Array {
    return new Uint8Array(buffer.from(str, 'utf-8').buffer);
  }

  /**
   * 字节流转成可理解的字符串
   * @param array - 字节数组
   * @returns 解码后的字符串
   */
  static uint8ArrayToString(array: Uint8Array): string {
    let str: string = util.TextDecoder.create(
      'utf-8',
      {
        fatal: false, // 遇到无效字节不抛异常
        ignoreBOM: true // 忽略 BOM 标记
      }).decodeToString(array);
    return str;
  }
  /**
   * 字节数组转成可理解的字符串
   * 备选方案 不支持 ignoreBOM、fatal 等配置
   * @param array - 字节数组
   * @returns 解码后的字符串
   */
  static uint8ArrayToString2(array: Uint8Array): string {
    let str = ''
    try {
      str = buffer.from(array).toString('utf-8');
    } catch (error) {
      ErrorUtil.logError(error)
    }
    return str
  }
}
