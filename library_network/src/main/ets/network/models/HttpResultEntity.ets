export class HttpResultEntity<T> {
  resultcode: number = -1
  reason: string = ""
  result?: T | null | undefined = null
  error_code: number = -1
}