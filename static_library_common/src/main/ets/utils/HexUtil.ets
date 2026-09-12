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
   * 将十六进制字符串转换为 Uint8Array
   * @param hex - 十六进制字符串（如 "1a2b3c" 或 "1A2B3C"）
   * @returns Uint8Array 字节数组
   */
  static hexToBytes(hex: string): Uint8Array {
    const len = hex.length;
    const byteCount = len / 2;
    const bytes = new Uint8Array(byteCount);
    for (let i = 0; i < byteCount; i++) {
      const index = i * 2;
      bytes[i] = parseInt(hex.substring(index, index + 2), 16);
    }
    return bytes;
  }
}
