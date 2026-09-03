/**
 * 错误响应实体类
 */
export interface HttpErrorOptions {
  timestamp?: number;
  status?: number;
  error?: string;
  message?: string;
  path?: string;
}

export class HttpErrorEntity {
  /**
   * 时间戳（只读，创建时自动生成，不可修改）
   */
  timestamp: number = Date.now();

  /**
   * HTTP 状态码
   */
  status: number = 0;

  /**
   * 错误类型 / 简短错误标识
   */
  error: string = 'Http Error';

  /**
   * 详细错误描述
   */
  message: string = '';

  /**
   * 请求路径
   */
  path: string = '/';

  /**
   * 构造函数——支持通过 Partial 传入部分字段覆盖默认值
   * @param source - 部分实体字段
   */
  constructor(source?: HttpErrorOptions) {
    if (source) {
      if (source.timestamp !== undefined) {
        this.timestamp = source.timestamp;
      }
      if (source.status !== undefined) {
        this.status = source.status;
      }
      if (source.error !== undefined) {
        this.error = source.error;
      }
      if (source.message !== undefined) {
        this.message = source.message;
      }
      if (source.path !== undefined) {
        this.path = source.path;
      }
    }
  }
}