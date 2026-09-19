export class KeyUtil {
  private static PRIVATE_KEY_HEX_PKCS8_PREFIX = "302e020100300506032b656e04220420"
  private static PUBLIC_KEY_HEX_X509_PREFIX = "302a300506032b656e032100"
  // Ed25519 私钥 PKCS#8 前缀（16进制转 Uint8Array）
  private static readonly PRIVATE_KEY_PKCS8_PREFIX: Uint8Array = new Uint8Array([
    0x30, 0x2E, 0x02, 0x01, 0x00, 0x30, 0x05, 0x06,
    0x03, 0x2B, 0x65, 0x6E, 0x04, 0x22, 0x04, 0x20
  ]);
  // Ed25519 公钥 X.509 前缀（16进制转 Uint8Array）
  private static readonly PUBLIC_KEY_X509_PREFIX: Uint8Array = new Uint8Array([
    0x30, 0x2A, 0x30, 0x05, 0x06, 0x03, 0x2B, 0x65,
    0x6E, 0x03, 0x21, 0x00
  ]);
  // Ed25519 原始密钥长度（均为 32 字节）
  private static readonly ED25519_PRIVATE_KEY_LENGTH: number = 32;
  private static readonly ED25519_PUBLIC_KEY_LENGTH: number = 32;

  // 公钥移除 X509 前缀
  static removePublicKeyHexPrefix(pubKeyHex: string): string {
    return pubKeyHex.substring(KeyUtil.PUBLIC_KEY_HEX_X509_PREFIX.length);
  }

  // 公钥添加 X509 前缀
  static addPublicKeyHexPrefix(pubKeyHex: string): string {
    return KeyUtil.PUBLIC_KEY_HEX_X509_PREFIX + pubKeyHex;
  }

  // 私钥移除 PKCS8 前缀
  static removePrivateKeyHexPrefix(priKeyHex: string): string {
    return priKeyHex.substring(KeyUtil.PRIVATE_KEY_HEX_PKCS8_PREFIX.length);
  }

  // 私钥添加 PKCS8 前缀
  static addPrivateKeyHexPrefix(priKeyHex: string): string {
    return KeyUtil.PRIVATE_KEY_HEX_PKCS8_PREFIX + priKeyHex;
  }

  // ==================== 公钥操作 ====================

  /**
   * 公钥移除 X.509 前缀
   * @param pubKeyArray 带前缀的完整公钥数据（44 字节）或原始公钥数据（32 字节）
   * @returns 去除前缀后的原始公钥数据（32 字节）
   */
  static removePublicKeyArrayPrefix(pubKeyArray: Uint8Array): Uint8Array {
    if (!pubKeyArray || pubKeyArray.length === 0) {
      throw new Error('公钥数据为空');
    }
    // 情况1：包含前缀 → 去除前缀
    if (KeyUtil.startsWith(pubKeyArray, KeyUtil.PUBLIC_KEY_X509_PREFIX)) {
      return pubKeyArray.subarray(KeyUtil.PUBLIC_KEY_X509_PREFIX.length);
    }
    // 情况2：已经是原始数据（32 字节）
    if (pubKeyArray.length === KeyUtil.ED25519_PUBLIC_KEY_LENGTH) {
      return pubKeyArray;
    }
    throw new Error(`无法识别的公钥格式，长度: ${pubKeyArray.length} 字节`);
  }

  /**
   * 公钥添加 X.509 前缀
   * @param pubKeyArray 原始公钥数据（32 字节）
   * @returns 添加前缀后的完整公钥数据（44 字节）
   */
  static addPublicKeyArrayPrefix(pubKeyArray: Uint8Array): Uint8Array {
    if (!pubKeyArray || pubKeyArray.length === 0) {
      throw new Error('公钥数据为空');
    }
    // 如果已经是带前缀格式，直接返回
    if (KeyUtil.startsWith(pubKeyArray, KeyUtil.PUBLIC_KEY_X509_PREFIX)) {
      return pubKeyArray;
    }
    // 验证原始公钥长度
    if (pubKeyArray.length !== KeyUtil.ED25519_PUBLIC_KEY_LENGTH) {
      throw new Error(`公钥原始数据长度不正确，期望 32 字节，实际 ${pubKeyArray.length} 字节`);
    }
    // 合并：前缀 + 原始数据
    const result = new Uint8Array(
      KeyUtil.PUBLIC_KEY_X509_PREFIX.length + pubKeyArray.length
    );
    result.set(KeyUtil.PUBLIC_KEY_X509_PREFIX, 0);
    result.set(pubKeyArray, KeyUtil.PUBLIC_KEY_X509_PREFIX.length);
    return result;
  }

  // ==================== 私钥操作 ====================

  /**
   * 私钥移除 PKCS#8 前缀
   * @param priKeyArray 带前缀的完整私钥数据（48 字节）或原始私钥数据（32 字节）
   * @returns 去除前缀后的原始私钥数据（32 字节）
   */
  static removePrivateKeyArrayPrefix(priKeyArray: Uint8Array): Uint8Array {
    if (!priKeyArray || priKeyArray.length === 0) {
      throw new Error('私钥数据为空');
    }
    // 情况1：包含前缀 → 去除前缀
    if (KeyUtil.startsWith(priKeyArray, KeyUtil.PRIVATE_KEY_PKCS8_PREFIX)) {
      return priKeyArray.subarray(KeyUtil.PRIVATE_KEY_PKCS8_PREFIX.length);
    }
    // 情况2：已经是原始数据（32 字节）
    if (priKeyArray.length === KeyUtil.ED25519_PRIVATE_KEY_LENGTH) {
      return priKeyArray;
    }
    throw new Error(`无法识别的私钥格式，长度: ${priKeyArray.length} 字节`);
  }

  /**
   * 私钥添加 PKCS#8 前缀
   * @param priKeyArray 原始私钥数据（32 字节）
   * @returns 添加前缀后的完整私钥数据（48 字节）
   */
  static addPrivateKeyArrayPrefix(priKeyArray: Uint8Array): Uint8Array {
    if (!priKeyArray || priKeyArray.length === 0) {
      throw new Error('私钥数据为空');
    }
    // 如果已经是带前缀格式，直接返回
    if (KeyUtil.startsWith(priKeyArray, KeyUtil.PRIVATE_KEY_PKCS8_PREFIX)) {
      return priKeyArray;
    }
    // 验证原始私钥长度
    if (priKeyArray.length !== KeyUtil.ED25519_PRIVATE_KEY_LENGTH) {
      throw new Error(`私钥原始数据长度不正确，期望 32 字节，实际 ${priKeyArray.length} 字节`);
    }
    // 合并：前缀 + 原始数据
    const result = new Uint8Array(
      KeyUtil.PRIVATE_KEY_PKCS8_PREFIX.length + priKeyArray.length
    );
    result.set(KeyUtil.PRIVATE_KEY_PKCS8_PREFIX, 0);
    result.set(priKeyArray, KeyUtil.PRIVATE_KEY_PKCS8_PREFIX.length);
    return result;
  }

  /**
   * 检查数据是否以指定前缀开头
   */
  private static startsWith(data: Uint8Array, prefix: Uint8Array): boolean {
    if (data.length < prefix.length) {
      return false;
    }
    for (let i = 0; i < prefix.length; i++) {
      if (data[i] !== prefix[i]) {
        return false;
      }
    }
    return true;
  }
}