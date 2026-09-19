/**
 * ContactState - 联系人页面统一状态类
 *
 * 封装搜索用户和申请好友的可观察状态。
 *
 * @ObservedV2 - 标记为可观察类
 * @Trace     - 标记属性为可观察，属性变化时触发关联组件重渲染
 */
import { IState, ScreenState } from 'static_library_common';
import { UserResponse, ApplyFriendResponse } from 'library_network';

@ObservedV2
export default class ApplyFriendState implements IState {
  /** 屏幕状态（加载中/错误/成功等） */
  @Trace screenState: ScreenState = new ScreenState();
  /** 搜索手机号 */
  @Trace searchPhone: string = '';
  /** 搜索结果列表 */
  @Trace searchResults: UserResponse[] = [];
  /** 我发出的好友请求列表 */
  @Trace sentFriendRequests: ApplyFriendResponse[] = [];
}
