/**
 * 登录请求 DTO——描述用户登录时的入参
 */
export interface LoginRequestOptions {
  phone: string
  password: string
}

export class LoginRequestDTO {
  phone: string = ""
  password: string = ""

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 登录请求字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: LoginRequestOptions) {
    if (options) {
      this.phone = options.phone
      this.password = options.password
    }
  }
}
