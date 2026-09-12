/**
 * 加解密工具类
 * 提供基于 AES-256-GCM 的 byte 数组加解密静态方法
 *
 * encrypt 输出格式：[IV(12字节)] + [密文] + [AuthTag(16字节)]
 * decrypt 输入格式：[IV(12字节)] + [密文] + [AuthTag(16字节)]
 * 密钥要求：32 字节（256 位）
 * IV 要求：12 字节
 */
import { cryptoFramework } from '@kit.CryptoArchitectureKit'
import { JSON } from '@kit.ArkTS'
import { Log } from 'static_library_common'

class EncryptedData {
  iv: Uint8Array = new Uint8Array()
  cipherText: Uint8Array = new Uint8Array()
  tag: Uint8Array = new Uint8Array()
}

export class CryptoUtil {
  private static readonly AES_ALG = 'AES256|GCM'
  private static readonly KEY_ALG = 'AES256'
  private static readonly IV_LENGTH = 12
  private static readonly TAG_LENGTH = 16

  /**
   * 根据密钥字节数组生成对称密钥
   */
  private static convertKey(keyData: Uint8Array): cryptoFramework.SymKey {
    let symKeyBlob: cryptoFramework.DataBlob = { data: keyData }
    let aesGenerator = cryptoFramework.createSymKeyGenerator(CryptoUtil.KEY_ALG)
    return aesGenerator.convertKeySync(symKeyBlob)
  }

  /**
   * 拼接 IV + 密文 + AuthTag
   */
  private static concatAll(iv: Uint8Array, cipherText: Uint8Array, tag: Uint8Array): Uint8Array {
    let result = new Uint8Array(iv.length + cipherText.length + tag.length)
    result.set(iv)
    result.set(cipherText, iv.length)
    result.set(tag, iv.length + cipherText.length)
    return result
  }

  /**
   * 从完整数据中分离 IV、密文、AuthTag
   */
  private static splitAll(data: Uint8Array): EncryptedData | null {
    if (data.length < CryptoUtil.IV_LENGTH + CryptoUtil.TAG_LENGTH) {
      return null
    }
    let result = new EncryptedData()
    result.iv = data.slice(0, CryptoUtil.IV_LENGTH)
    result.tag = data.slice(data.length - CryptoUtil.TAG_LENGTH)
    result.cipherText = data.slice(CryptoUtil.IV_LENGTH, data.length - CryptoUtil.TAG_LENGTH)
    return result
  }

  // ===================== 异步加解密 =====================

  /**
   * 异步加密 byte 数组（AES-256-GCM）
   * @param data  - 待加密的明文
   * @param key   - 密钥（32 字节）
   * @param iv    - 初始化向量（12 字节）
   * @param aad   - 附加认证数据（可为空数组）
   * @returns [IV(12B) + 密文 + AuthTag(16B)]，异常时返回空数组
   */
  static async encrypt(data: Uint8Array, key: Uint8Array, iv: Uint8Array, aad: Uint8Array): Promise<Uint8Array> {
    try {
      let symKey = CryptoUtil.convertKey(key)

      let gcmParams: cryptoFramework.GcmParamsSpec = {
        iv: { data: iv },
        aad: { data: aad },
        authTag: { data: new Uint8Array(CryptoUtil.TAG_LENGTH) },
        algName: 'GcmParamsSpec'
      }

      let cipher = cryptoFramework.createCipher(CryptoUtil.AES_ALG)
      await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, gcmParams)

      let plainText: cryptoFramework.DataBlob = { data: data }
      let cipherData = await cipher.update(plainText)

      let tagData = await cipher.doFinal(null)
      if (tagData == null) {
        Log.error('CryptoUtil.encrypt: authTag is null')
        return new Uint8Array()
      }

      let cipherBytes = cipherData != null ? cipherData.data : new Uint8Array()
      return CryptoUtil.concatAll(iv, cipherBytes, tagData.data)
    } catch (error) {
      Log.error(`CryptoUtil.encrypt 异常: ${JSON.stringify(error)}`)
      return new Uint8Array()
    }
  }

  /**
   * 异步解密 byte 数组（AES-256-GCM）
   * @param data  - [IV(12B) + 密文 + AuthTag(16B)]
   * @param key   - 密钥（32 字节）
   * @param aad   - 附加认证数据（须与加密时一致）
   * @returns 明文数据，异常时返回空数组
   */
  static async decrypt(data: Uint8Array, key: Uint8Array, aad: Uint8Array): Promise<Uint8Array> {
    try {
      let parts = CryptoUtil.splitAll(data)
      if (parts == null) {
        Log.error('CryptoUtil.decrypt 异常: 数据长度不足')
        return new Uint8Array()
      }

      let symKey = CryptoUtil.convertKey(key)

      let gcmParams: cryptoFramework.GcmParamsSpec = {
        iv: { data: parts.iv },
        aad: { data: aad },
        authTag: { data: parts.tag },
        algName: 'GcmParamsSpec'
      }

      let decoder = cryptoFramework.createCipher(CryptoUtil.AES_ALG)
      await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, gcmParams)

      let cipherText: cryptoFramework.DataBlob = { data: parts.cipherText }
      let plainData = await decoder.update(cipherText)

      await decoder.doFinal(null)

      return plainData != null ? plainData.data : new Uint8Array()
    } catch (error) {
      Log.error(`CryptoUtil.decrypt 异常: ${JSON.stringify(error)}`)
      return new Uint8Array()
    }
  }

  // ===================== 同步加解密 =====================

  /**
   * 同步加密 byte 数组（AES-256-GCM）
   * @param data  - 待加密的明文
   * @param key   - 密钥（32 字节）
   * @param iv    - 初始化向量（12 字节）
   * @param aad   - 附加认证数据（可为空数组）
   * @returns [IV(12B) + 密文 + AuthTag(16B)]，异常时返回空数组
   */
  static encryptSync(data: Uint8Array, key: Uint8Array, iv: Uint8Array, aad: Uint8Array): Uint8Array {
    try {
      let symKey = CryptoUtil.convertKey(key)

      let gcmParams: cryptoFramework.GcmParamsSpec = {
        iv: { data: iv },
        aad: { data: aad },
        authTag: { data: new Uint8Array(CryptoUtil.TAG_LENGTH) },
        algName: 'GcmParamsSpec'
      }

      let cipher = cryptoFramework.createCipher(CryptoUtil.AES_ALG)
      cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, gcmParams)

      let plainText: cryptoFramework.DataBlob = { data: data }
      let cipherData = cipher.updateSync(plainText)

      let tagData = cipher.doFinalSync(null)
      if (tagData == null) {
        Log.error('CryptoUtil.encryptSync: authTag is null')
        return new Uint8Array()
      }

      let cipherBytes = cipherData != null ? cipherData.data : new Uint8Array()
      return CryptoUtil.concatAll(iv, cipherBytes, tagData.data)
    } catch (error) {
      Log.error(`CryptoUtil.encryptSync 异常: ${JSON.stringify(error)}`)
      return new Uint8Array()
    }
  }

  /**
   * 同步解密 byte 数组（AES-256-GCM）
   * @param data  - [IV(12B) + 密文 + AuthTag(16B)]
   * @param key   - 密钥（32 字节）
   * @param aad   - 附加认证数据（须与加密时一致）
   * @returns 明文数据，异常时返回空数组
   */
  static decryptSync(data: Uint8Array, key: Uint8Array, aad: Uint8Array): Uint8Array {
    try {
      let parts = CryptoUtil.splitAll(data)
      if (parts == null) {
        Log.error('CryptoUtil.decryptSync 异常: 数据长度不足')
        return new Uint8Array()
      }

      let symKey = CryptoUtil.convertKey(key)

      let gcmParams: cryptoFramework.GcmParamsSpec = {
        iv: { data: parts.iv },
        aad: { data: aad },
        authTag: { data: parts.tag },
        algName: 'GcmParamsSpec'
      }

      let decoder = cryptoFramework.createCipher(CryptoUtil.AES_ALG)
      decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, gcmParams)

      let cipherText: cryptoFramework.DataBlob = { data: parts.cipherText }
      let plainData = decoder.updateSync(cipherText)

      decoder.doFinalSync(null)

      return plainData != null ? plainData.data : new Uint8Array()
    } catch (error) {
      Log.error(`CryptoUtil.decryptSync 异常: ${JSON.stringify(error)}`)
      return new Uint8Array()
    }
  }
}
