import { AbilityConstant, AbilityStage, Configuration, Want } from '@kit.AbilityKit'
import { Log } from '../utils/Log'

export abstract class BaseAbilityState extends AbilityStage {
  /**
   * 使用构造函数名作为日志TAG，支持多态：子类无需重复定义即可获得正确的类名
   */
  TAG: string = this.constructor.name

  /**
   * AbilityStage 创建时触发
   * 子类可重写 onStageCreate() 以在日志前插入自定义初始化逻辑
   */
  onCreate(): void {
    this.onStageCreate()
    Log.log(`${this.TAG} onCreate`)
  }

  /**
   * 子类在此方法中实现自定义 onCreate 逻辑（例如初始化公共库）
   * 在基类打印日志之前调用
   */
  protected onStageCreate(): void {
    // 默认空实现，子类按需重写
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
    Log.log(`${this.TAG} onNewProcessRequest want=${JSON.stringify(want)}`)
    return ""
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    Log.warn(`${this.TAG} onConfigurationUpdate ${JSON.stringify(newConfig)}`)
  }

  onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
    Log.warn(`${this.TAG} onMemoryLevel ${level}`)
  }

  onDestroy(): void {
    Log.log(`${this.TAG} onDestroy`)
  }
}
