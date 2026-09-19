/**
 * ContactState - 联系人列表页面统一状态类
 *
 * 封装好友列表和屏幕状态。
 *
 * @ObservedV2 - 标记为可观察类
 * @Trace     - 标记属性为可观察，属性变化时触发关联组件重渲染
 */
import { IState, ScreenState } from 'static_library_common';
import { FriendshipResponse } from 'library_network';

@ObservedV2
export default class ContactState implements IState {
  /** 屏幕状态（加载中/错误/成功等） */
  @Trace screenState: ScreenState = new ScreenState();
  /** 好友列表 */
  @Trace friends: FriendshipResponse[] = [];
  /** 最近创建成功的会话 ID（点击好友创建会话成功后填充，供页面跳转聊天页使用） */
  @Trace createdConversationId: string = '';
}
