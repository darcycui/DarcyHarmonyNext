/**
 * 好友请求操作 DTO——描述对好友请求执行操作时的入参
 */
export interface FriendRequestActionRequestOptions {
  friendRequestId: number
}

export class FriendRequestActionRequestDTO {
  friendRequestId: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 好友请求操作字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: FriendRequestActionRequestOptions) {
    if (options) {
      this.friendRequestId = options.friendRequestId
    }
  }
}
