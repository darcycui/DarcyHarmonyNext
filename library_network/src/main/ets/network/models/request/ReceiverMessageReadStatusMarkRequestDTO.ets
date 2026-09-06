/**
 * 接收方消息已读状态标记请求 DTO——描述接收方标记消息已读时的入参
 */
export interface ReceiverMessageReadStatusMarkRequestOptions {
  userId: number
  fromUserName: string
  targetId: number
  targetName: string
  msgIds: string[]
  conversationId: number
  conversationType: number
  clientType: string
  deviceId: string
}

export class ReceiverMessageReadStatusMarkRequestDTO {
  userId: number = 0
  fromUserName: string = ""
  targetId: number = 0
  targetName: string = ""
  msgIds: string[] = []
  conversationId: number = 0
  conversationType: number = 1
  clientType: string = ""
  deviceId: string = ""

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 接收方消息已读标记字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: ReceiverMessageReadStatusMarkRequestOptions) {
    if (options) {
      this.userId = options.userId
      this.fromUserName = options.fromUserName
      this.targetId = options.targetId
      this.targetName = options.targetName
      this.msgIds = options.msgIds
      this.conversationId = options.conversationId
      this.conversationType = options.conversationType
      this.clientType = options.clientType
      this.deviceId = options.deviceId
    }
  }
}
