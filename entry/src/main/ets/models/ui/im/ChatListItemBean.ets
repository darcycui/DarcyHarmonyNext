import { IUIBean } from "../../IUIBean";

/**
 * 聊天列表项 Bean
 *
 * 对应 Kotlin 中的 ChatListItemBean
 * 字段映射：
 *   - id       : 聊天 ID（Long，默认 -1）
 *   - title    : 标题（String）
 *   - subTitle : 副标题（String）
 *   - avatar   : 头像（String）
 */
export class ChatListItemBean implements IUIBean {
  /**
   * 聊天 ID
   */
  id: number = -1;

  /**
   * 标题
   */
  title: string = '';

  /**
   * 副标题
   */
  subTitle: string = '';

  /**
   * 头像
   */
  avatar: string = '';

  constructor(id?: number, title?: string, subTitle?: string, avatar?: string) {
    if (id !== undefined) {
      this.id = id;
    }
    if (title !== undefined) {
      this.title = title;
    }
    if (subTitle !== undefined) {
      this.subTitle = subTitle;
    }
    if (avatar !== undefined) {
      this.avatar = avatar;
    }
  }
}
