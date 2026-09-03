/**
 * 用户注册请求 DTO——描述客户端在注册接口提交的入参
 * 服务端生成的字段(id/createdAt/token等)不在此列，注册成功后由服务端返回的 UserDTO 承载
 */
/**
 * 用户注册请求完整字段集合——作为构造器唯一入参
 * 所有字段必填：即便某字段不提交也应显式传 ""，保证序列化输出结构稳定
 */
export interface UserRegisterRequestOptions {
  username: string
  // 明文密码，仅注册时客户端提交；密码哈希由服务端计算并存入 UserDTO.passwordHash
  password: string
  nickname: string
  email: string
  phone: string
  gender: string
  avatar: string
  roles: string
}

export class UserRegisterRequest {
  username: string = ""
  // 明文密码，仅注册时客户端提交；密码哈希由服务端计算并存入 UserDTO.passwordHash
  password: string = ""
  nickname: string = ""
  email: string = ""
  phone: string = ""
  gender: string = ""
  avatar: string = ""
  roles: string = ""

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 完整注册字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: UserRegisterRequestOptions) {
    if (options) {
      this.username = options.username
      this.password = options.password
      this.nickname = options.nickname
      this.email = options.email
      this.phone = options.phone
      this.gender = options.gender
      this.avatar = options.avatar
      this.roles = options.roles
    }
  }
}
