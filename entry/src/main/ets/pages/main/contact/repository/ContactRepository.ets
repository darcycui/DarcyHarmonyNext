/**
 * ContactRepository - 联系人数据仓库
 *
 * 继承 BaseRepository，统一封装联系人相关的数据访问层。
 * 通过 HttpHelper.doPost 调用搜索用户和申请好友 API。
 *
 * 架构流向：
 *   UseCase → ContactRepository → HttpHelper.doPost
 */
import { BaseRepository, Log, ResponseHolder } from 'static_library_common';
import {
  HttpHelper,
  HttpCertHelper,
  HttpErrorEntity,
  HttpResultEntity,
  UserQueryPhoneRequestDTO,
  UserResponse,
  FriendRequestCreateRequestDTO,
  FriendRequestQueryToRequestDTO,
  FriendRequestActionRequestDTO,
  ApplyFriendResponse
} from 'library_network';
import { Urls } from 'library_login';

/**
 * 搜索用户响应容器
 */
class SearchUserResponseHolder extends ResponseHolder<UserResponse> {}

/**
 * 申请好友响应容器
 */
class ApplyFriendResponseHolder extends ResponseHolder<ApplyFriendResponse> {}

/**
 * 查询好友请求响应容器
 */
class QueryFriendRequestsResponseHolder extends ResponseHolder<ApplyFriendResponse[]> {}

/**
 * 同意好友请求响应容器
 */
class AcceptFriendResponseHolder extends ResponseHolder<ApplyFriendResponse> {}

export class ContactRepository extends BaseRepository {
  /**
   * 根据手机号搜索用户
   *
   * @param phone - 手机号
   * @returns 搜索到的用户信息
   */
  async searchUserByPhone(phone: string): Promise<UserResponse> {
    return this.safeCall(async () => {
      const dto: UserQueryPhoneRequestDTO = new UserQueryPhoneRequestDTO({ phone });
      const url: string = Urls.SEARCH_FRIEND_URL;
      const body: string = JSON.stringify(dto);

      const holder: SearchUserResponseHolder = new SearchUserResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<UserResponse>(
          url,
          body,
          (data: HttpResultEntity<UserResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result;
            } else {
              holder.errorMessage = data.reason || '搜索用户失败';
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
   * 申请添加好友
   *
   * @param fromUserId - 发起者用户 ID
   * @param toUserId - 目标用户 ID
   * @returns 申请好友结果
   */
  async applyFriend(fromUserId: number, toUserId: number): Promise<ApplyFriendResponse> {
    return this.safeCall(async () => {
      const dto: FriendRequestCreateRequestDTO = new FriendRequestCreateRequestDTO({
        fromUserId,
        toUserId
      });
      const url: string = Urls.APPLY_FRIEND_URL;
      const body: string = JSON.stringify(dto);

      const holder: ApplyFriendResponseHolder = new ApplyFriendResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<ApplyFriendResponse>(
          url,
          body,
          (data: HttpResultEntity<ApplyFriendResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result;
            } else {
              holder.errorMessage = data.reason || '申请好友失败';
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
   * 查询发给我的好友请求
   *
   * @param toUserId - 当前用户 ID
   * @returns 好友请求列表
   */
  async queryFriendRequestsToMe(toUserId: number): Promise<ApplyFriendResponse[]> {
    return this.safeCall(async () => {
      const dto: FriendRequestQueryToRequestDTO = new FriendRequestQueryToRequestDTO({ toUserId });
      const url: string = Urls.QUERY_FRIEND_TO_URL;
      const body: string = JSON.stringify(dto);

      const holder: QueryFriendRequestsResponseHolder = new QueryFriendRequestsResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<ApplyFriendResponse[]>(
          url,
          body,
          (data: HttpResultEntity<ApplyFriendResponse[]>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result;
            } else {
              holder.errorMessage = data.reason || '查询好友请求失败';
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
   * 同意好友请求
   *
   * @param friendRequestId - 好友请求 ID
   * @returns 同意结果
   */
  async acceptFriendRequest(friendRequestId: number): Promise<ApplyFriendResponse> {
    return this.safeCall(async () => {
      const dto: FriendRequestActionRequestDTO = new FriendRequestActionRequestDTO({ friendRequestId });
      const url: string = Urls.ACCEPT_FRIEND_URL;
      const body: string = JSON.stringify(dto);

      const holder: AcceptFriendResponseHolder = new AcceptFriendResponseHolder();

      await new Promise<void>((resolve: () => void): void => {
        HttpHelper.doPost<ApplyFriendResponse>(
          url,
          body,
          (data: HttpResultEntity<ApplyFriendResponse>): void => {
            if (data.result != null && data.result != undefined && data.error_code === 0) {
              holder.data = data.result;
            } else {
              holder.errorMessage = data.reason || '同意好友请求失败';
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
