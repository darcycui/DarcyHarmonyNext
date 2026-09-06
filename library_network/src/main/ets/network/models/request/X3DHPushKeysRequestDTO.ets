/**
 * X3DH 密钥推送请求 DTO——描述客户端向服务端推送 X3DH 密钥材料的入参
 * 包含身份密钥(identityKey)、签名预密钥(signedPreKey)及一次性预密钥列表(oneTimePreKeys)
 */

// ──────────────────────────────────────────────
// OneTimePreKeyRequest（一次性预密钥）
// ──────────────────────────────────────────────

/**
 * 一次性预密钥请求完整字段集合——作为构造器唯一入参
 */
export interface OneTimePreKeyRequestDTOOptions {
  id: number
  keyId: string
  userId: number
  publicKey: string
}

export class OneTimePreKeyRequestDTO {
  id: number = 0
  keyId: string = ""
  userId: number = 0
  publicKey: string = ""

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 完整 OneTimePreKey 字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: OneTimePreKeyRequestDTOOptions) {
    if (options) {
      this.id = options.id
      this.keyId = options.keyId
      this.userId = options.userId
      this.publicKey = options.publicKey
    }
  }
}

// ──────────────────────────────────────────────
// X3DHPushKeysRequest（X3DH 密钥推送主请求）
// ──────────────────────────────────────────────

/**
 * X3DH 密钥推送请求完整字段集合——作为构造器唯一入参
 */
export interface X3DHPushKeysRequestDTOOptions {
  userId: number
  identityKey: string
  signedPreKey: string
  oneTimePreKeys: OneTimePreKeyRequestDTO[]
}

export class X3DHPushKeysRequestDTO {
  userId: number = 0
  identityKey: string = ""
  signedPreKey: string = ""
  oneTimePreKeys: OneTimePreKeyRequestDTO[] = []

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 完整 X3DH 密钥推送字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: X3DHPushKeysRequestDTOOptions) {
    if (options) {
      this.userId = options.userId
      this.identityKey = options.identityKey
      this.signedPreKey = options.signedPreKey
      this.oneTimePreKeys = options.oneTimePreKeys
    }
  }
}
