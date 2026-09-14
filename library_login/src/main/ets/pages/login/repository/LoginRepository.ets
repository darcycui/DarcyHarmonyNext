/**
 * LoginRepository - 登录数据仓库
 *
 * 继承 BaseRepository，统一封装登录相关的数据访问层。
 * 通过 httpHelper.doPost 调用登录 API，成功后触发 DH 密钥交换。
 *
 * 架构流向：
 *   LoginUseCase → LoginRepository → httpHelper.doPost → ServerDHExchangeUseCase
 */
import { ArrayUtil, BaseRepository, HashUtil, Log, ResponseHolder } from 'static_library_common';
import {
  HttpHelper,
  HttpCertHelper,
  HttpErrorEntity,
  HttpResultEntity,
  LoginRequestDTO,
  LoginResponse
} from 'library_network';
import { Urls } from '../../../http/Urls';
import { ServerDHExchangeUseCase } from '../../../dh/usecase/ServerDHExchangeUseCase';
import { ServerDHExchangeRepository } from '../../../dh/repository/ServerDHExchangeRepository';

/**
 * 登录响应数据容器——用于在异步回调间安全传递数据
 */
class LoginResponseHolder extends ResponseHolder <LoginResponse>{}

export class LoginRepository extends BaseRepository {
  /**
   * 执行登录请求
   *
   * @param userName - 用户名（手机号）
   * @param password - 密码
   * @returns 登录结果
   */
  async doLogin(userName: string, password: string): Promise<LoginResponse> {
    return this.safeCall(async () => {
      // 构建请求 DTO
      const dto: LoginRequestDTO = new LoginRequestDTO({
        phone: userName,
        password: HashUtil.sha256FromBytesSync(ArrayUtil.stringToBytes(password))
      });

      const url: string = Urls.LOGIN_URL;
      const body: string = JSON.stringify(dto);

      // 使用容器对象在回调间传递数据，避免 Promise reject 中的 any 类型
      const holder: LoginResponseHolder = new LoginResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<LoginResponse>(
          url,
          body,
          (data: HttpResultEntity<LoginResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result
            } else {
              holder.errorMessage = data.reason || '登录失败';
            }
            resolve();
          },
          (error: HttpResultEntity<HttpErrorEntity>): void => {
            holder.errorMessage = error.result?.message || '网络请求失败';
            resolve();
          },
          HttpCertHelper.getCertPath()
        );
      });

      if (holder.errorMessage) {
        throw new Error(holder.errorMessage);
      }
      return holder.data;
    });
  }
}
