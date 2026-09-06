/**
 * 好友请求查询（查询发给我的）DTO——描述查询他人发给自己的好友请求时的入参
 */
export interface FriendRequestQueryToRequestOptions {
  toUserId: number
}

export class FriendRequestQueryToRequestDTO {
  toUserId: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 好友请求查询字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: FriendRequestQueryToRequestOptions) {
    if (options) {
      this.toUserId = options.toUserId
    }
  }
}
