/**
 * LoginRepository - 登录数据仓库
 *
 * 继承 BaseRepository，统一封装登录相关的数据访问层。
 * 当前为模拟实现，后续可对接真实网络 API。
 *
 * 架构流向：
 *   LoginUseCase → LoginRepository → HttpUtil / API
 */
import { BaseRepository } from 'static_library_common';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 登录响应结果
 */
export interface LoginResult {
  success: boolean;
  message: string;
  /** 用户 ID（登录成功后由服务端返回，用于后续 DH 密钥交换等操作） */
  userId: number;
}

export class LoginRepository extends BaseRepository {
  /**
   * 执行登录请求
   *
   * @param userName - 用户名
   * @param password - 密码
   * @returns 登录结果
   */
  async doLogin(userName: string, password: string): Promise<LoginResult> {
    return this.safeCall(async () => {
      // TODO: 替换为真实网络请求
      // 模拟登录校验
      if (!userName || !password) {
        throw new Error('用户名或密码不能为空');
      }

      // 模拟网络延迟
      await new Promise<void>((resolve) => {
        setTimeout(() => {
          resolve();
        }, 500);
      });

      // 模拟登录成功（后续对接真实 API，服务端返回用户 ID）
      return {
        success: true,
        message: '登录成功',
        userId: 1
      } as LoginResult;
    });
  }
}
