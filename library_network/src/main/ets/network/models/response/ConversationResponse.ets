import { UserResponse } from './UserResponse';

export class ConversationResponse {
  conversationId: string = "";
  user: UserResponse = new UserResponse();
  conversationType: number = 0;
  target: UserResponse = new UserResponse();
  lastMsgId: string = "";
  lastMsgContent: string = "";
  lastMsgType: number = 0;
  lastMsgSenderId: number = 0;
  lastMsgTime: string = "";
  unreadCount: number = 0;
  isMuted: boolean = false;
  isPinned: boolean = false;
  isTop: boolean = false;
  draft: string = "";
  draftTime: string = "";
  extData: Map<string, string> = new Map();
  id: number = 0;
  createdAt: string = "";
  updatedAt: string = "";
}
