import { buffer } from '@kit.ArkTS';
import { Log } from './Log';

export class ArrayUtil {
  static isEmpty(array: Array<object>[]): boolean {
    return array == null || array.length === 0;
  }

  /**
   * 将字符串按 UTF-8 编码转换为字节数组
   * @param str - 输入字符串
   * @returns Uint8Array 字节数组，异常时返回空数组
   */
  static stringToBytes(str: string): Uint8Array {
    try {
      return new Uint8Array(buffer.from(str, 'utf-8').buffer);
    } catch (error) {
      Log.error(`stringToBytes 异常: ${JSON.stringify(error)}`)
      return new Uint8Array()
    }
  }

  /**
   * 将字节数组按 UTF-8 解码为字符串
   * @param data - 字节数组
   * @returns 解码后的字符串，异常时返回空字符串
   */
  static bytesToString(data: Uint8Array): string {
    try {
      return buffer.from(data.buffer).toString('utf-8');
    } catch (error) {
      Log.error(`bytesToString 异常: ${JSON.stringify(error)}`)
      return ''
    }
  }
}
