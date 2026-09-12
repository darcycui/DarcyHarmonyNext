/**
 * RegisterIntent - 注册页面专属 Intent 定义
 *
 * 采用子类继承体系，每个 Intent 为独立子类，携带自身所需数据。
 * 所有子类直接继承 BaseIntent，dispatch 通过 instanceof 进行分支判断。
 *
 * ─── 使用示例 ───────────────────────────────────
 *   dispatch(new DoRegisterIntent())
 *   dispatch(new UpdateUserNameIntent('user'))
 *   dispatch(new UpdatePasswordIntent('123456'))
 *   dispatch(new UpdatePhoneIntent('13800138000'))
 *   dispatch(new UpdateNicknameIntent('nick'))
 *   dispatch(new UpdateEmailIntent('user@example.com'))
 */
import { IIntent } from 'static_library_common';

export class RegisterIntent implements IIntent {
}

/**
 * 执行注册 Intent
 */
export class DoRegisterIntent extends RegisterIntent {
}

/**
 * 更新用户名 Intent
 */
export class UpdateRegisterUserNameIntent extends RegisterIntent {
  value: string = ''

  constructor(value: string) {
    super()
    this.value = value
  }
}

/**
 * 更新密码 Intent
 */
export class UpdateRegisterPasswordIntent extends RegisterIntent {
  value: string = ''

  constructor(value: string) {
    super()
    this.value = value
  }
}

/**
 * 更新手机号 Intent
 */
export class UpdatePhoneIntent extends RegisterIntent {
  value: string = ''

  constructor(value: string) {
    super()
    this.value = value
  }
}

/**
 * 更新昵称 Intent
 */
export class UpdateNicknameIntent extends RegisterIntent {
  value: string = ''

  constructor(value: string) {
    super()
    this.value = value
  }
}

/**
 * 更新邮箱 Intent
 */
export class UpdateEmailIntent extends RegisterIntent {
  value: string = ''

  constructor(value: string) {
    super()
    this.value = value
  }
}
