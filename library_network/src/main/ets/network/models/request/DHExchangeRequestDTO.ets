/**
 * DH（Diffie-Hellman）密钥交换请求 DTO——描述客户端发起密钥交换时提交的入参
 */

/**
 * DH 密钥交换请求完整字段集合——作为构造器唯一入参
 */
export interface DHExchangeRequestDTOOptions {
  userId: number
  publicKey: string
}

export class DHExchangeRequestDTO {
  userId: number = 0
  publicKey: string = ""

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 完整 DH 交换字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: DHExchangeRequestDTOOptions) {
    if (options) {
      this.userId = options.userId
      this.publicKey = options.publicKey
    }
  }
}
