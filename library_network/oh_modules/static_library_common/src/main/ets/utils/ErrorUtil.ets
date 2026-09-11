import { Log } from "./Log";
import { JSON } from "@kit.ArkTS";

export default class ErrorUtil {
  static getErrorMessage(error: object): string {
    if (error instanceof Error) {
      return error.message
    } else if (typeof error === 'string') {
      return error
    } else {
      return `错误: ${JSON.stringify(error)}`
    }
  }

  static logError(error: object) {
    Log.error(ErrorUtil.getErrorMessage(error));
  }
}