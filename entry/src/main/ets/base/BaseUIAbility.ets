import { AbilityConstant, Configuration, UIAbility, Want } from '@kit.AbilityKit'
import { HiLog, Log } from 'static_library_common'
import window from '@ohos.window'
import { BusinessError } from '@kit.BasicServicesKit';

export abstract class BaseUIAbility extends UIAbility {
  // 获取类名
  TAG: string = this.constructor.name + " "
  windowStage: window.WindowStage | undefined = undefined;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onCreate(want, launchParam)
    HiLog.info(this.TAG + 'Ability onCreate')
    HiLog.info(this.TAG + 'Context=' + this.context)
  }

  onForeground(): void {
    super.onForeground()
    HiLog.info(this.TAG + 'Ability onForeground')
  }

  onBackground(): void {
    super.onBackground()
    HiLog.info(this.TAG + 'Ability onBackground')
  }

  onDestroy(): void {
    super.onDestroy()
    HiLog.info(this.TAG + 'Ability onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    super.onWindowStageCreate(windowStage)
    HiLog.info(this.TAG + 'Ability onWindowStageCreate')
    // TODO 监听WindowStage事件
    this.addLifecycleObserver(windowStage)
    // 加载启动页面
    let callback = (err: BusinessError) => {
      if (err.code) {
        HiLog.error(this.TAG + 'Failed to load the content: ' + JSON.stringify(err) ?? '')
        return
      }
      HiLog.info(this.TAG + 'Succeeded in loading the content.')
    }
    // 检查是否有localStorage
    if (this.getLocalStorage() == null) {
      windowStage.loadContent(this.getInitPageName(), callback)
    } else {
      Log.warn(`${this.TAG} LocalStorage 传递给Page`)
      windowStage.loadContent(this.getInitPageName(), this.getLocalStorage(), callback)
    }
  }

  private addLifecycleObserver(windowStage: window.WindowStage) {
    this.windowStage = windowStage
    // WindowStage事件
    windowStage.on('windowStageEvent', (data) => {
      let stageEventType: window.WindowStageEventType = data
      switch (stageEventType) {
        case window.WindowStageEventType.SHOWN: // 切到前台
          HiLog.info(this.TAG + 'windowStage SHOWN.')
          break
        case window.WindowStageEventType.ACTIVE: // 获焦状态
          HiLog.info(this.TAG + 'windowStage ACTIVE.')
          break
        case window.WindowStageEventType.INACTIVE: // 失焦状态
          HiLog.info(this.TAG + 'windowStage INACTIVE.')
          break
        case window.WindowStageEventType.HIDDEN: // 切到后台
          HiLog.info(this.TAG + 'windowStage HIDDEN.')
          break
        default:
          break
      }
    })
  }

  onWindowStageDestroy(): void {
    super.onWindowStageDestroy()
    HiLog.info(this.TAG + 'Ability onWindowStageDestroy')
    // TODO 移除监听???
    // Error message:state abnormally
    // if (this.windowStage) {
    //   this.windowStage.off('windowStageEvent');
    // }
  }

  onWindowStageWillDestroy(windowStage: window.WindowStage): void {
    try {
      super.onWindowStageWillDestroy(windowStage)
      HiLog.info(this.TAG + 'Ability onWindowStageWillDestroy')
    } catch (e) {
      HiLog.error(this.TAG + 'onWindowStageWillDestroy error=' + JSON.stringify(e))
    }
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onNewWant(want, launchParam)
    HiLog.info(this.TAG + 'Ability onNewWant')
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    super.onConfigurationUpdate(newConfig)
    HiLog.info(this.TAG + 'Ability onConfigurationUpdate ' + JSON.stringify(newConfig))
  }

  onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult | Promise<AbilityConstant.OnContinueResult> {
    return super.onContinue(wantParam)
  }

  onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
    super.onMemoryLevel(level)
    HiLog.info(this.TAG + 'Ability onMemoryLevel ' + level)
  }

  abstract getInitPageName(): string

  abstract getLocalStorage(): LocalStorage | null
}