import { ArkTSUtils } from '@kit.ArkTS';
import { Log } from 'static_library_common'

export class ServerDHSecretManager {
  private static dhSecret: string = ''
  private static lock: ArkTSUtils.locks.AsyncLock = new ArkTSUtils.locks.AsyncLock()

  static async getDHSecret(): Promise<string> {
    try {
      return await ServerDHSecretManager.lock.lockAsync(() => {
        return ServerDHSecretManager.dhSecret
      })
    } catch (error) {
      Log.error(`DHSecretManager getDHSecret 获取密钥异常: ${JSON.stringify(error)}`)
      return ''
    }
  }

  static getDHSecretSync(): string {
    return ServerDHSecretManager.dhSecret
  }

  static async setDHSecret(secret: string): Promise<void> {
    try {
      await ServerDHSecretManager.lock.lockAsync(() => {
        ServerDHSecretManager.dhSecret = secret
      })
    } catch (error) {
      Log.error(`DHSecretManager setDHSecret 设置密钥异常: ${JSON.stringify(error)}`)
    }
  }

  static async clearDHSecret(): Promise<void> {
    await ServerDHSecretManager.setDHSecret('')
  }

  static isSecretReady(): boolean {
    return ServerDHSecretManager.dhSecret !== ''
  }
}
