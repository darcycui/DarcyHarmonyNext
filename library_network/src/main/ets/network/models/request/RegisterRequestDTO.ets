/**
 * 用户注册请求 DTO——描述用户注册时的完整入参
 * username、password 为必填字段，其余有默认值可选
 */
export interface RegisterRequestOptions {
  username: string
  password: string
  nickname: string
  avatar: string
  phone: string
  email: string
  gender: string
  roles: string
  signature: string
  settings: string
}

export class RegisterRequestDTO {
  username: string = ""
  password: string = ""
  nickname: string = ""
  avatar: string = ""
  phone: string = ""
  email: string = ""
  gender: string = ""
  roles: string = ""
  signature: string = ""
  settings: string = ""

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 注册请求字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: RegisterRequestOptions) {
    if (options) {
      this.username = options.username
      this.password = options.password
      this.nickname = options.nickname
      this.avatar = options.avatar
      this.phone = options.phone
      this.email = options.email
      this.gender = options.gender
      this.roles = options.roles
      this.signature = options.signature
      this.settings = options.settings
    }
  }
}
