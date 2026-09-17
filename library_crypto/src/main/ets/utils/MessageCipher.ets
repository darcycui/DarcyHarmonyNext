/**
 * 消息加密工具类
 * 提供基于 AES-256-GCM + HMAC-SHA256 的消息加解密
 *
 * encrypt 输出格式：[HMAC-SHA256(32字节)] + [AES-GCM 密文]
 * decrypt 输入格式：[HMAC-SHA256(32字节)] + [AES-GCM 密文]
 *
 * 密钥要求：
 *   - key:   AES-256 加密密钥（32 字节）
 *   - macKey: HMAC-SHA256 签名密钥（32 字节）
 *   - nonce: 初始化向量（12 字节推荐）
 *
 * 与 TransportCipherUtil 的区别：
 *   - TransportCipherUtil 输出 [IV + Ciphertext + AuthTag]，GCM 自带认证
 *   - MessageCipher 输出 [HMAC + Ciphertext]，使用独立 HMAC + macKey 提供完整性保护
 */
import { cryptoFramework } from '@kit.CryptoArchitectureKit'
import { JSON } from '@kit.ArkTS'
import { HexUtil, Log } from 'static_library_common'
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil'

export class MessageCipher {
  private static readonly AES_ALG = 'AES256|GCM'
  private static readonly KEY_ALG = 'AES256'
  private static readonly IV_LENGTH = 12
  private static readonly HMAC_LENGTH = 32
  private static readonly TAG_LENGTH = 16

  /**
   * 生成随机 IV/nonce
   */
  static getIV(): Uint8Array {
    try {
      const rand = cryptoFramework.createRandom()
      return rand.generateRandomSync(MessageCipher.IV_LENGTH).data
    } catch (error) {
      ErrorUtil.logError(error)
    }
    return new Uint8Array()
  }

  /**
   * 将字节数组转换为 AES 对称密钥
   */
  private static convertAesKey(keyData: Uint8Array): cryptoFramework.SymKey {
    const symKeyBlob: cryptoFramework.DataBlob = { data: keyData }
    const aesGenerator = cryptoFramework.createSymKeyGenerator(MessageCipher.KEY_ALG)
    return aesGenerator.convertKeySync(symKeyBlob)
  }

  /**
   * 将字节数组转换为 HMAC 对称密钥
   */
  private static convertHmacKey(keyData: Uint8Array): cryptoFramework.SymKey {
    const symKeyBlob: cryptoFramework.DataBlob = { data: keyData }
    const hmacGenerator = cryptoFramework.createSymKeyGenerator('HMAC')
    return hmacGenerator.convertKeySync(symKeyBlob)
  }

  /**
   * 计算 HMAC-SHA256
   *
   * @param keyBytes  密钥字节数组（32 字节）
   * @param data      待签名数据
   * @returns         HMAC-SHA256 结果（32 字节）
   */
  private static hmacSha256(keyBytes: Uint8Array, data: Uint8Array): Uint8Array {
    const symKey = MessageCipher.convertHmacKey(keyBytes)
    const mac = cryptoFramework.createMac('SHA256')
    mac.initSync(symKey)
    mac.updateSync({ data: data } as cryptoFramework.DataBlob)
    const result = mac.doFinalSync()
    return result.data
  }

  /**
   * 验证 HMAC-SHA256（常量时间比较）
   *
   * @param keyBytes  密钥字节数组
   * @param data      原始数据
   * @param expected  期望的 HMAC 值
   * @returns         验证是否通过
   */
  private static hmacVerify(keyBytes: Uint8Array, data: Uint8Array, expected: Uint8Array): boolean {
    const computed = MessageCipher.hmacSha256(keyBytes, data)
    if (computed.length !== expected.length) {
      return false
    }
    let diff = 0
    for (let i = 0; i < computed.length; i++) {
      diff |= computed[i] ^ expected[i]
    }
    return diff === 0
  }

  /**
   * AES-GCM 加密（内部方法）
   */
  private static aesGcmEncrypt(
    data: Uint8Array, key: Uint8Array, nonce: Uint8Array, aad: Uint8Array
  ): Uint8Array {
    const symKey = MessageCipher.convertAesKey(key)

    const gcmParams: cryptoFramework.GcmParamsSpec = {
      iv: { data: nonce },
      aad: { data: aad },
      authTag: { data: new Uint8Array(MessageCipher.TAG_LENGTH) },
      algName: 'GcmParamsSpec'
    }

    const cipher = cryptoFramework.createCipher(MessageCipher.AES_ALG)
    cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, gcmParams)

    const plainText: cryptoFramework.DataBlob = { data: data }
    const cipherData = cipher.updateSync(plainText)

    const tagData = cipher.doFinalSync(null)
    if (tagData == null) {
      Log.error('MessageCipher.aesGcmEncrypt: authTag is null')
      return new Uint8Array()
    }

    const cipherBytes = cipherData != null ? cipherData.data : new Uint8Array()
    return MessageCipher.concatBytes(cipherBytes, tagData.data)
  }

  /**
   * AES-GCM 解密（内部方法）
   */
  private static aesGcmDecrypt(
    cipherWithTag: Uint8Array, key: Uint8Array, nonce: Uint8Array, aad: Uint8Array
  ): Uint8Array {
    const symKey = MessageCipher.convertAesKey(key)

    const cipherText = cipherWithTag.slice(0, cipherWithTag.length - MessageCipher.TAG_LENGTH)
    const authTag = cipherWithTag.slice(cipherWithTag.length - MessageCipher.TAG_LENGTH)

    const gcmParams: cryptoFramework.GcmParamsSpec = {
      iv: { data: nonce },
      aad: { data: aad },
      authTag: { data: authTag },
      algName: 'GcmParamsSpec'
    }

    const decoder = cryptoFramework.createCipher(MessageCipher.AES_ALG)
    decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, gcmParams)

    const cipherBlob: cryptoFramework.DataBlob = { data: cipherText }
    const plainData = decoder.updateSync(cipherBlob)

    decoder.doFinalSync(null)

    return plainData != null ? plainData.data : new Uint8Array()
  }

  /**
   * 拼接两个字节数组
   */
  private static concatBytes(a: Uint8Array, b: Uint8Array): Uint8Array {
    const result = new Uint8Array(a.length + b.length)
    result.set(a, 0)
    result.set(b, a.length)
    return result
  }

  // ===================== 异步加解密 =====================

  /**
   * 异步加密（AES-256-GCM + HMAC-SHA256）
   *
   * @param data   - 待加密的明文
   * @param key    - AES 加密密钥（32 字节）
   * @param nonce  - 初始化向量（12 字节）
   * @param aad    - 附加认证数据（可为空数组）
   * @param macKey - HMAC 签名密钥（32 字节）
   * @returns [HMAC(32B) + 密文]，异常时返回空数组
   */
  static async encrypt(
    data: Uint8Array, key: Uint8Array, nonce: Uint8Array, aad: Uint8Array, macKey: Uint8Array
  ): Promise<Uint8Array> {
    try {
      Log.log('MessageCipher.encrypt 加密...')
      Log.log(`明文长度: ${data.length}`)
      Log.log(`加密key: ${HexUtil.bytesToHex(key)}`)
      Log.log(`加密nonce: ${HexUtil.bytesToHex(nonce)}`)
      Log.log(`加密aad: ${HexUtil.bytesToHex(aad)}`)
      Log.log(`加密macKey: ${HexUtil.bytesToHex(macKey)}`)

      // AES-GCM 加密：密文 = ciphertext + authTag
      const cipherWithTag = MessageCipher.aesGcmEncrypt(data, key, nonce, aad)
      if (cipherWithTag.length === 0) {
        Log.error('MessageCipher.encrypt: AES-GCM 加密失败')
        return new Uint8Array()
      }
      Log.log(`AES-GCM 密文长度: ${cipherWithTag.length}`)

      // HMAC-SHA256 签名：hmac(nonce + cipherWithTag)
      const hmacData = MessageCipher.concatBytes(nonce, cipherWithTag)
      const hmac = MessageCipher.hmacSha256(macKey, hmacData)
      Log.log(`HMAC: ${HexUtil.bytesToHex(hmac)}`)

      // 输出：HMAC(32B) + ciphertext+tag
      return MessageCipher.concatBytes(hmac, cipherWithTag)
    } catch (error) {
      Log.error(`MessageCipher.encrypt 异常: ${JSON.stringify(error)}`)
      return new Uint8Array()
    }
  }

  /**
   * 异步解密（AES-256-GCM + HMAC-SHA256）
   *
   * @param data   - [HMAC(32B) + 密文]
   * @param key    - AES 解密密钥（32 字节）
   * @param nonce  - 初始化向量（须与加密时一致）
   * @param aad    - 附加认证数据（须与加密时一致）
   * @param macKey - HMAC 签名密钥（32 字节）
   * @returns 明文数据，异常或校验失败时返回空数组
   */
  static async decrypt(
    data: Uint8Array, key: Uint8Array, nonce: Uint8Array, aad: Uint8Array, macKey: Uint8Array
  ): Promise<Uint8Array> {
    try {
      Log.log('MessageCipher.decrypt 解密...')
      Log.log(`密文长度: ${data.length}`)
      Log.log(`解密key: ${HexUtil.bytesToHex(key)}`)
      Log.log(`解密nonce: ${HexUtil.bytesToHex(nonce)}`)
      Log.log(`解密aad: ${HexUtil.bytesToHex(aad)}`)
      Log.log(`解密macKey: ${HexUtil.bytesToHex(macKey)}`)

      // 数据长度校验：至少 HMAC(32) + GCM Tag(16) = 48
      if (data.length < MessageCipher.HMAC_LENGTH + MessageCipher.TAG_LENGTH) {
        Log.error('MessageCipher.decrypt: 数据长度不足')
        return new Uint8Array()
      }

      // 分离 HMAC 和 ciphertext+tag
      const expectedHmac = data.slice(0, MessageCipher.HMAC_LENGTH)
      const cipherWithTag = data.slice(MessageCipher.HMAC_LENGTH)
      Log.log(`expectedHmac: ${HexUtil.bytesToHex(expectedHmac)}`)

      // HMAC 校验
      const hmacData = MessageCipher.concatBytes(nonce, cipherWithTag)
      if (!MessageCipher.hmacVerify(macKey, hmacData, expectedHmac)) {
        Log.error('MessageCipher.decrypt: HMAC 校验失败')
        return new Uint8Array()
      }
      Log.log('HMAC 校验成功')

      // AES-GCM 解密
      const plaintext = MessageCipher.aesGcmDecrypt(cipherWithTag, key, nonce, aad)
      Log.log(`解密后长度: ${plaintext.length}`)
      return plaintext
    } catch (error) {
      Log.error(`MessageCipher.decrypt 异常: ${JSON.stringify(error)}`)
      return new Uint8Array()
    }
  }

  // ===================== 同步加解密 =====================

  /**
   * 同步加密（AES-256-GCM + HMAC-SHA256）
   *
   * @param data   - 待加密的明文
   * @param key    - AES 加密密钥（32 字节）
   * @param nonce  - 初始化向量（12 字节）
   * @param aad    - 附加认证数据（可为空数组）
   * @param macKey - HMAC 签名密钥（32 字节）
   * @returns [HMAC(32B) + 密文]，异常时返回空数组
   */
  static encryptSync(
    data: Uint8Array, key: Uint8Array, nonce: Uint8Array, aad: Uint8Array, macKey: Uint8Array
  ): Uint8Array {
    try {
      Log.log('MessageCipher.encryptSync 加密...')
      Log.log(`明文长度: ${data.length}`)
      Log.log(`加密key: ${HexUtil.bytesToHex(key)}`)
      Log.log(`加密nonce: ${HexUtil.bytesToHex(nonce)}`)
      Log.log(`加密aad: ${HexUtil.bytesToHex(aad)}`)
      Log.log(`加密macKey: ${HexUtil.bytesToHex(macKey)}`)

      // AES-GCM 加密
      const cipherWithTag = MessageCipher.aesGcmEncrypt(data, key, nonce, aad)
      if (cipherWithTag.length === 0) {
        Log.error('MessageCipher.encryptSync: AES-GCM 加密失败')
        return new Uint8Array()
      }
      Log.log(`AES-GCM 密文长度: ${cipherWithTag.length}`)

      // HMAC-SHA256 签名
      const hmacData = MessageCipher.concatBytes(nonce, cipherWithTag)
      const hmac = MessageCipher.hmacSha256(macKey, hmacData)
      Log.log(`HMAC: ${HexUtil.bytesToHex(hmac)}`)

      // 输出：HMAC(32B) + ciphertext+tag
      return MessageCipher.concatBytes(hmac, cipherWithTag)
    } catch (error) {
      Log.error(`MessageCipher.encryptSync 异常: ${ErrorUtil.getErrorMessage(error)}`)
      return new Uint8Array()
    }
  }

  /**
   * 同步解密（AES-256-GCM + HMAC-SHA256）
   *
   * @param data   - [HMAC(32B) + 密文]
   * @param key    - AES 解密密钥（32 字节）
   * @param nonce  - 初始化向量（须与加密时一致）
   * @param aad    - 附加认证数据（须与加密时一致）
   * @param macKey - HMAC 签名密钥（32 字节）
   * @returns 明文数据，异常或校验失败时返回空数组
   */
  static decryptSync(
    data: Uint8Array, key: Uint8Array, nonce: Uint8Array, aad: Uint8Array, macKey: Uint8Array
  ): Uint8Array {
    try {
      Log.log('MessageCipher.decryptSync 解密...')
      Log.log(`密文长度: ${data.length}`)
      Log.log(`解密key: ${HexUtil.bytesToHex(key)}`)
      Log.log(`解密nonce: ${HexUtil.bytesToHex(nonce)}`)
      Log.log(`解密aad: ${HexUtil.bytesToHex(aad)}`)
      Log.log(`解密macKey: ${HexUtil.bytesToHex(macKey)}`)

      // 数据长度校验
      if (data.length < MessageCipher.HMAC_LENGTH + MessageCipher.TAG_LENGTH) {
        Log.error('MessageCipher.decryptSync: 数据长度不足')
        return new Uint8Array()
      }

      // 分离 HMAC 和 ciphertext+tag
      const expectedHmac = data.slice(0, MessageCipher.HMAC_LENGTH)
      const cipherWithTag = data.slice(MessageCipher.HMAC_LENGTH)
      Log.log(`expectedHmac: ${HexUtil.bytesToHex(expectedHmac)}`)

      // HMAC 校验
      const hmacData = MessageCipher.concatBytes(nonce, cipherWithTag)
      if (!MessageCipher.hmacVerify(macKey, hmacData, expectedHmac)) {
        Log.error('MessageCipher.decryptSync: HMAC 校验失败')
        return new Uint8Array()
      }
      Log.log('HMAC 校验成功')

      // AES-GCM 解密
      const plaintext = MessageCipher.aesGcmDecrypt(cipherWithTag, key, nonce, aad)
      Log.log(`解密后长度: ${plaintext.length}`)
      return plaintext
    } catch (error) {
      Log.error(`MessageCipher.decryptSync 异常: ${ErrorUtil.getErrorMessage(error)}`)
      return new Uint8Array()
    }
  }
}
