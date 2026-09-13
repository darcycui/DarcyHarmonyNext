export abstract class ResponseHolder<T> {
  data: T = undefined as T; // 初始化占位 使用 undefined
  message: string = '';
  errorMessage: string = '';
}