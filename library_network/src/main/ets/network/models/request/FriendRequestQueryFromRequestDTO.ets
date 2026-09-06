/**
 * 好友请求查询（我发出的）DTO——描述查询自己发出的好友请求时的入参
 */
export interface FriendRequestQueryFromRequestOptions {
  fromUserId: number
}

export class FriendRequestQueryFromRequestDTO {
  fromUserId: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 好友请求查询字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: FriendRequestQueryFromRequestOptions) {
    if (options) {
      this.fromUserId = options.fromUserId
    }
  }
}
