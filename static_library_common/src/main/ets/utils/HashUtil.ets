/**
 * SHA256 哈希工具类
 * 提供计算 SHA256 摘要的同步和异步静态方法
 */
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { Log } from './Log';
import { HexUtil } from './HexUtil';

export class HashUtil {

  /**
   * 异步计算二进制数据的 SHA256 哈希值
   * @param data - 待计算的二进制数据
   * @returns 十六进制格式的哈希字符串，异常时返回空字符串
   */
  static async sha256FromBytes(data: Uint8Array): Promise<string> {
    try {
      let mdAlgName = 'SHA256';
      let md = cryptoFramework.createMd(mdAlgName);
      await md.update({ data: data });
      let mdResult = await md.digest();
      return HexUtil.bytesToHex(mdResult.data);
    } catch (error) {
      Log.error(`HashUtil.sha256FromBytes 异常: ${JSON.stringify(error)}`)
      return ''
    }
  }

  /**
   * 同步计算二进制数据的 SHA256 哈希值
   * @param data - 待计算的二进制数据
   * @returns 十六进制格式的哈希字符串，异常时返回空字符串
   */
  static sha256FromBytesSync(data: Uint8Array): string {
    try {
      let mdAlgName = 'SHA256';
      let md = cryptoFramework.createMd(mdAlgName);
      md.update({ data: data });
      let mdResult = md.digestSync();
      return HexUtil.bytesToHex(mdResult.data);
    } catch (error) {
      Log.error(`HashUtil.sha256FromBytesSync 异常: ${JSON.stringify(error)}`)
      return ''
    }
  }
}
