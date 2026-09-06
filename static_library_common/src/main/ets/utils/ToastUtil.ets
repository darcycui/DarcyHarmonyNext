import { Log } from './Log'

export class ToastUtil {

  static showToast(uiContext: UIContext, message?: string | Resource) {
    // 吐司 toast
    try {
      uiContext.getPromptAction().showToast({ message: message })
    } catch (error) {
      // TODO: Implement error handling.
      Log.error(`吐司异常:${JSON.stringify(error)}`)
    }
    Log.log(`showToast:${message}`)
  }
}