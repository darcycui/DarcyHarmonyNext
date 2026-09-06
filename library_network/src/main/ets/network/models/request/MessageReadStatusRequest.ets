/**
 * 消息已读状态请求 DTO——描述标记消息已读时的入参
 */
export interface MessageReadStatusRequestOptions {
  userId: number
  targetId: number
  fromUserName: string
  targetName: string
  msgIds: string[]
  conversationType: number
  clientType: string
  deviceId: string
}

export class MessageReadStatusRequest {
  userId: number = 0
  targetId: number = 0
  fromUserName: string = ""
  targetName: string = ""
  msgIds: string[] = []
  conversationType: number = 1
  clientType: string = ""
  deviceId: string = ""

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 消息已读请求字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: MessageReadStatusRequestOptions) {
    if (options) {
      this.userId = options.userId
      this.targetId = options.targetId
      this.fromUserName = options.fromUserName
      this.targetName = options.targetName
      this.msgIds = options.msgIds
      this.conversationType = options.conversationType
      this.clientType = options.clientType
      this.deviceId = options.deviceId
    }
  }
}
