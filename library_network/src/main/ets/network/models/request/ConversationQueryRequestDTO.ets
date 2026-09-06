/**
 * 会话查询请求 DTO——描述查询会话时的入参
 */
export interface ConversationQueryRequestOptions {
  conversationId: number
}

export class ConversationQueryRequestDTO {
  conversationId: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 会话查询请求字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: ConversationQueryRequestOptions) {
    if (options) {
      this.conversationId = options.conversationId
    }
  }
}
