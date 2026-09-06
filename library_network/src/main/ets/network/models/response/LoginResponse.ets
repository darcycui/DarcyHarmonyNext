export class LoginResponse {
  username: string = "";
  passwordHash: string = "";
  nickname: string = "";
  avatar: string = "";
  phone: string = "";
  email: string = "";
  gender: string = "";
  age: number = 0;
  signature: string = "";
  status: number = 0;
  onlineStatus: number = 0;
  lastActiveTime: string = "";
  deletedAt: string = "";
  settings: Map<string, string> = new Map();
  roles: string = "";
  token: string = "";
  id: number = 0;
  createdAt: string = "";
  updatedAt: string = "";
}
