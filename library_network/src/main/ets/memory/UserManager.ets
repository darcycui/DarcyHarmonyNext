import { ArkTSUtils } from '@kit.ArkTS';
import { Log } from 'static_library_common'
import { UserResponse } from '../../../../Index';

export class UserManager {
  private static user: UserResponse = new UserResponse()
  private static lock: ArkTSUtils.locks.AsyncLock = new ArkTSUtils.locks.AsyncLock()

  static async getUser(): Promise<UserResponse> {
    try {
      return await UserManager.lock.lockAsync(() => {
        return UserManager.user
      })
    } catch (error) {
      Log.error(`UserManager getUser 获取用户异常: ${JSON.stringify(error)}`)
      return new UserResponse()
    }
  }

  static async getUserID(): Promise<number> {
    try {
      return await UserManager.lock.lockAsync(() => {
        return UserManager.user.id
      })
    } catch (error) {
      Log.error(`UserManager getUserID 获取用户ID异常: ${JSON.stringify(error)}`)
      return 0
    }
  }

  static async setUser(user: UserResponse): Promise<void> {
    try {
      await UserManager.lock.lockAsync(() => {
        UserManager.user = user
      })
    } catch (error) {
      Log.error(`UserManager setUser 设置用户异常: ${JSON.stringify(error)}`)
    }
  }

  static async clearUser(): Promise<void> {
    await UserManager.setUser(new UserResponse())
  }
}
