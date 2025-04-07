import { workScheduler } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { Log } from 'static_common';

@Entry
@Component
struct WorkSchedulerPage {
  @State message: string = '测试 WorkerSchedulerExtension';
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  // 创建workInfo
  workInfo: workScheduler.WorkInfo = {
    workId: 1,
    networkType: workScheduler.NetworkType.NETWORK_TYPE_WIFI,
    // darcyRefactor: 通过context获取包名 bundleName
    bundleName: this.context.abilityInfo.bundleName,
    abilityName: 'EntryWorkSchedulerExtensionAbility'
  }

  build() {
    Column({ space: 20 }) {
      Text(this.message)
      Button('申请延迟任务').onClick((event: ClickEvent) => {
        this.startWork();
      })
      Button('取消延迟任务').onClick((event: ClickEvent) => {
        this.stopWork();
      })

    }
    .height('100%')
    .width('100%')
  }

  private stopWork() {
    try {
      workScheduler.stopWork(this.workInfo);
      Log.info(`stopWork success`);
    } catch (error) {
      Log.error(`stopWork failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  private startWork() {
    try {
      workScheduler.startWork(this.workInfo);
      Log.info(`startWork success`);
    } catch (error) {
      Log.error(`startWork failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }
}