import { buffer } from "@kit.ArkTS";

export class HexUtil {

  /**
   * 将 Uint8Array 转换为十六进制字符串
   * @param data - 二进制数据
   * @returns 十六进制字符串
   */
  static bytesToHex(data: Uint8Array): string {
    let hex = '';
    for (let i = 0; i < data.length; i++) {
      hex += data[i].toString(16).padStart(2, '0')
    }
    return hex;
  }

  /**
   * 将字符串转换为 Uint8Array（UTF-8 编码）
   * @param str - 输入字符串
   * @returns Uint8Array 字节数组
   */
  static stringToBytes(str: string): Uint8Array {
    return new Uint8Array(buffer.from(str, 'utf-8').buffer);
  }
}
