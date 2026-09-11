import { Log } from 'static_library_common';
import { HttpErrorEntity } from '../models/HttpErrorEntity';
import { HttpResultEntity } from '../models/HttpResultEntity';

export class JsonParser {
  /**
   * 解析JSON响应，先提取 error_code 字段，根据 error_code === 0 判断成功/失败。
   *
   * @param message   - 原始 JSON 字符串
   * @param onSuccess - 成功回调（error_code === 0），data.result 为业务数据 T
   * @param onFailure - 失败回调（error_code !== 0），data.result 为 HttpErrorEntity 错误详情
   */
  static parseResultBean<T>(message: string, onSuccess: (data: HttpResultEntity<T>) => void,
    onFailure: (data: HttpResultEntity<HttpErrorEntity>) => void) {
    try {
      // 1. 解析 JSON
      let parsed: Record<string, Object> = JSON.parse(message) as Record<string, Object>;
      // 2. 提取 error_code，默认 -1 表示未知错误
      let errorCode: number = (parsed['error_code'] as number) ?? -1;

      if (errorCode === 0) {
        // 成功：error_code == 0，完整解析为 HttpResultEntity<T>
        let result: HttpResultEntity<T> = JSON.parse(message) as HttpResultEntity<T>;
        Log.log(`parseResultBean 成功, error_code = ${errorCode}`);
        onSuccess(result);
      } else {
        // 失败：error_code != 0，result 字段解析为 HttpErrorEntity
        let errorResult: HttpResultEntity<HttpErrorEntity> = JSON.parse(message) as HttpResultEntity<HttpErrorEntity>;
        Log.error(`parseResultBean 失败, error_code = ${errorCode}`);
        onFailure(errorResult);
      }
    } catch (e) {
      Log.error(`parseResultBean 解析异常: ${e}`);
      onFailure(new HttpResultEntity<HttpErrorEntity>(
        -1,
        new HttpErrorEntity({
          message: `JSON解析异常: ${JSON.stringify(e)}`,
          status: -1,
        }),
        `JSON解析异常: ${JSON.stringify(e)}`
      ));
    }
  }
}
