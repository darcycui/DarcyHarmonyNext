/**
 * ContactIntent - 联系人列表页面专属 Intent 定义
 *
 * 采用子类继承体系，每个 Intent 为独立子类，携带自身所需数据。
 * dispatch 通过 instanceof 进行分支判断。
 *
 * ─── 使用示例 ───────────────────────────────────
 *   dispatch(new FetchFriendsIntent())
 */
import { IIntent } from 'static_library_common';

/**
 * 联系人列表页面 Intent 基类
 */
export class ContactListIntent implements IIntent {
}

/**
 * 获取好友列表 Intent
 * 页面初始化 / 错误重试时触发
 */
export class FetchFriendsIntent extends ContactListIntent {
}

/**
 * 创建会话 Intent
 * 点击好友列表项时触发，携带目标用户 ID
 */
export class CreateConversationIntent extends ContactListIntent {
  /** 目标用户 ID */
  targetId: number;

  constructor(targetId: number) {
    super();
    this.targetId = targetId;
  }
}
