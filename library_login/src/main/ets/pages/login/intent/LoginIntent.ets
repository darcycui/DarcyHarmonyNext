/**
 * LoginIntent - 登录页面专属 Intent 定义
 *
 * 采用子类继承体系，每个 Intent 为独立子类，携带自身所需数据。
 * 所有子类直接继承 BaseIntent，dispatch 通过 instanceof 进行分支判断。
 *
 * ─── 使用示例 ───────────────────────────────────
 *   dispatch(new DoLoginIntent())
 *   dispatch(new UpdateUserNameIntent('admin'))
 *   dispatch(new UpdatePasswordIntent('123456'))
 */
import { IIntent } from 'static_library_common';

export class LoginIntent implements IIntent {
}

/**
 * 执行登录 Intent
 */
export class DoLoginIntent extends LoginIntent {
}

/**
 * 更新用户名 Intent
 */
export class UpdateUserNameIntent extends LoginIntent {
  value: string = ''

  constructor(value: string) {
    super()
    this.value = value
  }
}

/**
 * 更新密码 Intent
 */
export class UpdatePasswordIntent extends LoginIntent {
  value: string = ''

  constructor(value: string) {
    super()
    this.value = value
  }
}
