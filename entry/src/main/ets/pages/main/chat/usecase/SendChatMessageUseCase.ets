/**
 * SendChatMessageUseCase - 发送聊天消息业务用例
 *
 * 架构流向：
 *   ChatEntryViewModel → SendChatMessageUseCase → ChatRepository
 */
import { BaseUseCase } from 'static_library_common';
import { ChatItem } from '../../../../models/ui/im/ChatItem';
import { ChatRepository } from '../repository/ChatRepository';

/**
 * 发送聊天消息入参
 */
export interface SendChatMessageParams {
  /** 消息内容 */
  message: string;
}

export class SendChatMessageUseCase extends BaseUseCase<SendChatMessageParams, ChatItem> {
  private repository: ChatRepository;

  constructor(repository: ChatRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: SendChatMessageParams): Promise<ChatItem> {
    if (!params.message || params.message.trim().length === 0) {
      throw new Error('消息内容不能为空');
    }

    return this.repository.sendMessage(params.message.trim());
  }
}
