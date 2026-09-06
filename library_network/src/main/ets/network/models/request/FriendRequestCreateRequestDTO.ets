/**
 * 好友请求创建 DTO——描述发起好友请求时的入参
 */
export interface FriendRequestCreateRequestOptions {
  fromUserId: number
  toUserId: number
}

export class FriendRequestCreateRequestDTO {
  fromUserId: number = 0
  toUserId: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 好友请求创建字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: FriendRequestCreateRequestOptions) {
    if (options) {
      this.fromUserId = options.fromUserId
      this.toUserId = options.toUserId
    }
  }
}
