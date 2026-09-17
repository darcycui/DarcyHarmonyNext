/**
 * DH 密钥交换工具类
 * 提供基于 X25519 曲线的 ECC 密钥对生成、编解码功能
 */
import { cryptoFramework } from '@kit.CryptoArchitectureKit'
import { Log } from 'static_library_common'

export class ECCExchangeUtil {
  private static readonly KEY_ALG = 'X25519'

  /**
   * 异步生成 X25519 密钥对
   * @returns 包含公钥和私钥的密钥对，异常时返回 null
   */
  static async generateKeyPair(): Promise<cryptoFramework.KeyPair | null> {
    try {
      let keyGen = cryptoFramework.createAsyKeyGenerator(ECCExchangeUtil.KEY_ALG)
      let keyPair = await keyGen.generateKeyPair()
      return keyPair
    } catch (error) {
      Log.error(`DHExchangeUtil.generateKeyPair 异常: ${JSON.stringify(error)}`)
      return null
    }
  }

  /**
   * 同步生成 X25519 密钥对
   * @returns 包含公钥和私钥的密钥对，异常时返回 null
   */
  static generateKeyPairSync(): cryptoFramework.KeyPair | null {
    try {
      let keyGen = cryptoFramework.createAsyKeyGenerator(ECCExchangeUtil.KEY_ALG)
      let keyPair = keyGen.generateKeyPairSync()
      return keyPair
    } catch (error) {
      Log.error(`DHExchangeUtil.generateKeyPairSync 异常: ${JSON.stringify(error)}`)
      return null
    }
  }

  /**
   * 密钥字节数组
   * @param key - X25519 密钥
   * @returns 密钥的 DER 编码字节数组，异常时返回空数组
   */
  static getKeyBytes(key: cryptoFramework.Key): Uint8Array {
    try {
      return key.getEncoded().data
    } catch (error) {
      Log.error(`DHExchangeUtil.getKeyBytes 异常: ${JSON.stringify(error)}`)
      return new Uint8Array()
    }
  }

  /**
   * 从字节数组恢复 X25519 公钥
   * @param pubKeyBytes - 公钥的 DER 编码字节
   * @returns 公钥对象，异常时返回 null
   */
  static createPubKey(pubKeyBytes: Uint8Array): cryptoFramework.PubKey | null {
    try {
      let keyGen = cryptoFramework.createAsyKeyGenerator(ECCExchangeUtil.KEY_ALG)
      let pubKeyBlob: cryptoFramework.DataBlob = { data: pubKeyBytes }
      let keyPair = keyGen.convertKeySync(pubKeyBlob, null)
      if (keyPair == null) {
        Log.error('DHExchangeUtil.createPubKey: keyPair is null')
        return null
      }
      return keyPair.pubKey
    } catch (error) {
      Log.error(`DHExchangeUtil.createPubKey 异常: ${JSON.stringify(error)}`)
      return null
    }
  }

  /**
   * 从字节数组恢复 X25519 私钥
   * @param priKeyBytes - 私钥的 DER 编码字节
   * @returns 私钥对象，异常时返回 null
   */
  static createPriKey(priKeyBytes: Uint8Array): cryptoFramework.PriKey | null {
    try {
      let keyGen = cryptoFramework.createAsyKeyGenerator(ECCExchangeUtil.KEY_ALG)
      let priKeyBlob: cryptoFramework.DataBlob = { data: priKeyBytes }
      let keyPair = keyGen.convertKeySync(null, priKeyBlob)
      if (keyPair == null) {
        Log.error('DHExchangeUtil.createPriKey: keyPair is null')
        return null
      }
      return keyPair.priKey
    } catch (error) {
      Log.error(`DHExchangeUtil.createPriKey 异常: ${JSON.stringify(error)}`)
      return null
    }
  }

  /**
   * 从字节数组恢复 X25519 密钥对（含私钥）
   * @param pubKeyBytes - 公钥的 DER 编码字节
   * @param priKeyBytes - 私钥的 DER 编码字节
   * @returns 密钥对对象，异常时返回 null
   */
  static createKeyPair(pubKeyBytes: Uint8Array, priKeyBytes: Uint8Array): cryptoFramework.KeyPair | null {
    try {
      let keyGen = cryptoFramework.createAsyKeyGenerator(ECCExchangeUtil.KEY_ALG)
      let pubKeyBlob: cryptoFramework.DataBlob = { data: pubKeyBytes }
      let priKeyBlob: cryptoFramework.DataBlob = { data: priKeyBytes }
      let keyPair = keyGen.convertKeySync(pubKeyBlob, priKeyBlob)
      return keyPair
    } catch (error) {
      Log.error(`DHExchangeUtil.createKeyPair 异常: ${JSON.stringify(error)}`)
      return null
    }
  }

  /**
   * 执行 DH 密钥协商（异步），基于本地密钥对与服务端公钥生成共享密钥
   *
   * 典型用法：
   * 1. 客户端调用 generateKeyPair() 生成本地密钥对
   * 2. 调用 getPubKeyBytes() 将本地公钥发送给服务端
   * 3. 服务端返回其公钥后，调用 createPubKey() 还原为 PubKey 对象
   * 4. 调用本方法协商出共享密钥，用于后续对称加密通信
   *
   * @param keyPair     - 本地生成的 X25519 密钥对（含私钥）
   * @param pubKey  - 对端（服务端）的公钥对象
   * @returns 协商出的共享密钥字节数组，异常时返回 null
   */
  static async getSharedSecretByPriKeyAndPubKey(
    priKey: cryptoFramework.PriKey,
    pubKey: cryptoFramework.PubKey
  ): Promise<Uint8Array> {
    try {
      let keyAgreement = cryptoFramework.createKeyAgreement(ECCExchangeUtil.KEY_ALG)
      let sharedSecret: cryptoFramework.DataBlob =
        await keyAgreement.generateSecret(priKey, pubKey)
      Log.log('DHExchangeUtil.getSharedSecret 成功')
      return sharedSecret.data
    } catch (error) {
      Log.error(`DHExchangeUtil.getSharedSecret 异常: ${JSON.stringify(error)}`)
      return new Uint8Array()
    }
  }

  static async getSharedSecretByUintArrays(
    priKeyHex: Uint8Array,
    pubKeyHex: Uint8Array
  ): Promise<Uint8Array> {
    const priKey = ECCExchangeUtil.createPriKey(priKeyHex)
    const peerPubKey = ECCExchangeUtil.createPubKey(pubKeyHex)
    Log.log('DHExchangeUtil.getSharedSecret 成功')
    if (priKey == null || peerPubKey == null) {
      Log.error('DHExchangeUtil.getSharedSecret 错误: priKey or peerPubKey is null')
      return new Uint8Array()
    }
    return await ECCExchangeUtil.getSharedSecretByPriKeyAndPubKey(priKey, peerPubKey)
  }
}
