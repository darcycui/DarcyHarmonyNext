import { BusinessError } from '@kit.BasicServicesKit';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { common, WantAgent, wantAgent } from '@kit.AbilityKit';
import { Log } from 'static_library_common';

@Entry
@Component
struct LongTaskPage {
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @State message: string = 'Test Long BackgroundTask';

  build() {
    Column({ space: 20 }) {
      Text(this.message)
      Button('申请长任务').width('100%').onClick(() => {
        this.message = '申请长任务';
        this.startLongTask()
      })
      Button('取消长任务').width('100%').onClick(() => {
        this.message = '取消长任务';
        this.stopLongTask()
      })
    }
    .height('100%')
    .width('100%')
  }

  startLongTask() {
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      // 点击通知后，将要执行的动作列表
      // 添加需要被拉起应用的bundleName和abilityName
      wants: [{
        bundleName: this.context.abilityInfo.bundleName,
        abilityName: "LongTaskDetailAbility"
      }],
      // 指定点击通知栏消息后的动作是拉起ability
      actionType: wantAgent.OperationType.START_ABILITY,
      // 使用者自定义的一个私有值
      requestCode: 100,
      // 点击通知后，动作执行属性
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

    try {
      // 通过wantAgent模块下getWantAgent方法获取WantAgent对象
      wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: WantAgent) => {
        try {
          let list: Array<string> = ["dataTransfer"];
          backgroundTaskManager.startBackgroundRunning(this.context, list, wantAgentObj)
            .then((res: backgroundTaskManager.ContinuousTaskNotification) => {
              console.info("长任务 开启成功");
              // 此处执行具体的长时任务逻辑，如录音，录制等
              Log.log('长任务执行开始+++')
              setTimeout(() => {
                Log.log('长任务执行完成---')
              }, 10_000)
            })
            .catch((error: BusinessError) => {
              console.error(`长任务开启失败1. code is ${error.code} message is ${error.message}`);
            });
        } catch (error) {
          console.error(`长任务开启失败2. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
        }
      });
    } catch (error) {
      console.error(`长任务getWantAgent失败. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  stopLongTask() {
    backgroundTaskManager.stopBackgroundRunning(this.context).then(() => {
      console.info(`长任务停止成功`);
    }).catch((err: BusinessError) => {
      console.error(`长任务停止失败. Code is ${err.code}, message is ${err.message}`);
    });
  }
}