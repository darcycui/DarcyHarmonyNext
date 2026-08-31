import { promptAction } from '@kit.ArkUI'
import { Log } from './Log'

export class ToastHelper {
  static showToast(message?: string | Resource) {
    // 吐司 toast
    try {
      promptAction.showToast({ message: message })
    } catch (error) {
      // TODO: Implement error handling.
      Log.error(`吐司异常:${JSON.stringify(error)}`)
    }
    Log.log(`showToast:${message}`)
  }
}