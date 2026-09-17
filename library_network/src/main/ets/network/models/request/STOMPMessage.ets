/**
 * STOMP 消息模型选项接口
 *
 * 可选参数构造器入参，所有字段均为可选，省略时走类默认值
 */
export interface STOMPMessageOptions {
  /** 发送者昵称 */
  senderName?: string
  /** 接收者昵称 */
  receiverName?: string
  /** 消息内容 */
  content?: string
  /** 消息 ID */
  msgId?: string
  /** 发送者 ID */
  senderId?: number
  /** 接收者 ID */
  receiverId?: number
  /** 消息类型（TEXT / IMAGE / FILE / SYSTEM 等） */
  msgType?: string
  /** 发送时间（时间戳字符串） */
  sendTime?: string
  /** 是否已读 */
  isRead?: boolean
  /** 是否已撤回 */
  isRecalled?: boolean
  /** DH 公钥（用于端到端加密） */
  dhPublicKey?: string
  /** N 密钥参数 */
  nKey?: number
  /** PN 密钥参数 */
  pnKey?: number
}

/**
 * STOMP 消息模型
 *
 * 映射自 Kotlin data class STOMPMessage，用于 WebSocket STOMP 协议的消息传输对象。
 * 支持通过 STOMPMessageOptions 接口一次性构造，也支持无参构造（所有字段保持默认值）。
 */
export class STOMPMessage {
  /** 发送者昵称 */
  senderName: string = ''

  /** 接收者昵称 */
  receiverName: string = ''

  /** 消息内容 */
  content: string = ''

  /** 消息 ID */
  msgId: string = ''

  /** 发送者 ID */
  senderId: number = 0

  /** 接收者 ID */
  receiverId: number = 0

  /** 消息类型，默认 "TEXT" */
  msgType: string = 'TEXT'

  /** 发送时间（时间戳字符串），默认当前时间戳 */
  sendTime: string = Date.now().toString()

  /** 是否已读 */
  isRead: boolean = false

  /** 是否已撤回 */
  isRecalled: boolean = false

  /** DH 公钥（用于端到端加密） */
  dhPublicKey: string = ''

  /** N 密钥参数 */
  nKey: number = 0

  /** PN 密钥参数 */
  pnKey: number = 0

  /**
   * 构造 STOMPMessage 实例
   *
   * @param options - 可选构造参数；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: STOMPMessageOptions) {
    if (options) {
      if (options.senderName !== undefined) {
        this.senderName = options.senderName
      }
      if (options.receiverName !== undefined) {
        this.receiverName = options.receiverName
      }
      if (options.content !== undefined) {
        this.content = options.content
      }
      if (options.msgId !== undefined) {
        this.msgId = options.msgId
      }
      if (options.senderId !== undefined) {
        this.senderId = options.senderId
      }
      if (options.receiverId !== undefined) {
        this.receiverId = options.receiverId
      }
      if (options.msgType !== undefined) {
        this.msgType = options.msgType
      }
      if (options.sendTime !== undefined) {
        this.sendTime = options.sendTime
      } else {
        this.sendTime = Date.now().toString()
      }
      if (options.isRead !== undefined) {
        this.isRead = options.isRead
      }
      if (options.isRecalled !== undefined) {
        this.isRecalled = options.isRecalled
      }
      if (options.dhPublicKey !== undefined) {
        this.dhPublicKey = options.dhPublicKey
      }
      if (options.nKey !== undefined) {
        this.nKey = options.nKey
      }
      if (options.pnKey !== undefined) {
        this.pnKey = options.pnKey
      }
    }
  }
}
