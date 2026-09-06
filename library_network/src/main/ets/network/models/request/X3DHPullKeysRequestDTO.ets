/**
 * X3DH 拉取密钥请求 DTO——描述客户端拉取对方 X3DH 密钥材料时的入参
 */
export interface X3DHPullKeysRequestOptions {
  aliceUserId: number
  bobUserId: number
}

export class X3DHPullKeysRequestDTO {
  aliceUserId: number = 0
  bobUserId: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - X3DH 拉取密钥字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: X3DHPullKeysRequestOptions) {
    if (options) {
      this.aliceUserId = options.aliceUserId
      this.bobUserId = options.bobUserId
    }
  }
}
