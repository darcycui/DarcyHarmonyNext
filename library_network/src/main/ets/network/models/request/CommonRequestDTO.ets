/**
 * 公共请求 DTO——描述通用的请求入参
 */
export interface CommonRequestOptions {
  userId: number
}

export class CommonRequestDTO {
  userId: number = 0

  /**
   * 通过 options 接口一次性接收全部字段
   * @param options - 公共请求字段；省略时走无参 new（所有字段保持默认值）
   */
  constructor(options?: CommonRequestOptions) {
    if (options) {
      this.userId = options.userId
    }
  }
}
