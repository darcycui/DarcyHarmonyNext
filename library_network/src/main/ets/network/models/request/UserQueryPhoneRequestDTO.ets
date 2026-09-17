/**
 * 用户手机号查询 DTO——描述按手机号搜索用户时的入参
 */
export interface UserQueryPhoneRequestOptions {
  phone: string
}

export class UserQueryPhoneRequestDTO {
  phone: string = ""

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 查询字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: UserQueryPhoneRequestOptions) {
    if (options) {
      this.phone = options.phone
    }
  }
}
