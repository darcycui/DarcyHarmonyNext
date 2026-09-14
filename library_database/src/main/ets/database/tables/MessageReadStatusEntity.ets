/**
 * 消息已读状态（MessageReadStatus）实体类
 *
 * 对应数据库表名：message_read_status
 * 字段映射：
 *   - id           : 主键，自增（Long 类型）
 *   - msgId        : 消息 ID（String）
 *   - userId       : 用户 ID（Long）
 *   - targetId     : 目标用户 ID（Long）
 *   - isRead       : 是否已读（Boolean）
 *   - messageType  : 消息类型（Int）
 *   - readTime     : 已读时间（String）
 *   - createdTime  : 创建时间（String）
 *   - updatedTime  : 更新时间（String）
 */
export class MessageReadStatusEntity {
  /**
   * 主键，自增
   */
  id: number = 0;

  /**
   * 消息 ID
   */
  msgId: string = '';

  /**
   * 用户 ID
   */
  userId: number = 0;

  /**
   * 目标用户 ID
   */
  targetId: number = 0;

  /**
   * 是否已读
   */
  isRead: boolean = false;

  /**
   * 消息类型
   */
  messageType: number = 1;

  /**
   * 已读时间
   */
  readTime: string = '';

  /**
   * 创建时间
   */
  createdTime: string = '';

  /**
   * 更新时间
   */
  updatedTime: string = '';

  constructor(
    id?: number,
    msgId?: string,
    userId?: number,
    targetId?: number,
    isRead?: boolean,
    messageType?: number,
    readTime?: string,
    createdTime?: string,
    updatedTime?: string,
  ) {
    if (id !== undefined) {
      this.id = id;
    }
    if (msgId !== undefined) {
      this.msgId = msgId;
    }
    if (userId !== undefined) {
      this.userId = userId;
    }
    if (targetId !== undefined) {
      this.targetId = targetId;
    }
    if (isRead !== undefined) {
      this.isRead = isRead;
    }
    if (messageType !== undefined) {
      this.messageType = messageType;
    }
    if (readTime !== undefined) {
      this.readTime = readTime;
    }
    if (createdTime !== undefined) {
      this.createdTime = createdTime;
    }
    if (updatedTime !== undefined) {
      this.updatedTime = updatedTime;
    }
  }
}
