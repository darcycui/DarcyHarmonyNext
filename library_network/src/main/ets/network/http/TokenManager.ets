import { ArkTSUtils } from '@kit.ArkTS';
import { Log } from 'static_library_common';

export class TokenManager {
  private static token: string = '';
  private static lock: ArkTSUtils.locks.AsyncLock = new ArkTSUtils.locks.AsyncLock()

  /**
   * 同步获取 token（供拦截器等同步上下文使用）
   * 单线程主线程环境下读取字符串无需加锁
   */
  static getTokenSync(): string {
    return TokenManager.token;
  }

  static async getToken(): Promise<string> {
    try {
      return await TokenManager.lock.lockAsync(() => {
        return TokenManager.token
      })
    } catch (error) {
      Log.error(`[TokenManager] getToken 获取 token 异常: ${JSON.stringify(error)}`)
      return ''
    }
  }

  static async setToken(token: string): Promise<void> {
    try {
      await TokenManager.lock.lockAsync(() => {
        TokenManager.token = token
      })
      Log.info(`[TokenManager] Token updated`)
    } catch (error) {
      Log.error(`[TokenManager] setToken 设置 token 异常: ${JSON.stringify(error)}`)
    }
  }

  static async clearToken(): Promise<void> {
    await TokenManager.setToken('')
    Log.info(`[TokenManager] Token cleared`)
  }
}
