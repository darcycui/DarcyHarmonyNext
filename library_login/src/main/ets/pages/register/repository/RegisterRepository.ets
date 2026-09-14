/**
 * RegisterRepository - 注册数据仓库
 *
 * 继承 BaseRepository，统一封装注册相关的数据访问层。
 * 通过 httpHelper.doPost 调用注册 API，返回 HttpResultEntity<UserResponse>。
 *
 * 架构流向：
 *   RegisterUseCase → RegisterRepository → httpHelper.doPost
 */
import { ArrayUtil, BaseRepository, HashUtil, Log, ResponseHolder } from 'static_library_common';
import {
  HttpHelper,
  HttpCertHelper,
  HttpErrorEntity,
  HttpResultEntity,
  RegisterRequestDTO,
  RegisterResponse,
  DeleteUserRequestDTO,
  StringResponse
} from 'library_network';
import { Urls } from '../../../http/Urls';
import { ServerDHExchangeUseCase } from '../../../dh/usecase/ServerDHExchangeUseCase';
import { ServerDHExchangeRepository } from '../../../dh/repository/ServerDHExchangeRepository';
import { Available } from '@kit.BasicServicesKit';

/**
 * 注册响应数据容器——用于在异步回调间安全传递数据
 */
class RegisterResponseHolder extends ResponseHolder<RegisterResponse> {
}

/**
 * 删除用户响应数据容器——用于在异步回调间安全传递数据
 */
class DeleteUserResponseHolder extends ResponseHolder<StringResponse> {
}

@Available({ minApiVersion: 'OpenHarmony 22' })
export class RegisterRepository extends BaseRepository {
  /**
   * 执行注册请求
   *
   * @param userName - 用户名
   * @param password - 密码
   * @param phone - 手机号
   * @param nickname - 昵称
   * @param email - 邮箱
   * @returns 注册结果
   */
  async doRegister(
    userName: string,
    password: string,
    phone: string,
    nickname: string,
    email: string
  ): Promise<RegisterResponse> {
    return this.safeCall(async () => {
      // 构建请求 DTO
      const dto: RegisterRequestDTO = new RegisterRequestDTO({
        username: userName,
        password: HashUtil.sha256FromBytesSync(ArrayUtil.stringToBytes(password)),
        nickname: nickname,
        phone: phone,
        email: email,
        gender: "male",
        avatar: 'https://avatars.githubusercontent.com/u/15907?v=4',
        roles: 'user',
        signature: '',
        settings: ''
      });

      const url: string = Urls.REGISTER_URL;
      const body: string = JSON.stringify(dto);

      // 使用容器对象在回调间传递数据，避免 Promise reject 中的 any 类型
      const holder: RegisterResponseHolder = new RegisterResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<RegisterResponse>(
          url,
          body,
          (data: HttpResultEntity<RegisterResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result
            } else {
              holder.errorMessage = data.reason || '注册失败';
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

      return holder.data ?? new RegisterResponse();
    });
  }

  /**
   * 执行删除用户请求
   *
   * @param userId - 用户ID
   * @param userName - 用户名
   * @param phone - 手机号
   * @returns 删除结果
   */
  async doDeleteUser(
    userId: number,
    userName: string,
    phone: string
  ): Promise<StringResponse> {
    return this.safeCall(async () => {
      const dto: DeleteUserRequestDTO = new DeleteUserRequestDTO({
        userId: userId,
        userName: userName,
        phone: phone
      });

      const url: string = Urls.DELETE_USER_URL;
      const body: string = JSON.stringify(dto);

      const holder: DeleteUserResponseHolder = new DeleteUserResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<StringResponse>(
          url,
          body,
          (data: HttpResultEntity<StringResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result
            } else {
              holder.errorMessage = data.reason || '删除用户失败';
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

      return holder.data ?? new StringResponse();
    });
  }
}
