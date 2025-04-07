import { promptAction } from '@kit.ArkUI'

export function showToast(message?: string | Resource) {
  // 吐司 toast
  promptAction.showToast({ message: message })
}