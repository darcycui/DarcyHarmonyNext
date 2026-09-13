import { IUIBean } from "../../IUIBean";

/**
 * 用户列表项 Bean
 *
 * 对应 Kotlin 中的 UserItemBean
 * 字段映射：
 *   - id       : 用户 ID（Long，默认 -1）
 *   - name     : 用户名（String）
 *   - phone    : 手机号（String）
 *   - nickName : 昵称（String）
 *   - avatar   : 头像（String）
 *   - age      : 年龄（Int）
 *   - sex      : 性别（String）
 */
export class UserItemBean implements IUIBean {
  /**
   * 用户 ID
   */
  id: number = -1;

  /**
   * 用户名
   */
  name: string = '';

  /**
   * 手机号
   */
  phone: string = '';

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
  sex: string = '';

  constructor(
    id?: number,
    name?: string,
    phone?: string,
    nickName?: string,
    avatar?: string,
    age?: number,
    sex?: string,
  ) {
    if (id !== undefined) {
      this.id = id;
    }
    if (name !== undefined) {
      this.name = name;
    }
    if (phone !== undefined) {
      this.phone = phone;
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
