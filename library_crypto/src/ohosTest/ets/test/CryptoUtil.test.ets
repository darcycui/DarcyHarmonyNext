// ============================================================
// CryptoUtil 仪器化测试（AES-256-GCM 加解密）
// 覆盖：异步/同步加解密回环、输出格式、错误密钥、篡改密文、AAD 校验、边界数据
// 说明：
//   1. 被测类位于 library_crypto HAR，测试通过宿主 HAP（entry）在模拟器/真机上运行；
//   2. 本地测试环境（src/test）的 cryptoFramework 为桩实现，无法验证真实加解密。
// ============================================================
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { CryptoUtil } from 'library_crypto/src/main/ets/utils/CryptoUtil';

// 库内相对导入（测试文件位于库自身包内，不能 import 'library_crypto' 自引用，否则类型退化为 any）

/**
 * 生成指定长度的测试字节数组
 * @param length - 数组长度
 * @param start  - 起始字节值
 */
function genBytes(length: number, start: number = 0): Uint8Array {
  let bytes = new Uint8Array(length);
  for (let i = 0; i < length; i++) {
    bytes[i] = (start + i) % 256;
  }
  return bytes;
}

/**
 * 判断两个字节数组内容是否完全一致
 */
function bytesEquals(a: Uint8Array, b: Uint8Array): boolean {
  if (a.length !== b.length) {
    return false;
  }
  for (let i = 0; i < a.length; i++) {
    if (a[i] !== b[i]) {
      return false;
    }
  }
  return true;
}

export default function testCryptoUtil() {
  describe('CryptoUtilTest', () => {
    // 32 字节密钥（AES-256）
    const KEY: Uint8Array = genBytes(32, 1);
    // 12 字节 IV（GCM 要求）
    const IV: Uint8Array = genBytes(12, 100);
    // 附加认证数据
    const AAD: Uint8Array = genBytes(8, 200);

    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    // ===================== 异步加解密 =====================

    it('异步加解密回环_明文一致', 0, async () => {
      let plain = genBytes(64);
      let cipher = await CryptoUtil.encrypt(plain, KEY, IV, AAD);
      expect(cipher.length > 0).assertTrue();
      let decrypted = await CryptoUtil.decrypt(cipher, KEY, AAD);
      expect(bytesEquals(decrypted, plain)).assertTrue();
    });

    it('异步加密_输出格式_IV12密文Tag16', 0, async () => {
      let plain = genBytes(32);
      let cipher = await CryptoUtil.encrypt(plain, KEY, IV, AAD);
      // 输出 = [IV(12B)] + [密文] + [AuthTag(16B)]
      expect(cipher.length).assertEqual(plain.length + 28);
    });

    it('异步加密_相同输入密文确定', 0, async () => {
      let plain = genBytes(48);
      let cipher1 = await CryptoUtil.encrypt(plain, KEY, IV, AAD);
      let cipher2 = await CryptoUtil.encrypt(plain, KEY, IV, AAD);
      expect(bytesEquals(cipher1, cipher2)).assertTrue();
    });

    it('异步解密_错误密钥返回空', 0, async () => {
      let plain = genBytes(32);
      let cipher = await CryptoUtil.encrypt(plain, KEY, IV, AAD);
      let wrongKey = genBytes(32, 9);
      let decrypted = await CryptoUtil.decrypt(cipher, wrongKey, AAD);
      expect(decrypted.length).assertEqual(0);
    });

    it('异步解密_篡改密文返回空', 0, async () => {
      let plain = genBytes(32);
      let cipher = await CryptoUtil.encrypt(plain, KEY, IV, AAD);
      // 篡改密文中间一个字节（AuthTag 校验应失败）
      let tampered = new Uint8Array(cipher);
      tampered[20] = tampered[20] ^ 0xFF;
      let decrypted = await CryptoUtil.decrypt(tampered, KEY, AAD);
      expect(decrypted.length).assertEqual(0);
    });

    it('异步解密_数据长度不足返回空', 0, async () => {
      let shortData = genBytes(10); // 小于 IV(12) + Tag(16) = 28
      let decrypted = await CryptoUtil.decrypt(shortData, KEY, AAD);
      expect(decrypted.length).assertEqual(0);
    });

    it('异步解密_AAD不匹配返回空', 0, async () => {
      let plain = genBytes(32);
      let cipher = await CryptoUtil.encrypt(plain, KEY, IV, AAD);
      let wrongAad = genBytes(8, 250);
      let decrypted = await CryptoUtil.decrypt(cipher, KEY, wrongAad);
      expect(decrypted.length).assertEqual(0);
    });

    it('异步加解密_空明文', 0, async () => {
      let empty = new Uint8Array();
      let cipher = await CryptoUtil.encrypt(empty, KEY, IV, AAD);
      expect(cipher.length).assertEqual(28); // 仅 IV + Tag
      let decrypted = await CryptoUtil.decrypt(cipher, KEY, AAD);
      expect(decrypted.length).assertEqual(0);
    });

    // ===================== 同步加解密 =====================

    it('同步加解密回环_明文一致', 0, () => {
      let plain = genBytes(64);
      let cipher = CryptoUtil.encryptSync(plain, KEY, IV, AAD);
      expect(cipher.length > 0).assertTrue();
      let decrypted = CryptoUtil.decryptSync(cipher, KEY, AAD);
      expect(bytesEquals(decrypted, plain)).assertTrue();
    });

    it('同步加密_输出格式_IV12密文Tag16', 0, () => {
      let plain = genBytes(32);
      let cipher = CryptoUtil.encryptSync(plain, KEY, IV, AAD);
      expect(cipher.length).assertEqual(plain.length + 28);
    });

    it('同步异步加密结果一致', 0, async () => {
      let plain = genBytes(48);
      let cipherSync = CryptoUtil.encryptSync(plain, KEY, IV, AAD);
      let cipherAsync = await CryptoUtil.encrypt(plain, KEY, IV, AAD);
      expect(bytesEquals(cipherSync, cipherAsync)).assertTrue();
    });

    it('同步解密_错误密钥返回空', 0, () => {
      let plain = genBytes(32);
      let cipher = CryptoUtil.encryptSync(plain, KEY, IV, AAD);
      let wrongKey = genBytes(32, 7);
      let decrypted = CryptoUtil.decryptSync(cipher, wrongKey, AAD);
      expect(decrypted.length).assertEqual(0);
    });

    it('同步解密_篡改AuthTag返回空', 0, () => {
      let plain = genBytes(32);
      let cipher = CryptoUtil.encryptSync(plain, KEY, IV, AAD);
      // 篡改 AuthTag（最后 16 字节中的第 2 字节）
      let tampered = new Uint8Array(cipher);
      tampered[cipher.length - 2] = tampered[cipher.length - 2] ^ 0xFF;
      let decrypted = CryptoUtil.decryptSync(tampered, KEY, AAD);
      expect(decrypted.length).assertEqual(0);
    });

    it('同步解密_数据长度不足返回空', 0, () => {
      let shortData = genBytes(27); // 恰好小于 28
      let decrypted = CryptoUtil.decryptSync(shortData, KEY, AAD);
      expect(decrypted.length).assertEqual(0);
    });

    it('同步解密_AAD不匹配返回空', 0, () => {
      let plain = genBytes(32);
      let cipher = CryptoUtil.encryptSync(plain, KEY, IV, AAD);
      let wrongAad = genBytes(8, 255);
      let decrypted = CryptoUtil.decryptSync(cipher, KEY, wrongAad);
      expect(decrypted.length).assertEqual(0);
    });

    it('同步加密_不同IV产生不同密文', 0, () => {
      let plain = genBytes(48);
      let iv2 = genBytes(12, 150);
      let cipher1 = CryptoUtil.encryptSync(plain, KEY, IV, AAD);
      let cipher2 = CryptoUtil.encryptSync(plain, KEY, iv2, AAD);
      expect(bytesEquals(cipher1, cipher2)).assertFalse();
    });
  });
}