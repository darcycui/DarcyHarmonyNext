/**
 * 跳过的消息密钥（SkippedMessageKey）实体类
 *
 * 对应数据库表名：skipped_message_key
 * 字段映射：
 *   - id           : 主键，自增（Long 类型）
 *   - userId       : 用户 ID（Long）
 *   - targetId     : 目标用户 ID（Long）
 *   - msgId        : 消息 ID（String）
 *   - dhPublicKey  : DH 公钥（String）
 *   - chainIndex   : 链索引（Long）
 *   - messageKey   : 消息密钥（String）
 *   - macKey       : MAC 密钥（String）
 *   - iv           : 初始化向量（String）
 *   - createdTime  : 创建时间（String）
 */
export class SkippedMessageKeyEntity {
  /**
   * 主键，自增
   */
  id: number = 0;

  /**
   * 用户 ID
   */
  userId: number = 0;

  /**
   * 目标用户 ID
   */
  targetId: number = 0;

  /**
   * 消息 ID
   */
  msgId: string = '';

  /**
   * DH 公钥
   */
  dhPublicKey: string = '';

  /**
   * 链索引
   */
  chainIndex: number = 0;

  /**
   * 消息密钥
   */
  messageKey: string = '';

  /**
   * MAC 密钥
   */
  macKey: string = '';

  /**
   * 初始化向量
   */
  iv: string = '';

  /**
   * 创建时间
   */
  createdTime: string = '';

  constructor(
    id?: number,
    userId?: number,
    targetId?: number,
    msgId?: string,
    dhPublicKey?: string,
    chainIndex?: number,
    messageKey?: string,
    macKey?: string,
    iv?: string,
    createdTime?: string,
  ) {
    if (id !== undefined) {
      this.id = id;
    }
    if (userId !== undefined) {
      this.userId = userId;
    }
    if (targetId !== undefined) {
      this.targetId = targetId;
    }
    if (msgId !== undefined) {
      this.msgId = msgId;
    }
    if (dhPublicKey !== undefined) {
      this.dhPublicKey = dhPublicKey;
    }
    if (chainIndex !== undefined) {
      this.chainIndex = chainIndex;
    }
    if (messageKey !== undefined) {
      this.messageKey = messageKey;
    }
    if (macKey !== undefined) {
      this.macKey = macKey;
    }
    if (iv !== undefined) {
      this.iv = iv;
    }
    if (createdTime !== undefined) {
      this.createdTime = createdTime;
    }
  }
}
