/**
 * 用户（User）实体类
 *
 * 对应数据库表名：user
 * 字段映射：
 *   - userId      : 主键，自增（Long 类型）
 *   - name        : 用户名（String）
 *   - nickName    : 昵称（String）
 *   - age         : 年龄（Int）
 *   - sex         : 性别（String）
 *   - avatar      : 头像（String）
 *   - createdTime : 创建时间（Long）
 *   - updatedTime : 更新时间（Long）
 *   - deletedTime : 删除时间（Long）
 */
export class UserEntity {
  /**
   * 主键，自增
   */
  userId: number = 0;

  /**
   * 用户名
   */
  name: string = '';

  /**
   * 昵称
   */
  nickName: string = '';

  /**
   * 年龄
   */
  age: number = 0;

  /**
   * 性别
   */
  sex: string = '';

  /**
   * 头像
   */
  avatar: string = '';

  /**
   * 创建时间
   */
  createdTime: number = 0;

  /**
   * 更新时间
   */
  updatedTime: number = 0;

  /**
   * 删除时间
   */
  deletedTime: number = 0;

  constructor(
    userId?: number,
    name?: string,
    nickName?: string,
    age?: number,
    sex?: string,
    avatar?: string,
    createdTime?: number,
    updatedTime?: number,
    deletedTime?: number,
  ) {
    if (userId !== undefined) {
      this.userId = userId;
    }
    if (name !== undefined) {
      this.name = name;
    }
    if (nickName !== undefined) {
      this.nickName = nickName;
    }
    if (age !== undefined) {
      this.age = age;
    }
    if (sex !== undefined) {
      this.sex = sex;
    }
    if (avatar !== undefined) {
      this.avatar = avatar;
    }
    if (createdTime !== undefined) {
      this.createdTime = createdTime;
    }
    if (updatedTime !== undefined) {
      this.updatedTime = updatedTime;
    }
    if (deletedTime !== undefined) {
      this.deletedTime = deletedTime;
    }
  }
}
