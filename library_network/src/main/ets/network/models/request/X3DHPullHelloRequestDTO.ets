/**
 * X3DH Hello 消息拉取请求 DTO——描述 Bob 拉取 Alice 发来的 X3DH 初始握手消息时的入参
 */
export interface X3DHPullHelloRequestOptions {
  aliceUserId: number
  bobUserId: number
}

export class X3DHPullHelloRequestDTO {
  aliceUserId: number = 0
  bobUserId: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - X3DH Hello 拉取字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: X3DHPullHelloRequestOptions) {
    if (options) {
      this.aliceUserId = options.aliceUserId
      this.bobUserId = options.bobUserId
    }
  }
}
