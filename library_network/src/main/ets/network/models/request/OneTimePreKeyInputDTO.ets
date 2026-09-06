/**
 * 一次性预密钥输入 DTO——描述一次性预密钥的完整输入字段
 */
export interface OneTimePreKeyInputOptions {
  id: number
  keyId: string
  userId: number
  publicKey: string
}

export class OneTimePreKeyInputDTO {
  id: number = 0
  keyId: string = ""
  userId: number = 0
  publicKey: string = ""

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 一次性预密钥字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: OneTimePreKeyInputOptions) {
    if (options) {
      this.id = options.id
      this.keyId = options.keyId
      this.userId = options.userId
      this.publicKey = options.publicKey
    }
  }
}
