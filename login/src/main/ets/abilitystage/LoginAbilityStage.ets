import { HttpCertHelper } from 'library_network'
import { InitCommon, BaseAbilityState } from 'static_library_common'
import { AppInfo } from '../utils/AppInfo'

export default class LoginAbilityStage extends BaseAbilityState {
  /**
   * 在基类打印日志前执行自定义初始化逻辑
   */
  protected onStageCreate(): void {
    InitCommon.init(this.context, AppInfo.isDebug())
    HttpCertHelper.initSelfCert(this.context)
  }
}
