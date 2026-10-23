/**
 * LoadChatMessagesUseCase - 加载聊天消息业务用例
 *
 * 架构流向：
 *   ChatEntryViewModel → LoadChatMessagesUseCase → ChatRepository
 */
import { NoParamUseCase } from 'static_library_common';
import { ChatItem } from '../../../../models/ui/im/ChatItem';
import { ChatRepository } from '../repository/ChatRepository';

export class LoadChatMessagesUseCase extends NoParamUseCase<ChatItem[]> {
  private repository: ChatRepository;

  constructor(repository: ChatRepository) {
    super();
    this.repository = repository;
  }

  protected async build(): Promise<ChatItem[]> {
    return this.repository.fetchMessages();
  }
}
