import { Log } from 'static_library_common';
import { HttpErrorEntity } from '../models/HttpErrorEntity';
import { HttpResultEntity } from '../models/HttpResultEntity';

export function parseResultBean<T>(message: string, onSuccess: (data: HttpResultEntity<T>) => void,
  onFailure: (data: HttpErrorEntity) => void) {
  try {
    let result: HttpResultEntity<T> = JSON.parse(message) as HttpResultEntity<T>;
    // 验证解析结果是否正确
    if (result && result.result && result.result != undefined) {
      Log.log('json解析为 HttpResultEntity 成功');
      onSuccess(result);
    } else {
      Log.warn('json解析为 HttpResultEntity 失败');
      let error: HttpErrorEntity | null = JSON.parse(message)
      if (error != null) {
        Log.error('json解析为 HttpErrorEntity 成功')
        let realError = error as HttpErrorEntity
        onFailure(realError)
      } else {
        Log.warn('json解析为 HttpErrorEntity 失败')
        onFailure(new HttpErrorEntity({
          message: 'json解析错误',
          status: -2,
        }))
      }
    }
  } catch (e) {
    Log.error(`json解析异常: ${e}`)
    onFailure(new HttpErrorEntity({
      message: 'json解析错误',
      status: -3,
    }))
  }
}