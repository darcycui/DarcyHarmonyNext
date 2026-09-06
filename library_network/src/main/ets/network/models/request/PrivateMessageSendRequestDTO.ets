/**
 * 私聊消息发送请求 DTO——描述发送私聊消息时的入参
 */
export interface PrivateMessageSendRequestOptions {
  senderId: number
  receiverId: number
  conversationId: number
  content: string
  msgId: string
}

export class PrivateMessageSendRequestDTO {
  senderId: number = 0
  receiverId: number = 0
  conversationId: number = 0
  content: string = ""
  msgId: string = ""

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 私聊消息发送字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: PrivateMessageSendRequestOptions) {
    if (options) {
      this.senderId = options.senderId
      this.receiverId = options.receiverId
      this.conversationId = options.conversationId
      this.content = options.content
      this.msgId = options.msgId
    }
  }
}
