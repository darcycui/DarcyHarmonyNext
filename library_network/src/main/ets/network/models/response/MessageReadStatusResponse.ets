export class MessageReadStatusResponse {
  id: number = 0;
  msgIds: string[] = [];
  userId: number = 0;
  conversationType: number = 1;
  targetId: number = 0;
  isRead: boolean = false;
  readTime: string = "";
  clientType: string = "";
  deviceId: string = "";
}
