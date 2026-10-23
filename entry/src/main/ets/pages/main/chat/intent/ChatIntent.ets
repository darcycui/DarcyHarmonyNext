/**
 * ChatIntent - 聊天页面专属 Intent 定义
 *
 * dispatch 通过 instanceof 进行分支判断。
 */
import { IIntent } from 'static_library_common';

/**
 * 聊天页面 Intent 基类
 */
export class ChatIntent implements IIntent {
}

/**
 * 加载聊天消息 Intent
 * 页面初始化时触发
 */
export class LoadChatMessagesIntent extends ChatIntent {
}

/**
 * 发送聊天消息 Intent
 * 点击发送按钮时触发，携带消息内容
 */
export class SendChatMessageIntent extends ChatIntent {
  /** 消息内容 */
  message: string;

  constructor(message: string) {
    super();
    this.message = message;
  }
}
