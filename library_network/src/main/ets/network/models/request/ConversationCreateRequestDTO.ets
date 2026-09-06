/**
 * 会话创建请求 DTO——描述创建新会话时的入参
 */
export interface ConversationCreateRequestOptions {
  userId: number
  targetId: number
  conversationType: number
}

export class ConversationCreateRequestDTO {
  userId: number = 0
  targetId: number = 0
  conversationType: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 会话创建请求字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: ConversationCreateRequestOptions) {
    if (options) {
      this.userId = options.userId
      this.targetId = options.targetId
      this.conversationType = options.conversationType
    }
  }
}
