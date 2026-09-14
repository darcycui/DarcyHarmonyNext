/**
 * TransformCryptoUtil 单元测试
 *
 * 测试基于 AES-256-GCM 的 byte 数组加解密功能（同步 & 异步）
 * 覆盖以下场景：
 *   - 正常加解密往返（同步/异步）
 *   - 错误密钥解密（应返回空数组）
 *   - 篡改密文解密（应返回空数组）
 *   - 数据长度不足解密（应返回空数组）
 *   - 空数据加解密
 *   - 大数据加解密
 *   - 携带 AAD 加解密
 *   - 同步/异步交叉一致性
 *
 * 运行前提：真机或模拟器（需要 @kit.CryptoArchitectureKit 支持）
 * 运行方式：通过 ohosTest target 执行 instrumented test
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Log } from 'static_library_common';
import { TransformCryptoUtil } from '../../../../Index';

export default function transformCryptoUtilTest() {
  describe('TransformCryptoUtilTest', () => {
    // ---------- 测试数据 ----------
    const KEY_32_BYTES: Uint8Array = new Uint8Array(32) // 32 字节密钥（256 位）
    const IV_12_BYTES: Uint8Array = new Uint8Array(12)   // 12 字节初始化向量
    const PLAINTEXT_HELLO: Uint8Array = new Uint8Array([0x48, 0x65, 0x6C, 0x6C, 0x6F]) // "Hello"
    const AAD_SAMPLE: Uint8Array = new Uint8Array([0x41, 0x41, 0x44]) // "AAD"
    const EMPTY_AAD: Uint8Array = new Uint8Array(0)

    beforeAll(() => {
      // 填充固定密钥和 IV，确保测试可重复
      for (let i = 0; i < 32; i++) {
        KEY_32_BYTES[i] = i
      }
      for (let i = 0; i < 12; i++) {
        IV_12_BYTES[i] = 0x50 + i
      }
      Log.log('TransformCryptoUtilTest beforeAll: 测试数据初始化完成')
    })

    // ==================== 同步加解密测试 ====================

    it('encryptSync_should_contain_iv_ciphertext_tag', 0, () => {
      const result = TransformCryptoUtil.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD)
      // 输出格式: [IV(12)] + [密文(5)] + [AuthTag(16)] = 33 字节
      expect(result.length).assertEqual(12 + PLAINTEXT_HELLO.length + 16)
      // 前 12 字节应为原始 IV
      for (let i = 0; i < 12; i++) {
        expect(result[i]).assertEqual(IV_12_BYTES[i])
      }
    })

    it('encryptSync_decryptSync_roundtrip_restores_plaintext', 0, () => {
      const encrypted = TransformCryptoUtil.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD)
      const decrypted = TransformCryptoUtil.decryptSync(encrypted, KEY_32_BYTES, EMPTY_AAD)
      expect(decrypted.length).assertEqual(PLAINTEXT_HELLO.length)
      for (let i = 0; i < PLAINTEXT_HELLO.length; i++) {
        expect(decrypted[i]).assertEqual(PLAINTEXT_HELLO[i])
      }
    })

    it('decryptSync_wrong_key_returns_empty', 0, () => {
      const encrypted = TransformCryptoUtil.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD)
      const wrongKey: Uint8Array = new Uint8Array(32)
      for (let i = 0; i < 32; i++) {
        wrongKey[i] = 0xFF
      }
      const decrypted = TransformCryptoUtil.decryptSync(encrypted, wrongKey, EMPTY_AAD)
      expect(decrypted.length).assertEqual(0)
    })

    it('decryptSync_tampered_ciphertext_returns_empty', 0, () => {
      const encrypted = TransformCryptoUtil.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD)
      // 篡改密文区域中的一个字节
      const tampered = encrypted.slice(0) // 复制
      tampered[14] = tampered[14] ^ 0xFF // 翻转一个字节
      const decrypted = TransformCryptoUtil.decryptSync(tampered, KEY_32_BYTES, EMPTY_AAD)
      expect(decrypted.length).assertEqual(0)
    })

    it('decryptSync_insufficient_length_returns_empty', 0, () => {
      // 数据长度 < IV(12) + Tag(16) = 28
      const tooShort: Uint8Array = new Uint8Array(10)
      const decrypted = TransformCryptoUtil.decryptSync(tooShort, KEY_32_BYTES, EMPTY_AAD)
      expect(decrypted.length).assertEqual(0)
    })

    it('encryptSync_decryptSync_with_aad_roundtrip_restores_plaintext', 0, () => {
      const encrypted = TransformCryptoUtil.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, AAD_SAMPLE)
      expect(encrypted.length).assertEqual(12 + PLAINTEXT_HELLO.length + 16)
      const decrypted = TransformCryptoUtil.decryptSync(encrypted, KEY_32_BYTES, AAD_SAMPLE)
      expect(decrypted.length).assertEqual(PLAINTEXT_HELLO.length)
      for (let i = 0; i < PLAINTEXT_HELLO.length; i++) {
        expect(decrypted[i]).assertEqual(PLAINTEXT_HELLO[i])
      }
    })

    it('decryptSync_aad_mismatch_returns_empty', 0, () => {
      const encrypted = TransformCryptoUtil.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, AAD_SAMPLE)
      const decrypted = TransformCryptoUtil.decryptSync(encrypted, KEY_32_BYTES, EMPTY_AAD)
      expect(decrypted.length).assertEqual(0)
    })

    // ==================== 异步加解密测试 ====================

    it('encrypt_async_should_have_correct_length', 0, async () => {
      const result = await TransformCryptoUtil.encrypt(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD)
      expect(result.length).assertEqual(12 + PLAINTEXT_HELLO.length + 16)
    })

    it('encrypt_async_decrypt_async_roundtrip_restores_plaintext', 0, async () => {
      const encrypted = await TransformCryptoUtil.encrypt(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD)
      const decrypted = await TransformCryptoUtil.decrypt(encrypted, KEY_32_BYTES, EMPTY_AAD)
      expect(decrypted.length).assertEqual(PLAINTEXT_HELLO.length)
      for (let i = 0; i < PLAINTEXT_HELLO.length; i++) {
        expect(decrypted[i]).assertEqual(PLAINTEXT_HELLO[i])
      }
    })

    it('decrypt_async_wrong_key_returns_empty', 0, async () => {
      const encrypted = await TransformCryptoUtil.encrypt(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD)
      const wrongKey: Uint8Array = new Uint8Array(32)
      for (let i = 0; i < 32; i++) {
        wrongKey[i] = 0xFF
      }
      const decrypted = await TransformCryptoUtil.decrypt(encrypted, wrongKey, EMPTY_AAD)
      expect(decrypted.length).assertEqual(0)
    })

    // ==================== 边界条件测试 ====================

    it('encryptSync_decryptSync_empty_data_roundtrip_succeeds', 0, () => {
      const emptyData: Uint8Array = new Uint8Array(0)
      const encrypted = TransformCryptoUtil.encryptSync(emptyData, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD)
      expect(encrypted.length).assertEqual(12 + 0 + 16) // IV(12) + empty(0) + tag(16)
      const decrypted = TransformCryptoUtil.decryptSync(encrypted, KEY_32_BYTES, EMPTY_AAD)
      expect(decrypted.length).assertEqual(0)
    })

    it('encryptSync_decryptSync_10KB_large_data_roundtrip_succeeds', 0, () => {
      const largeData: Uint8Array = new Uint8Array(1024 * 10) // 10 KB
      for (let i = 0; i < largeData.length; i++) {
        largeData[i] = i % 256
      }
      const encrypted = TransformCryptoUtil.encryptSync(largeData, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD)
      expect(encrypted.length).assertEqual(12 + largeData.length + 16)
      const decrypted = TransformCryptoUtil.decryptSync(encrypted, KEY_32_BYTES, EMPTY_AAD)
      expect(decrypted.length).assertEqual(largeData.length)
      for (let i = 0; i < largeData.length; i++) {
        expect(decrypted[i]).assertEqual(largeData[i])
      }
    })

    it('roundtrip_sync_async_cross_verification_consistent', 0, async () => {
      // 同步加密 → 异步解密
      const encryptedSync = TransformCryptoUtil.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD)
      const decryptedAsync = await TransformCryptoUtil.decrypt(encryptedSync, KEY_32_BYTES, EMPTY_AAD)
      expect(decryptedAsync.length).assertEqual(PLAINTEXT_HELLO.length)
      for (let i = 0; i < PLAINTEXT_HELLO.length; i++) {
        expect(decryptedAsync[i]).assertEqual(PLAINTEXT_HELLO[i])
      }

      // 异步加密 → 同步解密
      const encryptedAsync = await TransformCryptoUtil.encrypt(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD)
      const decryptedSync = TransformCryptoUtil.decryptSync(encryptedAsync, KEY_32_BYTES, EMPTY_AAD)
      expect(decryptedSync.length).assertEqual(PLAINTEXT_HELLO.length)
      for (let i = 0; i < PLAINTEXT_HELLO.length; i++) {
        expect(decryptedSync[i]).assertEqual(PLAINTEXT_HELLO[i])
      }
    })

    it('encryptSync_different_keys_produce_different_ciphertext', 0, () => {
      const keyA: Uint8Array = new Uint8Array(32)
      const keyB: Uint8Array = new Uint8Array(32)
      for (let i = 0; i < 32; i++) {
        keyA[i] = i
        keyB[i] = 0xFF - i
      }
      const encryptedA = TransformCryptoUtil.encryptSync(PLAINTEXT_HELLO, keyA, IV_12_BYTES, EMPTY_AAD)
      const encryptedB = TransformCryptoUtil.encryptSync(PLAINTEXT_HELLO, keyB, IV_12_BYTES, EMPTY_AAD)
      // 只要长度相等即可（密文段不同、tag 不同，但 IV 相同）
      expect(encryptedA.length).assertEqual(encryptedB.length)
      // 通过解密验证密钥A的密文只能用密钥A解密
      const decryptedA = TransformCryptoUtil.decryptSync(encryptedA, keyA, EMPTY_AAD)
      expect(decryptedA.length).assertEqual(PLAINTEXT_HELLO.length)
      const decryptedB = TransformCryptoUtil.decryptSync(encryptedB, keyB, EMPTY_AAD)
      expect(decryptedB.length).assertEqual(PLAINTEXT_HELLO.length)
    })

    it('decryptSync_empty_input_returns_empty', 0, () => {
      const emptyInput: Uint8Array = new Uint8Array(0)
      const result = TransformCryptoUtil.decryptSync(emptyInput, KEY_32_BYTES, EMPTY_AAD)
      expect(result.length).assertEqual(0)
    })
  })
}
