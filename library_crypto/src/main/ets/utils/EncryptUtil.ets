/**
 * 加密辅助工具
 *
 * 提供字节数组拼接、分割、日志等通用功能
 * 用于 X3DH 和 Double Ratchet 协议中的数据处理
 */
import { Log } from 'static_library_common';
import { HexUtil } from 'static_library_common';

export class EncryptUtil {
  /**
   * 拼接多个字节数组
   *
   * @param arrays 要拼接的字节数组列表
   * @returns      拼接后的字节数组
   */
  static appendArrays(...arrays: Uint8Array[]): Uint8Array {
    let totalLength = 0;
    for (const arr of arrays) {
      totalLength += arr.length;
    }
    const result = new Uint8Array(totalLength);
    let offset = 0;
    for (const arr of arrays) {
      result.set(arr, offset);
      offset += arr.length;
    }
    return result;
  }

  /**
   * 将字节数组分割为两部分
   *
   * @param data  待分割的字节数组
   * @param split 分割点索引
   * @returns     [前半部分, 后半部分]
   */
  static splitArray64(data: Uint8Array, split: number): [Uint8Array, Uint8Array] {
    const first = data.slice(0, split);
    const second = data.slice(split);
    return [first, second];
  }

  /**
   * 将 Uint8Array 转换为 hex 字符串
   */
  static toHexString(data: Uint8Array): string {
    return HexUtil.bytesToHex(data);
  }

  /**
   * 将 hex 字符串转换为 Uint8Array
   */
  static fromHexString(hex: string): Uint8Array {
    return HexUtil.hexToBytes(hex);
  }

  /**
   * 打印字节数组的 hex 表示（调试用）
   *
   * @param prefix 日志前缀
   * @param data   字节数组
   */
  static log(prefix: string, data: Uint8Array): void {
    const hex = HexUtil.bytesToHex(data);
    Log.log(`${prefix} ${hex}`);
  }

  /**
   * 打印信息日志（调试用）
   */
  static logI(msg: string, data: Uint8Array): void {
    const hex = HexUtil.bytesToHex(data);
    Log.info(`${msg} ${hex}`);
  }
}
