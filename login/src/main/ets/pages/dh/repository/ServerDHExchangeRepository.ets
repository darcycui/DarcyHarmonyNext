/**
 * ServerDHExchangeRepository - DH 密钥交换数据仓库
 *
 * 继承 BaseRepository，统一封装 DH 密钥交换相关的数据访问层。
 * 通过 httpHelper.doPost 调用 DH 交换 API，返回 DHExchangeResponse。
 *
 * 架构流向：
 *   ServerDHExchangeUseCase → ServerDHExchangeRepository → httpHelper.doPost
 */
import { BaseRepository } from 'static_library_common';
import {
  doPost,
  BASE_HTTP_URL,
  HttpResultEntity,
  HttpErrorEntity,
  DHExchangeRequestDTO,
  DHExchangeResponse
} from 'library_network';
import { Urls } from '../../../http/Urls';

/**
 * DH 交换响应数据容器——用于在异步回调间安全传递数据
 */
class DHExchangeResponseHolder {
  data: DHExchangeResponse = new DHExchangeResponse();
  message: string = '';
  errorMessage: string = '';
}

export class ServerDHExchangeRepository extends BaseRepository {
  /**
   * 执行 DH 密钥交换请求
   *
   * @param userId - 用户 ID
   * @param publicKey - 客户端生成的 X25519 公钥（Base64 编码）
   * @returns DH 交换响应
   */
  async doExchange(userId: number, publicKey: string): Promise<DHExchangeResponse> {
    return this.safeCall(async () => {
      // 构建请求 DTO
      const dto: DHExchangeRequestDTO = new DHExchangeRequestDTO({
        userId: userId,
        publicKey: publicKey
      });

      const url: string = BASE_HTTP_URL + Urls.DH_EXCHANGE_URL;
      const body: string = JSON.stringify(dto);

      // 使用容器对象在回调间传递数据，避免 Promise reject 中的 any 类型
      const holder: DHExchangeResponseHolder = new DHExchangeResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        doPost<DHExchangeResponse>(
          url,
          body,
          (data: HttpResultEntity<DHExchangeResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result
            } else {
              holder.errorMessage = data.reason || 'DH 密钥交换失败';
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
