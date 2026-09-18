/**
 * AcceptFriendIntent - 好友申请页面专属 Intent 定义
 *
 * 采用子类继承体系，每个 Intent 为独立子类，携带自身所需数据。
 * dispatch 通过 instanceof 进行分支判断。
 *
 * ─── 使用示例 ───────────────────────────────────
 *   dispatch(new QueryFriendRequestsIntent())
 *   dispatch(new AcceptFriendIntent(friendRequestId, remoteUserId))
 */
import { IIntent } from 'static_library_common';

export class AcceptFriendBaseIntent implements IIntent {
}

/**
 * 查询好友请求 Intent
 */
export class QueryFriendRequestsIntent extends AcceptFriendBaseIntent {
}

/**
 * 同意好友请求 Intent
 */
export class AcceptFriendIntent extends AcceptFriendBaseIntent {
  friendRequestId: number = 0;
  remoteUserId: number = 0;

  constructor(friendRequestId: number, remoteUserId: number) {
    super();
    this.friendRequestId = friendRequestId;
    this.remoteUserId = remoteUserId;
  }
}
