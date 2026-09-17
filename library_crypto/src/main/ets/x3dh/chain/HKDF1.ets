/**
 * HKDF-SHA256 密钥派生工具
 *
 * 基于 HMAC-SHA256 实现 HKDF（RFC 5869）
 * 用于 Double Ratchet 协议的根密钥/链密钥演进
 */
import { Log } from 'static_library_common';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

export class HKDF1 {
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
   * HKDF-Extract：从输入密钥材料提取伪随机密钥 (PRK)
   *
   * PRK = HMAC-SHA256(salt, IKM)
   *
   * @param salt     盐值（为空时使用全零盐）
   * @param ikm      输入密钥材料
   * @returns        伪随机密钥 (32 字节)
   */
  private extract(salt: Uint8Array, ikm: Uint8Array): Uint8Array {
    const effectiveSalt = salt.length > 0 ? salt : new Uint8Array(32);
    return this.hmacSha256(effectiveSalt, ikm);
  }

  /**
   * HKDF-Expand：从 PRK 扩展到指定长度的输出密钥材料 (OKM)
   *
   * OKM = T(1) || T(2) || ... || T(N)
   * T(0) = empty
   * T(i) = HMAC-SHA256(PRK, T(i-1) || info || i)
   *
   * @param prk       伪随机密钥 (32 字节)
   * @param info      上下文信息
   * @param length    输出长度（字节），最大 255 * 32 = 8160
   * @returns         派生出的密钥材料
   */
  private expand(prk: Uint8Array, info: Uint8Array, length: number): Uint8Array {
    const hashLen = 32; // SHA-256 输出长度
    const n = Math.ceil(length / hashLen);
    const okm = new Uint8Array(n * hashLen);

    let previous = new Uint8Array(0);
    for (let i = 1; i <= n; i++) {
      // 拼接 T(i-1) || info || i
      const data = new Uint8Array(previous.length + info.length + 1);
      data.set(previous, 0);
      data.set(info, previous.length);
      data[previous.length + info.length] = i;

      const block = this.hmacSha256(prk, data);
      okm.set(block, (i - 1) * hashLen);
      previous = block;
    }

    return okm.slice(0, length);
  }

  /**
   * HKDF-SHA256 完整密钥派生
   *
   * @param ikm       输入密钥材料
   * @param salt      盐值
   * @param info      上下文信息
   * @param length    输出长度（字节）
   * @returns         派生出的密钥材料
   */
  deriveSecrets(ikm: Uint8Array, salt: Uint8Array, info: Uint8Array, length: number): Uint8Array {
    try {
      const prk = this.extract(salt, ikm);
      return this.expand(prk, info, length);
    } catch (error) {
      Log.error(`HKDFUtil.deriveSecrets 异常: ${JSON.stringify(error)}`);
      return new Uint8Array(length);
    }
  }
}
