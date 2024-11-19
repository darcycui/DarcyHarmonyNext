import { AbilityConstant, AbilityStage, Configuration, Want } from '@kit.AbilityKit'
import { InitCommon, Log } from 'static_common'
import { AppInfo } from '../utils/AppInfo'

export default class MyAbilityStage extends AbilityStage {
  // 获取类名
  TAG: string = this.constructor.name

  onCreate() {
    initLibraryCommon()
    Log.log(`${this.TAG} onCreate`)
  }

  /**
   * specified UIAbility 触发
   * @param want
   * @returns 返回指定UiAbility的tag
   */
  onAcceptWant(want: Want): string {
    Log.log(`${this.TAG} onAcceptWant want=${JSON.stringify(want)}`)
    return ""
  }

  onNewProcessRequest(want: Want): string {
    Log.log(`${this.TAG} MyAbilityStage onNewProcessRequest want=$\{JSON.stringify(want)}`)
    return ""
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    Log.warn(`${this.TAG} MyAbilityStage onConfigurationUpdate ${JSON.stringify(newConfig)}`)
  }

  onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
    Log.warn(`${this.TAG} MyAbilityStage onMemoryLevel ${level}`)
  }

  onDestroy(): void {
  }
}

function initLibraryCommon() {
  InitCommon.init(AppInfo.isDebug())
}