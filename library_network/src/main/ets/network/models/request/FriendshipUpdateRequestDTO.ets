/**
 * 好友关系更新请求 DTO——描述更新好友关系时的入参
 */
export interface FriendshipUpdateRequestOptions {
  friendshipId: number
}

export class FriendshipUpdateRequestDTO {
  friendshipId: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 好友关系更新字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: FriendshipUpdateRequestOptions) {
    if (options) {
      this.friendshipId = options.friendshipId
    }
  }
}
