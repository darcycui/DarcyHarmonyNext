import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Log } from 'static_common';
import { showToast } from '../../utils/ToastUtil';

let taskID: number = 100; // 申请短时任务ID
let remainTime: number = 0; // 本次申请短时任务的剩余时间

@Entry
@Component
struct ShortTaskPage {
  @State message: string = 'Hello World';

  build() {
    Column({ space: 20 }) {
      Text(this.message)
      Button('申请短任务').onClick((event: ClickEvent) => {
        showToast('请退到后台，触发短时任务')
      })
      Button('取消短任务').onClick((event: ClickEvent) => {
        stopTask()
      })

    }
    .height('100%')
    .width('100%')
  }
  onPageShow(): void {

  }
  onPageHide(): void {
    startTask()
  }
}

/**
 * 申请短时任务
 * @param id 短时任务ID
 */
function startTask() {
  let myReason = 'test requestSuspendDelay'; // 申请原因
  let delayInfo = backgroundTaskManager.requestSuspendDelay(myReason, () => {
    // 回调函数。应用申请的短时任务即将超时，通过此函数回调应用，执行一些清理和标注工作，并取消短时任务
    Log.info(`任务超时回调 ${myReason}`);
    backgroundTaskManager.cancelSuspendDelay(taskID);
  })
  taskID = delayInfo.requestId;
  remainTime = delayInfo.actualDelayTime;
  Log.info(`申请短时任务成功，id=${taskID}, remainTime=${remainTime}`);
  // 延时1秒
  Log.log('任务开始+++')
  setTimeout(() => {
    Log.log('任务结束---')
    getRemainingTime(taskID);
  }, 1000);
}

/**
 * 取消短时任务
 * @param id 短时任务ID
 */
function stopTask() {
  backgroundTaskManager.cancelSuspendDelay(taskID);
}

/**
 * 获取剩余时间
 * @param id 短时任务ID
 */
async function getRemainingTime(id: number) {
  backgroundTaskManager.getRemainingDelayTime(id).then((res: number) => {
    remainTime = res;
    Log.info(`获取剩余时间成功 time=${res}`);
  }).catch((err: BusinessError) => {
    Log.error(`获取剩余时间失败. Code: ${err.code}, message: ${err.message}`);
  })
}
