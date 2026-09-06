export class DHExchangeResponse {
  id: number = 0;
  userId: number = 0;
  sessionId: string = "";
  publicKey: string = "";
  keySize: number = 2048;
  algorithm: string = "";
  isCompleted: boolean = false;
  isExpired: boolean = false;
  expiresAt: string = "";
  completedAt: string = "";
  createdAt: string = "";
  updatedAt: string = "";
}
