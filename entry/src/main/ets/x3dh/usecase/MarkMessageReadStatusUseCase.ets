/**
 * MarkMessageReadStatusUseCase - 批量标记消息为已读
 *
 * 职责：
 *  - 根据消息已读状态响应，批量更新/插入已读记录
 *  - 返回更新后的已读状态列表
 *
 * 架构流向：
 *   ViewModel → MarkMessageReadStatusUseCase → MessageReadStatusDao
 */
import { BaseUseCase } from 'static_library_common';
import { Log } from 'static_library_common';
import { DarcyIMDatabase, MessageReadStatusEntity } from 'library_database';
import { MessageReadStatusResponse } from 'library_network';

/**
 * 标记消息已读入参
 */
export interface MarkMessageReadStatusParams {
  /** 消息已读状态响应 JSON 字符串 */
  messageReadStatusResponse: string;
}

/**
 * 批量标记消息为已读
 *
 * 返回 MessageReadStatusEntity[]
 */
export class MarkMessageReadStatusUseCase extends BaseUseCase<MarkMessageReadStatusParams, MessageReadStatusEntity[]> {
  private messageReadStatusDao = DarcyIMDatabase.getInstance().getMessageReadStatusDao();

  async execute(params: MarkMessageReadStatusParams): Promise<MessageReadStatusEntity[]> {
    const responseStr = params.messageReadStatusResponse;

    // 校验参数
    if (!responseStr) {
      throw new Error('消息参数不能为空');
    }

    // 解析响应
    let messageReadStatusResponse: MessageReadStatusResponse;
    try {
      messageReadStatusResponse = JSON.parse(responseStr) as MessageReadStatusResponse;
    } catch {
      throw new Error('消息参数格式错误');
    }

    const userId = messageReadStatusResponse.userId;
    const msgIds = messageReadStatusResponse.msgIds;
    const now = Date.now().toString();

    for (const msgId of msgIds) {
      // 查询是否已存在记录
      const existingList = await this.messageReadStatusDao.getByUserId(userId);
      const existing = existingList.find((item) => item.msgId === msgId);

      if (existing) {
        // 更新为已读
        await this.messageReadStatusDao.markAsRead(msgId, userId, now);
      } else {
        // 插入新的已读记录
        const entity = new MessageReadStatusEntity(
          undefined,
          msgId,
          userId,
          0,
          true,
          1,
          now,
          now,
          now,
        );
        await this.messageReadStatusDao.insert(entity);
      }
    }

    // 查询返回更新后的列表
    const readList: MessageReadStatusEntity[] = [];
    for (const msgId of msgIds) {
      const list = await this.messageReadStatusDao.getByUserId(userId);
      const found = list.find((item) => item.msgId === msgId);
      if (found) {
        readList.push(found);
      }
    }

    Log.log(`更新了${readList.length} 条消息为已读`);
    return readList;
  }
}
