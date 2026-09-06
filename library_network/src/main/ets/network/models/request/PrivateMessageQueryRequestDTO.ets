/**
 * 私聊消息查询请求 DTO——描述查询私聊消息时的入参
 */
export interface PrivateMessageQueryRequestOptions {
  conversationId: number
  conversationType: number
  page: number
  size: number
}

export class PrivateMessageQueryRequestDTO {
  conversationId: number = 0
  conversationType: number = 1
  page: number = 0
  size: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 私聊消息查询字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: PrivateMessageQueryRequestOptions) {
    if (options) {
      this.conversationId = options.conversationId
      this.conversationType = options.conversationType
      this.page = options.page
      this.size = options.size
    }
  }
}
