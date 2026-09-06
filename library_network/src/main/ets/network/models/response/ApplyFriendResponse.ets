import { UserResponse } from './UserResponse';

export class ApplyFriendResponse {
  fromUser: UserResponse = new UserResponse();
  toUser: UserResponse = new UserResponse();
  greeting: string = "";
  remark: string = "";
  /**
   *  PENDING(1),    // 1-待处理
   *  ACCEPTED(2),   // 2-已接受
   *  REJECTED(3),   // 3-已拒绝
   *  IGNORED(4),    // 4-已忽略
   *  EXPIRED(5)     // 5-已过期
   */
  status: number = 0;
  handleTime: string = "";
  handleResult: string = "";
  id: number = 0;
  createdAt: string = "";
  updatedAt: string = "";
}
