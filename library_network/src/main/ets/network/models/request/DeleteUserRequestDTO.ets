/**
 * 删除用户请求 DTO——描述删除用户的请求入参
 */
export interface DeleteUserRequestOptions {
  userId: number,
  userName: string,
  phone: string
}

export class DeleteUserRequestDTO {
  userId: number = 0
  userName: string = ''
  phone: string = ''

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 删除用户请求字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: DeleteUserRequestOptions) {
    if (options) {
      this.userId = options.userId
      this.userName = options.userName
      this.phone = options.phone
    }
  }
}
