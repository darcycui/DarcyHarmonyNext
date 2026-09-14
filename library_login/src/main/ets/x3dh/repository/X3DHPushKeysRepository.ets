/**
 * X3DHPushKeysRepository - X3DH 密钥推送数据仓库
 *
 * 职责：
 *  - 封装推送 X3DH 密钥材料的网络请求
 *  - 通过 doPost 调用推送密钥 API
 *  - 返回 X3DHKeysPushResponse
 *
 * 架构流向：
 *   PushX3DHKeysUseCase → X3DHPushKeysRepository → doPost
 */
import { BaseRepository } from 'static_library_common';
import {
  X3DHPushKeysRequestDTO,
  X3DHKeysPushResponse,
  HttpHelper,
  HttpResultEntity,
  HttpErrorEntity,
  OneTimePreKeyInputDTO
} from 'library_network';
import { Urls } from '../../http/Urls';

/**
 * X3DH 密钥推送响应数据容器——用于在异步回调间安全传递数据
 */
class X3DHPushKeysResponseHolder {
  data: X3DHKeysPushResponse = new X3DHKeysPushResponse();
  errorMessage: string = '';
}

export class X3DHPushKeysRepository extends BaseRepository {
  /**
   * 推送 X3DH 密钥材料到服务端
   *
   * @param userId - 用户 ID
   * @param identityKey - 身份密钥
   * @param signedPreKey - 签名预密钥
   * @param oneTimePreKeys - 一次性预密钥列表（OneTimePreKeyRequestDTO[]）
   * @returns X3DHKeysPushResponse
   */
  async pushX3DHKeys(
    userId: number,
    identityKey: string,
    signedPreKey: string,
    oneTimePreKeys: OneTimePreKeyInputDTO[]
  ): Promise<X3DHKeysPushResponse> {
    return this.safeCall(async () => {
      const dto: X3DHPushKeysRequestDTO = new X3DHPushKeysRequestDTO({
        userId: userId,
        identityKey: identityKey,
        signedPreKey: signedPreKey,
        oneTimePreKeys: oneTimePreKeys
      });

      const url: string = Urls.PUSH_X3DH_KEYS_URL;
      const body: string = JSON.stringify(dto);

      const holder: X3DHPushKeysResponseHolder = new X3DHPushKeysResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<X3DHKeysPushResponse>(
          url,
          body,
          (data: HttpResultEntity<X3DHKeysPushResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result;
            } else {
              holder.errorMessage = data.reason || '推送 X3DH 密钥失败';
            }
            resolve();
          },
          (error: HttpResultEntity<HttpErrorEntity>): void => {
            holder.errorMessage = error.result?.message || '网络请求失败';
            resolve();
          }
        );
      });

      if (holder.errorMessage) {
        throw new Error(holder.errorMessage);
      }

      return holder.data;
    });
  }
}
