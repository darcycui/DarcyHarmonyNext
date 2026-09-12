import { ArkTSUtils } from '@kit.ArkTS';
import { Log } from 'static_library_common'

export class DHSecretManager {
  private static dhSecret: string = ''
  private static lock: ArkTSUtils.locks.AsyncLock = new ArkTSUtils.locks.AsyncLock()

  static async getDHSecret(): Promise<string> {
    try {
      return await DHSecretManager.lock.lockAsync(() => {
        return DHSecretManager.dhSecret
      })
    } catch (error) {
      Log.error(`DHSecretManager getDHSecret 获取密钥异常: ${JSON.stringify(error)}`)
      return ''
    }
  }

  static async setDHSecret(secret: string): Promise<void> {
    try {
      await DHSecretManager.lock.lockAsync(() => {
        DHSecretManager.dhSecret = secret
      })
    } catch (error) {
      Log.error(`DHSecretManager setDHSecret 设置密钥异常: ${JSON.stringify(error)}`)
    }
  }

  static async clearDHSecret(): Promise<void> {
    await DHSecretManager.setDHSecret('')
  }
}
