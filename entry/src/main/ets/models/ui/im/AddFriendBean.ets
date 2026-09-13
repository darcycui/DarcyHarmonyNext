import { IUIBean } from "../../IUIBean";

/**
 * 添加好友请求 Bean
 *
 * 对应 Kotlin 中的 AddFriendBean
 * 字段映射：
 *   - fromUserId : 发起方用户 ID（Long）
 *   - toUserId   : 接收方用户 ID（Long）
 */
export class AddFriendBean implements IUIBean {
  /**
   * 发起方用户 ID
   */
  fromUserId: number = 0;

  /**
   * 接收方用户 ID
   */
  toUserId: number = 0;

  constructor(fromUserId?: number, toUserId?: number) {
    if (fromUserId !== undefined) {
      this.fromUserId = fromUserId;
    }
    if (toUserId !== undefined) {
      this.toUserId = toUserId;
    }
  }
}
