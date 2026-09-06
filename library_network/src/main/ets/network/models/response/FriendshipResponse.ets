import { UserResponse } from './UserResponse';

export class FriendshipResponse {
  user: UserResponse = new UserResponse();
  friend: UserResponse = new UserResponse();
  alias: string = "";
  relationStatus: number = 0;
  source: string = "";
  greeting: string = "";
  addedAt: string = "";
  isBlocked: boolean = false;
  isMuted: boolean = false;
  isPinned: boolean = false;
  id: number = 0;
  createdAt: string = "";
  updatedAt: string = "";
}
