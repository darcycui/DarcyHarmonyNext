/**
 * 私密消息（PrivateMessage）实体类
 *
 * 对应数据库表名：private_message
 * 字段映射：
 *   - id           : 主键，自增（Long 类型）
 *   - msgId        : 消息 ID（String）
 *   - userId       : 发送方用户 ID（Long）
 *   - targetId     : 接收方用户 ID（Long）
 *   - content      : 消息内容（String）
 *   - messageType  : 消息类型（Int）
 *   - createdTime  : 创建时间（String）
 *   - updatedTime  : 更新时间（String）
 *   - dhPublicKey  : DH 公钥（String）
 *   - nKey         : 消息序号（Long）
 *   - pnKey        : 上一个消息序号（Long）
 */
export class PrivateMessageEntity {
  /**
   * 主键，自增
   */
  id: number = 0;

  /**
   * 消息 ID
   */
  msgId: string = '';

  /**
   * 发送方用户 ID
   */
  userId: number = 0;

  /**
   * 接收方用户 ID
   */
  targetId: number = 0;

  /**
   * 消息内容
   */
  content: string = '';

  /**
   * 消息类型
   */
  messageType: number = 1;

  /**
   * 创建时间
   */
  createdTime: string = '';

  /**
   * 更新时间
   */
  updatedTime: string = '';

  /**
   * DH 公钥
   */
  dhPublicKey: string = '';

  /**
   * 消息序号
   */
  nKey: number = 0;

  /**
   * 上一个消息序号
   */
  pnKey: number = 0;

  constructor(
    id?: number,
    msgId?: string,
    userId?: number,
    targetId?: number,
    content?: string,
    messageType?: number,
    createdTime?: string,
    updatedTime?: string,
    dhPublicKey?: string,
    nKey?: number,
    pnKey?: number,
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
    if (content !== undefined) {
      this.content = content;
    }
    if (messageType !== undefined) {
      this.messageType = messageType;
    }
    if (createdTime !== undefined) {
      this.createdTime = createdTime;
    }
    if (updatedTime !== undefined) {
      this.updatedTime = updatedTime;
    }
    if (dhPublicKey !== undefined) {
      this.dhPublicKey = dhPublicKey;
    }
    if (nKey !== undefined) {
      this.nKey = nKey;
    }
    if (pnKey !== undefined) {
      this.pnKey = pnKey;
    }
  }
}
