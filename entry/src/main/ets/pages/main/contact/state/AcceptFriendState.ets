/**
 * AcceptFriendState - 好友申请页面统一状态类
 *
 * 封装好友请求列表和屏幕状态。
 *
 * @ObservedV2 - 标记为可观察类
 * @Trace     - 标记属性为可观察，属性变化时触发关联组件重渲染
 */
import { IState, ScreenState } from 'static_library_common';
import { ApplyFriendResponse } from 'library_network';

@ObservedV2
export default class AcceptFriendState implements IState {
  /** 屏幕状态（加载中/错误/成功等） */
  @Trace screenState: ScreenState = new ScreenState();
  /** 好友请求列表（发给我的） */
  @Trace friendRequests: ApplyFriendResponse[] = [];
}
