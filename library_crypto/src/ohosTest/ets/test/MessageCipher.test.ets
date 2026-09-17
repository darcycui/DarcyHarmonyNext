/**
 * MessageCipher 单元测试
 *
 * 测试基于 AES-256-GCM + HMAC-SHA256 的消息加解密功能（同步 & 异步）
 * 覆盖以下场景：
 *   - 正常加解密往返（同步/异步）
 *   - 输出格式验证（HMAC + ciphertext）
 *   - 错误密钥解密（应返回空数组）
 *   - 错误 macKey 解密（HMAC 校验失败，应返回空数组）
 *   - 篡改密文解密（应返回空数组）
 *   - 篡改 HMAC 解密（应返回空数组）
 *   - 数据长度不足解密（应返回空数组）
 *   - 空数据加解密
 *   - 大数据加解密
 *   - 携带 AAD 加解密
 *   - 同步/异步交叉一致性
 *
 * 运行前提：真机或模拟器（需要 @kit.CryptoArchitectureKit 支持）
 * 运行方式：通过 ohosTest target 执行 instrumented test
 */
import { describe, beforeAll, it, expect } from '@ohos/hypium';
import { Log } from 'static_library_common';
import { MessageCipher } from '../../../../Index';

export default function messageCipherTest() {
  describe('MessageCipherTest', () => {
    const HMAC_LENGTH = 32
    const TAG_LENGTH = 16
    const IV_LENGTH = 12

    const KEY_32_BYTES: Uint8Array = new Uint8Array(32)
    const MAC_KEY_32_BYTES: Uint8Array = new Uint8Array(32)
    const IV_12_BYTES: Uint8Array = new Uint8Array(12)
    const PLAINTEXT_HELLO: Uint8Array = new Uint8Array([0x48, 0x65, 0x6C, 0x6C, 0x6F]) // "Hello"
    const AAD_SAMPLE: Uint8Array = new Uint8Array([0x41, 0x41, 0x44]) // "AAD"
    const EMPTY_AAD: Uint8Array = new Uint8Array(0)

    beforeAll(() => {
      for (let i = 0; i < 32; i++) {
        KEY_32_BYTES[i] = i
        MAC_KEY_32_BYTES[i] = 0xFF - i
      }
      for (let i = 0; i < IV_LENGTH; i++) {
        IV_12_BYTES[i] = 0x50 + i
      }
      Log.log('MessageCipherTest beforeAll: 测试数据初始化完成')
    })

    // ==================== 同步加解密测试 ====================

    it('encryptSync_output_format_hmac_plus_ciphertext', 0, () => {
      const result = MessageCipher.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      // 输出格式: [HMAC(32)] + [ciphertext(5) + GCM-Tag(16)] = 53 字节
      expect(result.length).assertEqual(HMAC_LENGTH + PLAINTEXT_HELLO.length + TAG_LENGTH)
    })

    it('encryptSync_decryptSync_roundtrip_restores_plaintext', 0, () => {
      const encrypted = MessageCipher.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      const decrypted = MessageCipher.decryptSync(encrypted, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decrypted.length).assertEqual(PLAINTEXT_HELLO.length)
      for (let i = 0; i < PLAINTEXT_HELLO.length; i++) {
        expect(decrypted[i]).assertEqual(PLAINTEXT_HELLO[i])
      }
    })

    it('decryptSync_wrong_key_returns_empty', 0, () => {
      const encrypted = MessageCipher.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      const wrongKey: Uint8Array = new Uint8Array(32)
      for (let i = 0; i < 32; i++) {
        wrongKey[i] = 0xFF
      }
      const decrypted = MessageCipher.decryptSync(encrypted, wrongKey, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decrypted.length).assertEqual(0)
    })

    it('decryptSync_wrong_macKey_returns_empty', 0, () => {
      const encrypted = MessageCipher.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      const wrongMacKey: Uint8Array = new Uint8Array(32)
      for (let i = 0; i < 32; i++) {
        wrongMacKey[i] = 0xAA
      }
      const decrypted = MessageCipher.decryptSync(encrypted, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, wrongMacKey)
      expect(decrypted.length).assertEqual(0)
    })

    it('decryptSync_tampered_ciphertext_returns_empty', 0, () => {
      const encrypted = MessageCipher.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      const tampered = encrypted.slice(0)
      tampered[HMAC_LENGTH + 2] = tampered[HMAC_LENGTH + 2] ^ 0xFF
      const decrypted = MessageCipher.decryptSync(tampered, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decrypted.length).assertEqual(0)
    })

    it('decryptSync_tampered_hmac_returns_empty', 0, () => {
      const encrypted = MessageCipher.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      const tampered = encrypted.slice(0)
      tampered[0] = tampered[0] ^ 0xFF
      const decrypted = MessageCipher.decryptSync(tampered, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decrypted.length).assertEqual(0)
    })

    it('decryptSync_insufficient_length_returns_empty', 0, () => {
      const tooShort: Uint8Array = new Uint8Array(10)
      const decrypted = MessageCipher.decryptSync(tooShort, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decrypted.length).assertEqual(0)
    })

    it('encryptSync_decryptSync_with_aad_roundtrip_restores_plaintext', 0, () => {
      const encrypted = MessageCipher.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, AAD_SAMPLE, MAC_KEY_32_BYTES)
      expect(encrypted.length).assertEqual(HMAC_LENGTH + PLAINTEXT_HELLO.length + TAG_LENGTH)
      const decrypted = MessageCipher.decryptSync(encrypted, KEY_32_BYTES, IV_12_BYTES, AAD_SAMPLE, MAC_KEY_32_BYTES)
      expect(decrypted.length).assertEqual(PLAINTEXT_HELLO.length)
      for (let i = 0; i < PLAINTEXT_HELLO.length; i++) {
        expect(decrypted[i]).assertEqual(PLAINTEXT_HELLO[i])
      }
    })

    it('decryptSync_aad_mismatch_returns_empty', 0, () => {
      const encrypted = MessageCipher.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, AAD_SAMPLE, MAC_KEY_32_BYTES)
      const decrypted = MessageCipher.decryptSync(encrypted, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decrypted.length).assertEqual(0)
    })

    // ==================== 异步加解密测试 ====================

    it('encrypt_async_output_format_hmac_plus_ciphertext', 0, async () => {
      const result = await MessageCipher.encrypt(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(result.length).assertEqual(HMAC_LENGTH + PLAINTEXT_HELLO.length + TAG_LENGTH)
    })

    it('encrypt_async_decrypt_async_roundtrip_restores_plaintext', 0, async () => {
      const encrypted = await MessageCipher.encrypt(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      const decrypted = await MessageCipher.decrypt(encrypted, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decrypted.length).assertEqual(PLAINTEXT_HELLO.length)
      for (let i = 0; i < PLAINTEXT_HELLO.length; i++) {
        expect(decrypted[i]).assertEqual(PLAINTEXT_HELLO[i])
      }
    })

    it('decrypt_async_wrong_key_returns_empty', 0, async () => {
      const encrypted = await MessageCipher.encrypt(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      const wrongKey: Uint8Array = new Uint8Array(32)
      for (let i = 0; i < 32; i++) {
        wrongKey[i] = 0xFF
      }
      const decrypted = await MessageCipher.decrypt(encrypted, wrongKey, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decrypted.length).assertEqual(0)
    })

    it('decrypt_async_wrong_macKey_returns_empty', 0, async () => {
      const encrypted = await MessageCipher.encrypt(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      const wrongMacKey: Uint8Array = new Uint8Array(32)
      for (let i = 0; i < 32; i++) {
        wrongMacKey[i] = 0xAA
      }
      const decrypted = await MessageCipher.decrypt(encrypted, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, wrongMacKey)
      expect(decrypted.length).assertEqual(0)
    })

    // ==================== 边界条件测试 ====================

    it('encryptSync_decryptSync_empty_data_roundtrip_succeeds', 0, () => {
      const emptyData: Uint8Array = new Uint8Array(0)
      const encrypted = MessageCipher.encryptSync(emptyData, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(encrypted.length).assertEqual(HMAC_LENGTH + 0 + TAG_LENGTH)
      const decrypted = MessageCipher.decryptSync(encrypted, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decrypted.length).assertEqual(0)
    })

    it('encryptSync_decryptSync_10KB_large_data_roundtrip_succeeds', 0, () => {
      const largeData: Uint8Array = new Uint8Array(1024 * 10)
      for (let i = 0; i < largeData.length; i++) {
        largeData[i] = i % 256
      }
      const encrypted = MessageCipher.encryptSync(largeData, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(encrypted.length).assertEqual(HMAC_LENGTH + largeData.length + TAG_LENGTH)
      const decrypted = MessageCipher.decryptSync(encrypted, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decrypted.length).assertEqual(largeData.length)
      for (let i = 0; i < largeData.length; i++) {
        expect(decrypted[i]).assertEqual(largeData[i])
      }
    })

    it('roundtrip_sync_async_cross_verification_consistent', 0, async () => {
      // 同步加密 -> 异步解密
      const encryptedSync = MessageCipher.encryptSync(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      const decryptedAsync = await MessageCipher.decrypt(encryptedSync, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decryptedAsync.length).assertEqual(PLAINTEXT_HELLO.length)
      for (let i = 0; i < PLAINTEXT_HELLO.length; i++) {
        expect(decryptedAsync[i]).assertEqual(PLAINTEXT_HELLO[i])
      }

      // 异步加密 -> 同步解密
      const encryptedAsync = await MessageCipher.encrypt(PLAINTEXT_HELLO, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      const decryptedSync = MessageCipher.decryptSync(encryptedAsync, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(decryptedSync.length).assertEqual(PLAINTEXT_HELLO.length)
      for (let i = 0; i < PLAINTEXT_HELLO.length; i++) {
        expect(decryptedSync[i]).assertEqual(PLAINTEXT_HELLO[i])
      }
    })

    it('decryptSync_empty_input_returns_empty', 0, () => {
      const emptyInput: Uint8Array = new Uint8Array(0)
      const result = MessageCipher.decryptSync(emptyInput, KEY_32_BYTES, IV_12_BYTES, EMPTY_AAD, MAC_KEY_32_BYTES)
      expect(result.length).assertEqual(0)
    })

    it('getIV_returns_12_bytes', 0, () => {
      const iv = MessageCipher.getIV()
      expect(iv.length).assertEqual(IV_LENGTH)
    })

    it('getIV_returns_unique_values', 0, () => {
      const iv1 = MessageCipher.getIV()
      const iv2 = MessageCipher.getIV()
      let same = true
      for (let i = 0; i < iv1.length; i++) {
        if (iv1[i] !== iv2[i]) {
          same = false
          break
        }
      }
      expect(same).assertEqual(false)
    })
  })
}
