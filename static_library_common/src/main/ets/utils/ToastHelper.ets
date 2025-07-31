import { promptAction } from '@kit.ArkUI'
import { Log } from './Log'

export class ToastHelper {
  static showToast(message?: string | Resource) {
    // 吐司 toast
    promptAction.showToast({ message: message })
    Log.log(`showToast:${message}`)
  }
}