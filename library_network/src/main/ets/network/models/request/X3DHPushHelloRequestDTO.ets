/**
 * X3DH Hello 消息推送请求 DTO——描述 Alice 向服务端推送 X3DH 初始握手消息时的入参
 * 包含 Alice 的身份密钥、临时密钥以及要使用的 Bob 一次性预密钥 ID
 */
export interface X3DHPushHelloRequestOptions {
  aliceUserId: number
  bobUserId: number
  aliceIdentityKey: string
  aliceEphemeralKey: string
  bobOneTimePreKeyId: string
}

export class X3DHPushHelloRequestDTO {
  aliceUserId: number = 0
  bobUserId: number = 0
  aliceIdentityKey: string = ""
  aliceEphemeralKey: string = ""
  bobOneTimePreKeyId: string = ""

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - X3DH Hello 推送字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: X3DHPushHelloRequestOptions) {
    if (options) {
      this.aliceUserId = options.aliceUserId
      this.bobUserId = options.bobUserId
      this.aliceIdentityKey = options.aliceIdentityKey
      this.aliceEphemeralKey = options.aliceEphemeralKey
      this.bobOneTimePreKeyId = options.bobOneTimePreKeyId
    }
  }
}
