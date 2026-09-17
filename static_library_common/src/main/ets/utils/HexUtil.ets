import { buffer } from "@kit.ArkTS";
import ErrorUtil from "./ErrorUtil";

export class HexUtil {
  /**
   * 将 Uint8Array 转换为十六进制字符串
   * @param data - 二进制数据
   * @returns 十六进制字符串
   */
  static bytesToHex(data: Uint8Array): string {
    let hex = ''
    // try {
      hex = buffer.from(data).toString('hex');
    // } catch (error) {
    //   ErrorUtil.logError(error)
    // }
    return hex;
  }

  /**
   * 将十六进制字符串转换为 Uint8Array
   * @param hex - 十六进制字符串（如 "1a2b3c" 或 "1A2B3C"）
   * @returns Uint8Array 字节数组
   */
  static hexToBytes(hex: string): Uint8Array {
    const bytes = new Uint8Array(buffer.from(hex, 'hex').buffer);
    return bytes;
  }
}
