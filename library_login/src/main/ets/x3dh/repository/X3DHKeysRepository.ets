/**
 * X3DHKeysRepository - X3DH 密钥拉取数据仓库
 *
 * 继承 BaseRepository，统一封装 X3DH 密钥相关的数据访问层。
 * 通过 httpHelper.doPost 调用拉取 Bob 密钥的 API，返回 X3DHKeysPullResponse。
 *
 * 架构流向：
 *   PullX3DHKeysUseCase → X3DHKeysRepository → httpHelper.doPost
 */
import { BaseRepository } from 'static_library_common';
import {
  X3DHPullKeysRequestDTO,
  X3DHKeysPullResponse,
  HttpHelper,
  HttpErrorEntity,
  HttpResultEntity
} from 'library_network';
import { Urls } from '../../http/Urls';

/**
 * X3DH 密钥拉取响应数据容器——用于在异步回调间安全传递数据
 */
class X3DHKeysResponseHolder {
  data: X3DHKeysPullResponse = new X3DHKeysPullResponse();
  message: string = '';
  errorMessage: string = '';
}

export class X3DHKeysRepository extends BaseRepository {
  /**
   * 拉取 Bob 的 X3DH 密钥材料
   *
   * @param aliceUserId - Alice 用户 ID（发起方）
   * @param bobUserId - Bob 用户 ID（接收方）
   * @returns Bob 的 X3DH 密钥材料
   */
  async pullBobKeys(aliceUserId: number, bobUserId: number): Promise<X3DHKeysPullResponse> {
    return this.safeCall(async () => {
      // 构建请求 DTO
      const dto: X3DHPullKeysRequestDTO = new X3DHPullKeysRequestDTO({
        aliceUserId: aliceUserId,
        bobUserId: bobUserId
      });

      const url: string = Urls.PULL_X3DH_KEYS_URL;
      const body: string = JSON.stringify(dto);

      // 使用容器对象在回调间传递数据，避免 Promise reject 中的 any 类型
      const holder: X3DHKeysResponseHolder = new X3DHKeysResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<X3DHKeysPullResponse>(
          url,
          body,
          (data: HttpResultEntity<X3DHKeysPullResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result;
            } else {
              holder.errorMessage = data.reason || '拉取 Bob 密钥失败';
            }
            resolve();
          },
          (error: HttpResultEntity<HttpErrorEntity>): void => {
            holder.errorMessage = error.result?.message || '网络请求失败';
            resolve();
          }
        );
      });

      // 检查是否发生错误
      if (holder.errorMessage) {
        throw new Error(holder.errorMessage);
      }

      return holder.data;
    });
  }
}
