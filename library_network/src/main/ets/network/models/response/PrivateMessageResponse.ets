export class PrivateMessageResponse {
  msgId: string = "";
  senderId: number = 0;
  senderName: string = "";
  receiverId: number = 0;
  receiverName: string = "";
  content: string = "";
  msgType: string = "TEXT";
  sendTime: string = "";
  isRead: boolean = false;
  isSent: boolean = false;
  isRecalled: boolean = false;
  dhPublicKey: string = "";
  nKey: number = 0;
  pnKey: number = 0;
}
