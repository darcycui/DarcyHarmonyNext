/**
 * 好友关系删除请求 DTO——描述删除好友时的入参
 */
export interface FriendshipDeleteRequestOptions {
  userId: number
  friendId: number
}

export class FriendshipDeleteRequestDTO {
  userId: number = 0
  friendId: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 好友删除请求字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: FriendshipDeleteRequestOptions) {
    if (options) {
      this.userId = options.userId
      this.friendId = options.friendId
    }
  }
}
