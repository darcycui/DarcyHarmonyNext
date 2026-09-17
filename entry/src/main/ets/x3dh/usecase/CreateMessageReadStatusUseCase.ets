/**
 * CreateMessageReadStatusUseCase - 创建消息已读状态记录
 *
 * 职责：
 *  - 根据 STOMP 消息创建消息已读状态实体
 *  - 插入数据库并返回
 *
 * 架构流向：
 *   ViewModel → CreateMessageReadStatusUseCase → MessageReadStatusDao
 */
import { BaseUseCase } from 'static_library_common';
import { Log } from 'static_library_common';
import { DarcyIMDatabase, MessageReadStatusEntity } from 'library_database';
import { STOMPMessage } from 'library_network';

/**
 * 创建消息已读状态入参
 */
export interface CreateMessageReadStatusParams {
  /** STOMP 消息 JSON 字符串 */
  stompMessage: string;
}

/**
 * 创建消息已读状态
 *
 * 返回 MessageReadStatusEntity
 */
export class CreateMessageReadStatusUseCase extends BaseUseCase<CreateMessageReadStatusParams, MessageReadStatusEntity> {
  private messageReadStatusDao = DarcyIMDatabase.getInstance().getMessageReadStatusDao();

  async execute(params: CreateMessageReadStatusParams): Promise<MessageReadStatusEntity> {
    const stompMessageStr = params.stompMessage;

    // 校验参数
    if (!stompMessageStr) {
      throw new Error('消息参数不能为空');
    }

    // 解析 STOMP 消息
    let stompMessage: STOMPMessage;
    try {
      stompMessage = JSON.parse(stompMessageStr) as STOMPMessage;
    } catch {
      throw new Error('消息参数格式错误');
    }

    // 构建已读状态实体
    const messageReadStatus = new MessageReadStatusEntity(
      undefined,
      stompMessage.msgId,
      stompMessage.senderId,
      stompMessage.receiverId,
      false,
    );

    // 先删除已有记录（同一用户同一消息）
    const existingList = await this.messageReadStatusDao.getByUserId(messageReadStatus.userId);
    for (const existing of existingList) {
      if (existing.msgId === messageReadStatus.msgId) {
        await this.messageReadStatusDao.deleteById(existing.id);
        break;
      }
    }

    // 插入新记录
    await this.messageReadStatusDao.insert(messageReadStatus);

    Log.log(`创建消息已读状态成功: msgId=${messageReadStatus.msgId}, userId=${messageReadStatus.userId}`);
    return messageReadStatus;
  }
}
