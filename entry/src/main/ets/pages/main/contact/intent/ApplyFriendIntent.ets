/**
 * ContactIntent - 联系人页面专属 Intent 定义
 *
 * 采用子类继承体系，每个 Intent 为独立子类，携带自身所需数据。
 * dispatch 通过 instanceof 进行分支判断。
 *
 * ─── 使用示例 ───────────────────────────────────
 *   dispatch(new SearchUserIntent('13800001111'))
 *   dispatch(new ApplyFriendIntent(1, 2))
 *   dispatch(new QuerySentFriendRequestsIntent())
 */
import { IIntent } from 'static_library_common';

export class ContactIntent implements IIntent {
}

/**
 * 搜索用户 Intent
 */
export class SearchUserIntent extends ContactIntent {
  phone: string = '';

  constructor(phone: string) {
    super();
    this.phone = phone;
  }
}

/**
 * 申请好友 Intent
 */
export class ApplyFriendIntent extends ContactIntent {
  fromUserId: number = 0;
  toUserId: number = 0;

  constructor(fromUserId: number, toUserId: number) {
    super();
    this.fromUserId = fromUserId;
    this.toUserId = toUserId;
  }
}

/**
 * 查询我发出的好友请求 Intent
 */
export class QuerySentFriendRequestsIntent extends ContactIntent {
}

/**
 * 切换视图模式 Intent（搜索用户 ↔ 已发送的好友请求）
 */
export class ToggleViewModeIntent extends ContactIntent {
}
