/**
 * 会话（Conversation）实体类
 *
 * 对应数据库表名：conversation
 * 字段映射：
 *   - conversationId : 主键，自增（Long 类型，可空）
 *   - userIdFrom     : 发起方用户 ID（Long）
 *   - userIdTo       : 接收方用户 ID（Long）
 *   - type           : 会话类型（Int）
 *   - name           : 会话名称（String）
 *   - createdTime    : 创建时间（Long）
 *   - updatedTime    : 更新时间（Long）
 *   - deletedTime    : 删除时间（Long）
 */
export class ConversationEntity {
  /**
   * 主键，自增
   */
  conversationId: number | null = null;

  /**
   * 发起方用户 ID
   */
  userIdFrom: number = 0;

  /**
   * 接收方用户 ID
   */
  userIdTo: number = 0;

  /**
   * 会话类型
   */
  type: number = 0;

  /**
   * 会话名称
   */
  name: string = '';

  /**
   * 创建时间
   */
  createdTime: number = 0;

  /**
   * 更新时间
   */
  updatedTime: number = 0;

  /**
   * 删除时间
   */
  deletedTime: number = 0;

  constructor(
    conversationId?: number | null,
    userIdFrom?: number,
    userIdTo?: number,
    type?: number,
    name?: string,
    createdTime?: number,
    updatedTime?: number,
    deletedTime?: number,
  ) {
    if (conversationId !== undefined) {
      this.conversationId = conversationId;
    }
    if (userIdFrom !== undefined) {
      this.userIdFrom = userIdFrom;
    }
    if (userIdTo !== undefined) {
      this.userIdTo = userIdTo;
    }
    if (type !== undefined) {
      this.type = type;
    }
    if (name !== undefined) {
      this.name = name;
    }
    if (createdTime !== undefined) {
      this.createdTime = createdTime;
    }
    if (updatedTime !== undefined) {
      this.updatedTime = updatedTime;
    }
    if (deletedTime !== undefined) {
      this.deletedTime = deletedTime;
    }
  }
}
