/**
 * RegisterRepository - 注册数据仓库
 *
 * 继承 BaseRepository，统一封装注册相关的数据访问层。
 * 通过 httpHelper.doPost 调用注册 API，返回 HttpResultEntity<UserResponse>。
 *
 * 架构流向：
 *   RegisterUseCase → RegisterRepository → httpHelper.doPost
 */
import { BaseRepository, HashUtil, ArrayUtil } from 'static_library_common';
import {
  doPost,
  BASE_HTTP_URL,
  HttpResultEntity,
  HttpErrorEntity,
  RegisterRequestDTO,
  UserResponse,
  HttpCertHelper
} from 'library_network';
import { Urls } from '../../../http/Urls';

/**
 * 注册响应结果
 */
export interface RegisterResult {
  success: boolean;
  message: string;
}

/**
 * 注册响应数据容器——用于在异步回调间安全传递数据
 */
class RegisterResponseHolder {
  data: RegisterResult = {
    success: false,
    message: ''
  };
  errorMessage: string = '';
}

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
  ): Promise<RegisterResult> {
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

      const url: string = BASE_HTTP_URL + Urls.REGISTER_URL;
      const body: string = JSON.stringify(dto);

      // 使用容器对象在回调间传递数据，避免 Promise reject 中的 any 类型
      const holder: RegisterResponseHolder = new RegisterResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        doPost<UserResponse>(
          url,
          body,
          (data: HttpResultEntity<UserResponse>): void => {
            if (data.resultcode === 0 || data.error_code === 0) {
              holder.data = {
                success: true,
                message: '注册成功'
              };
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

      return holder.data;
    });
  }
}
