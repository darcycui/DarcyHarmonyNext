import { ErrorEvent, MessageEvents, process, worker } from '@kit.ArkTS';
import { Log } from 'static_common';

// 宿主线程(这里是主线程) 创建worker
// const workerInstance: worker.ThreadWorker = new worker.ThreadWorker('./src/main/ets/workers/AddWorker.ets');
// workerInstance.onmessage = (event: MessageEvents) => {
//   Log.log(`WorkerPage onmessage event=${event}`);
// }
// workerInstance.onerror = (error: ErrorEvent) => {
//   Log.error(`WorkerPage onerror error=${error}`);
// }
// workerInstance.postMessage(`发送消息:${Date.now()}`)

@Entry
@Component
struct WorkerPage {
  @State message: string = 'Hello World';
  @State value: string = 'default';

  workerInstance: worker.ThreadWorker = new worker.ThreadWorker('entry/ets/workers/AddWorker.ets');

  build() {
    RelativeContainer() {
      Column() {
        Text(this.message)
        Text(this.value)
        Button('Worker并行计算')
          .onClick(() => {
            workerFunc(this.workerInstance, (value) => {
              this.value = `${value}`
            })
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}

function workerFunc(workerInstance: worker.ThreadWorker, callback: (value: number) => void) {
  Log.log(`宿主线程: ${process.tid}`)
  workerInstance.onmessage = (event: MessageEvents) => {
    Log.log(`WorkerPage onmessage event=${event.type} ${event.data}`);
    callback(event.data.valueOf() as number)
  }
  workerInstance.onerror = (error: ErrorEvent) => {
    Log.error(`WorkerPage onerror error=${error.type} ${error.message}`);
  }
  let date = Date.now()
  Log.log(`WorkerPage 发送消息 ${date}`)
  workerInstance.postMessage(`${date + 1000}`)
}
