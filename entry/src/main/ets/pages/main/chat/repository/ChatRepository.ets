/**
 * ChatRepository - 聊天数据仓库
 *
 * 当前使用本地 mock 数据，后续可替换为网络或数据库实现。
 *
 * 架构流向：
 *   UseCase → ChatRepository
 */
import { BaseRepository, Log } from 'static_library_common';
import { ChatItem } from '../../../../models/ui/im/ChatItem';

export class ChatRepository extends BaseRepository {
  /** mock 聊天消息 */
  private mockMessages: ChatItem[] = [
    new ChatItem(200, 'Jerry', '你好 我是一只小老鼠'),
    new ChatItem(101, 'Tom', '你好 我是一只老猫')
  ];

  /**
   * 获取聊天消息
   *
   * @returns 聊天消息列表
   */
  async fetchMessages(): Promise<ChatItem[]> {
    return this.safeCall(async () => {
      Log.info(`[ChatRepository] 获取聊天消息: ${this.mockMessages.length} 条`);
      return this.mockMessages.slice();
    });
  }

  /**
   * 发送聊天消息
   *
   * @param message - 消息内容
   * @returns 新消息
   */
  async sendMessage(message: string): Promise<ChatItem> {
    return this.safeCall(async () => {
      const item: ChatItem = new ChatItem(101, 'Tom', message);
      this.mockMessages.push(item);
      Log.info(`[ChatRepository] 发送聊天消息: ${message}`);
      return item;
    });
  }
}
