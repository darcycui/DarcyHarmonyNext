// ============================================================
// DHExchangeUtil 仪器化测试（X25519 密钥交换）
// 覆盖：密钥对生成、DER 编解码还原、双端密钥协商一致性、异常输入
// 说明：
//   1. 被测类位于 library_crypto HAR，测试通过宿主 HAP（entry）在模拟器/真机上运行；
//   2. 本地测试环境（src/test）的 cryptoFramework 为桩实现，无法验证真实密钥协商。
// ============================================================
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
// 库内相对导入（测试文件位于库自身包内，不能 import 'library_crypto' 自引用，否则类型退化为 any）
import { DHExchangeUtil } from '../../../main/ets/utils/DHExchangeUtil';

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

export default function testDHExchangeUtil() {
  describe('DHExchangeUtilTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    // ===================== 密钥对生成 =====================

    it('异步生成X25519密钥对_非空', 0, async () => {
      let keyPair = await DHExchangeUtil.generateKeyPair();
      expect(keyPair !== null).assertTrue();
    });

    it('同步生成X25519密钥对_非空', 0, () => {
      let keyPair = DHExchangeUtil.generateKeyPairSync();
      expect(keyPair !== null).assertTrue();
    });

    // ===================== 密钥编解码还原 =====================

    it('公钥字节编码_非空DER数据', 0, () => {
      let keyPair = DHExchangeUtil.generateKeyPairSync();
      expect(keyPair !== null).assertTrue();
      if (keyPair !== null) {
        let pubBytes = DHExchangeUtil.getKeyBytes(keyPair.pubKey);
        expect(pubBytes.length > 0).assertTrue();
      }
    });

    it('私钥字节编码_非空DER数据', 0, () => {
      let keyPair = DHExchangeUtil.generateKeyPairSync();
      expect(keyPair !== null).assertTrue();
      if (keyPair !== null) {
        let priBytes = DHExchangeUtil.getKeyBytes(keyPair.priKey);
        expect(priBytes.length > 0).assertTrue();
      }
    });

    it('公钥还原_字节转公钥对象成功', 0, () => {
      let keyPair = DHExchangeUtil.generateKeyPairSync();
      expect(keyPair !== null).assertTrue();
      if (keyPair !== null) {
        let pubBytes = DHExchangeUtil.getKeyBytes(keyPair.pubKey);
        let restored = DHExchangeUtil.createPubKey(pubBytes);
        expect(restored !== null).assertTrue();
      }
    });

    it('密钥对还原_公钥私钥字节转密钥对成功', 0, () => {
      let keyPair = DHExchangeUtil.generateKeyPairSync();
      expect(keyPair !== null).assertTrue();
      if (keyPair !== null) {
        let pubBytes = DHExchangeUtil.getKeyBytes(keyPair.pubKey);
        let priBytes = DHExchangeUtil.getKeyBytes(keyPair.priKey);
        let restored = DHExchangeUtil.createKeyPair(pubBytes, priBytes);
        expect(restored !== null).assertTrue();
      }
    });

    it('公钥还原_非法字节返回空', 0, () => {
      let invalidBytes = new Uint8Array([1, 2, 3]);
      let restored = DHExchangeUtil.createPubKey(invalidBytes);
      expect(restored === null).assertTrue();
    });

    it('密钥对还原_非法字节返回空', 0, () => {
      let invalidPub = new Uint8Array([1, 2, 3]);
      let invalidPri = new Uint8Array([4, 5, 6]);
      let restored = DHExchangeUtil.createKeyPair(invalidPub, invalidPri);
      expect(restored === null).assertTrue();
    });

    // ===================== 密钥协商 =====================

    it('DH密钥协商_双端共享密钥一致', 0, async () => {
      // Alice 生成密钥对
      let aliceKeyPair = await DHExchangeUtil.generateKeyPair();
      expect(aliceKeyPair !== null).assertTrue();
      // Bob 生成密钥对
      let bobKeyPair = await DHExchangeUtil.generateKeyPair();
      expect(bobKeyPair !== null).assertTrue();

      if (aliceKeyPair !== null && bobKeyPair !== null) {
        // Alice 用 Bob 的公钥协商
        let aliceSecret = await DHExchangeUtil.agreeSharedSecret(aliceKeyPair.priKey, bobKeyPair.pubKey);
        expect(aliceSecret !== null).assertTrue();
        // Bob 用 Alice 的公钥协商
        let bobSecret = await DHExchangeUtil.agreeSharedSecret(bobKeyPair.priKey, aliceKeyPair.pubKey);
        expect(bobSecret !== null).assertTrue();

        if (aliceSecret !== null && bobSecret !== null) {
          // X25519 共享密钥固定 32 字节
          expect(aliceSecret.length).assertEqual(32);
          expect(bobSecret.length).assertEqual(32);
          // 双端协商结果必须一致
          expect(bytesEquals(aliceSecret, bobSecret)).assertTrue();
        }
      }
    });

    it('DH密钥协商_同一密钥对两次协商结果一致', 0, async () => {
      let aliceKeyPair = await DHExchangeUtil.generateKeyPair();
      let bobKeyPair = await DHExchangeUtil.generateKeyPair();
      expect(aliceKeyPair !== null).assertTrue();
      expect(bobKeyPair !== null).assertTrue();

      if (aliceKeyPair !== null && bobKeyPair !== null) {
        let secret1 = await DHExchangeUtil.agreeSharedSecret(aliceKeyPair.priKey, bobKeyPair.pubKey);
        let secret2 = await DHExchangeUtil.agreeSharedSecret(aliceKeyPair.priKey, bobKeyPair.pubKey);
        expect(secret1 !== null).assertTrue();
        expect(secret2 !== null).assertTrue();
        if (secret1 !== null && secret2 !== null) {
          expect(bytesEquals(secret1, secret2)).assertTrue();
        }
      }
    });
  });
}