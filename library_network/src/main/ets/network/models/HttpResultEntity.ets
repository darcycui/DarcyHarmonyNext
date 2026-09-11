export class HttpResultEntity<T> {
  resultcode: number = -1
  result?: T | null | undefined = null
  error_code: number = -1
  reason: string = ""

  constructor(errorCode: number, result: T | null | undefined, reason: string = '', resultcode: number = 200) {
    this.error_code = errorCode;
    this.result = result;
    this.reason = reason;
    this.resultcode = resultcode;
  }
}