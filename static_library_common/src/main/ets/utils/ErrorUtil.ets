import { Log } from "./Log";
import { JSON } from "@kit.ArkTS";

export default class ErrorUtil {
  static getErrorMessage(error: object): string {
    if (error instanceof Error) {
      return error.message + (error.stack ? `\n${error.stack}` : '')
    } else if (typeof error === 'string') {
      return error
    } else {
      return `错误: ${JSON.stringify(error)}`
    }
  }

  static logError(error: object) {
    Log.error(ErrorUtil.getErrorMessage(error));
  }

  static printTrackStack(error: Error) {
    Log.error(`异常堆栈信息: ${error.stack}`)
  }
}