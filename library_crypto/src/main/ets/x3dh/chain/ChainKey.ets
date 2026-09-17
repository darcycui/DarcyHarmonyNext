/**
 * Double Ratchet 链密钥管理
 *
 * 管理发送链/接收链的密钥演进，每步演进派生出消息密钥
 */
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { ArrayUtil } from 'static_library_common';
import { HKDF1 } from './HKDF1';

export class ChainKey {
  /** 当前链密钥 */
  private key: Uint8Array;

  /** 当前链索引 */
  private index: number;

  constructor(chainKeyBytes: Uint8Array, index: number) {
    this.key = chainKeyBytes;
    this.index = index;
  }

  /**
   * 获取当前链密钥字节数组
   */
  getKey(): Uint8Array {
    return this.key;
  }

  /**
   * 获取当前链索引
   */
  getIndex(): number {
    return this.index;
  }

  /**
   * 将字节数组转换为 HMAC 对称密钥 (SymKey)
   */
  private bytesToSymKey(keyBytes: Uint8Array): cryptoFramework.SymKey {
    const symKeyGenerator = cryptoFramework.createSymKeyGenerator('HMAC');
    const keyBlob: cryptoFramework.DataBlob = { data: keyBytes };
    return symKeyGenerator.convertKeySync(keyBlob);
  }

  /**
   * 执行 HMAC-SHA256 计算
   *
   * @param keyBytes  密钥字节数组
   * @param data      消息数据
   * @returns         HMAC 结果 (32 字节)
   */
  private hmacSha256(keyBytes: Uint8Array, data: Uint8Array): Uint8Array {
    const symKey = this.bytesToSymKey(keyBytes);
    const mac = cryptoFramework.createMac('SHA256');
    mac.initSync(symKey);
    mac.updateSync({ data: data } as cryptoFramework.DataBlob);
    const result = mac.doFinalSync();
    return result.data;
  }

  /**
   * 演进到下一个链密钥
   * ChainKey(n+1) = HMAC-SHA256(ChainKey(n), 0x02)
   */
  getNextChainKey(): ChainKey {
    const result = this.hmacSha256(this.key, new Uint8Array([0x02]));
    return new ChainKey(result, this.index + 1);
  }

  /**
   * 从当前链密钥派生消息密钥三元组 (messageKey, macKey, iv)
   *
   * 使用 HKDF 从链密钥派生 80 字节：
   * - 前 32 字节 → messageKey（消息加密密钥）
   * - 中 32 字节 → macKey（MAC 密钥）
   * - 后 16 字节 → iv（初始化向量，截断为 12 字节使用）
   */
  getMessageKeyTriple(): [Uint8Array, Uint8Array, Uint8Array] {
    const hkdf = new HKDF1();
    const derived = hkdf.deriveSecrets(this.key, new Uint8Array(32), ArrayUtil.stringToBytes('MessageKeys'), 80);
    const messageKey = derived.slice(0, 32);
    const macKey = derived.slice(32, 64);
    const iv = derived.slice(64, 80).slice(0, 12); // GCM IV 为 12 字节
    return [messageKey, macKey, iv];
  }
}
