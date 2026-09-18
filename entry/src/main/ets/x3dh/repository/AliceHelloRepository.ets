/**
 * AliceHelloRepository - Alice Hello 消息数据仓库
 *
 * 继承 BaseRepository，统一封装 X3DH Alice Hello 消息的推送与拉取。
 * 通过 HttpHelper.doPost 调用服务端 API，返回对应的响应对象。
 *
 * 架构流向：
 *   UseCase → AliceHelloRepository → HttpHelper.doPost
 */
import { BaseRepository } from 'static_library_common';
import {
  X3DHPushHelloRequestDTO,
  X3DHPullHelloRequestDTO,
  X3DHAliceHelloPushResponse,
  X3DHAliceHelloPullResponse,
  HttpHelper,
  HttpErrorEntity,
  HttpResultEntity
} from 'library_network';
import { Urls } from 'library_login/src/main/ets/http/Urls';

/**
 * Alice Hello 推送响应数据容器——用于在异步回调间安全传递数据
 */
class PushHelloResponseHolder {
  data: X3DHAliceHelloPushResponse = new X3DHAliceHelloPushResponse();
  errorMessage: string = '';
}

/**
 * Alice Hello 拉取响应数据容器——用于在异步回调间安全传递数据
 */
class PullHelloResponseHolder {
  data: X3DHAliceHelloPullResponse = new X3DHAliceHelloPullResponse();
  errorMessage: string = '';
}

export class AliceHelloRepository extends BaseRepository {
  /**
   * 推送 Alice Hello 消息
   *
   * @param aliceUserId - Alice 用户 ID（发起方）
   * @param bobUserId - Bob 用户 ID（接收方）
   * @param aliceIdentityKey - Alice 的身份密钥
   * @param aliceEphemeralKey - Alice 的临时密钥
   * @param bobOneTimePreKeyId - Bob 的一次性预密钥 ID
   * @returns 推送响应
   */
  async pushAliceHello(
    aliceUserId: number,
    bobUserId: number,
    aliceIdentityKey: string,
    aliceEphemeralKey: string,
    bobOneTimePreKeyId: string
  ): Promise<X3DHAliceHelloPushResponse> {
    return this.safeCall(async () => {
      const dto: X3DHPushHelloRequestDTO = new X3DHPushHelloRequestDTO({
        aliceUserId,
        bobUserId,
        aliceIdentityKey,
        aliceEphemeralKey,
        bobOneTimePreKeyId
      });

      const url: string = Urls.PUSH_ALICE_HELLO_MESSAGE_URL;
      const body: string = JSON.stringify(dto);

      const holder: PushHelloResponseHolder = new PushHelloResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<X3DHAliceHelloPushResponse>(
          url,
          body,
          (data: HttpResultEntity<X3DHAliceHelloPushResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result;
            } else {
              holder.errorMessage = data.reason || '推送 Alice Hello 消息失败';
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

  /**
   * 拉取 Alice Hello 消息
   *
   * @param aliceUserId - Alice 用户 ID（发起方）
   * @param bobUserId - Bob 用户 ID（接收方）
   * @returns 拉取响应
   */
  async pullAliceHello(
    aliceUserId: number,
    bobUserId: number
  ): Promise<X3DHAliceHelloPullResponse> {
    return this.safeCall(async () => {
      const dto: X3DHPullHelloRequestDTO = new X3DHPullHelloRequestDTO({
        aliceUserId,
        bobUserId
      });

      const url: string = Urls.PULL_ALICE_HELLO_MESSAGE_URL;
      const body: string = JSON.stringify(dto);

      const holder: PullHelloResponseHolder = new PullHelloResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<X3DHAliceHelloPullResponse>(
          url,
          body,
          (data: HttpResultEntity<X3DHAliceHelloPullResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result;
            } else {
              holder.errorMessage = data.reason || '拉取 Alice Hello 消息失败';
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
