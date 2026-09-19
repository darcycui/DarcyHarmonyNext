/**
 * ConversationRepository - 会话数据仓库
 *
 * 继承 BaseRepository，统一封装会话相关的数据访问层。
 * 通过 HttpHelper.doPost 调用获取会话列表 API。
 *
 * 架构流向：
 *   UseCase → ConversationRepository → HttpHelper.doPost
 */
import { BaseRepository, Log, ResponseHolder } from 'static_library_common';
import {
  HttpHelper,
  HttpCertHelper,
  HttpErrorEntity,
  HttpResultEntity,
  CommonRequestDTO,
  ConversationCreateRequestDTO,
  ConversationResponse
} from 'library_network';
import { Urls } from 'library_login';

/**
 * 获取会话列表响应容器
 */
class FetchConversationListResponseHolder extends ResponseHolder<ConversationResponse[]> {}

/**
 * 创建会话响应容器
 */
class CreateConversationResponseHolder extends ResponseHolder<ConversationResponse> {}

export class ConversationRepository extends BaseRepository {
  /**
   * 获取当前用户的会话列表
   *
   * @param userId - 当前用户 ID
   * @returns 会话列表
   */
  async fetchConversationList(userId: number): Promise<ConversationResponse[]> {
    return this.safeCall(async () => {
      const dto: CommonRequestDTO = new CommonRequestDTO({ userId });
      const url: string = Urls.QUERY_CONVERSATION_LIST_URL;
      const body: string = JSON.stringify(dto);

      const holder: FetchConversationListResponseHolder = new FetchConversationListResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<ConversationResponse[]>(
          url,
          body,
          (data: HttpResultEntity<ConversationResponse[]>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result;
            } else {
              holder.errorMessage = data.reason || '获取会话列表失败';
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

  /**
   * 创建会话
   *
   * @param userId - 当前用户 ID
   * @param targetId - 目标用户 ID
   * @param conversationType - 会话类型（1 表示单聊）
   * @returns 创建成功的会话
   */
  async createConversation(userId: number, targetId: number, conversationType: number): Promise<ConversationResponse> {
    return this.safeCall(async () => {
      const dto: ConversationCreateRequestDTO = new ConversationCreateRequestDTO({
        userId,
        targetId,
        conversationType
      });
      const url: string = Urls.CREATE_CONVERSATION_URL;
      const body: string = JSON.stringify(dto);

      const holder: CreateConversationResponseHolder = new CreateConversationResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<ConversationResponse>(
          url,
          body,
          (data: HttpResultEntity<ConversationResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result;
            } else {
              holder.errorMessage = data.reason || '创建会话失败';
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
