/**
 * 好友关系（Friendship）实体类
 *
 * 对应数据库表名：friendship
 * 字段映射：
 *   - friendshipId   : 主键，自增（Long 类型，可空）
 *   - userIdFrom     : 发起方用户 ID（Long）
 *   - userIdTo       : 接收方用户 ID（Long）
 *   - markNameOfTo   : 发起方对接收方的备注名（String）
 *   - markNameOfFrom : 接收方对发起方的备注名（String）
 *   - createdTime    : 创建时间（Long）
 *   - updatedTime    : 更新时间（Long）
 *   - deletedTime    : 删除时间（Long）
 *   - name           : 关系名称（String）
 */
export class FriendshipEntity {
  /**
   * 主键，自增
   */
  friendshipId: number | null = null;

  /**
   * 发起方用户 ID
   */
  userIdFrom: number = 0;

  /**
   * 接收方用户 ID
   */
  userIdTo: number = 0;

  /**
   * 发起方对接收方的备注名
   */
  markNameOfTo: string = '';

  /**
   * 接收方对发起方的备注名
   */
  markNameOfFrom: string = '';

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

  /**
   * 关系名称
   */
  name: string = '';

  constructor(
    friendshipId?: number | null,
    userIdFrom?: number,
    userIdTo?: number,
    markNameOfTo?: string,
    markNameOfFrom?: string,
    createdTime?: number,
    updatedTime?: number,
    deletedTime?: number,
    name?: string,
  ) {
    if (friendshipId !== undefined) {
      this.friendshipId = friendshipId;
    }
    if (userIdFrom !== undefined) {
      this.userIdFrom = userIdFrom;
    }
    if (userIdTo !== undefined) {
      this.userIdTo = userIdTo;
    }
    if (markNameOfTo !== undefined) {
      this.markNameOfTo = markNameOfTo;
    }
    if (markNameOfFrom !== undefined) {
      this.markNameOfFrom = markNameOfFrom;
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
    if (name !== undefined) {
      this.name = name;
    }
  }
}
