/**
 * 好友列表项 Bean
 *
 * 对应 Kotlin 中的 FriendsItemBean
 * 字段映射：
 *   - id       : 好友 ID（Long，默认 -1）
 *   - name     : 用户名（String）
 *   - nickName : 昵称（String）
 *   - avatar   : 头像（String）
 *   - age      : 年龄（Int）
 *   - sex      : 性别（Int）
 */
export class FriendsItemBean {
  /**
   * 好友 ID
   */
  id: number = -1;

  /**
   * 用户名
   */
  name: string = '';

  /**
   * 昵称
   */
  nickName: string = '';

  /**
   * 头像
   */
  avatar: string = '';

  /**
   * 年龄
   */
  age: number = 0;

  /**
   * 性别
   */
  sex: number = 0;

  constructor(id?: number, name?: string, nickName?: string, avatar?: string, age?: number, sex?: number) {
    if (id !== undefined) {
      this.id = id;
    }
    if (name !== undefined) {
      this.name = name;
    }
    if (nickName !== undefined) {
      this.nickName = nickName;
    }
    if (avatar !== undefined) {
      this.avatar = avatar;
    }
    if (age !== undefined) {
      this.age = age;
    }
    if (sex !== undefined) {
      this.sex = sex;
    }
  }
}
