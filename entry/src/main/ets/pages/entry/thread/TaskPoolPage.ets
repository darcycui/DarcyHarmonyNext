import { InitCommon, Log, } from 'static_common';
import { process, taskpool } from '@kit.ArkTS';
import { AppInfo } from '../../../utils/AppInfo';

@Entry
@Component
struct TaskPoolPage {
  @State message: string = '多线程:使用TaskPool';
  @State value: string = 'default';

  build() {
    Column() {
      Text(this.message)
      Text(this.value)
      Button('TaskPool并行计算')
        .onClick(() => {
          concurrentFunc((value)=>{
            this.value = `${value}`
          })
        })
    }
    .height('100%')
    .width('100%')
  }
}

// 多线程计算 使用@Concurrent注解
@Concurrent
function add(x: number, y: number): number {
  InitCommon.init(AppInfo.isDebug()) // 多线程环境下 重新初始化 Log日志开关
  Log.log(`task add x=${x} y=${y}`);
  // a(); // 编译错误:不能在多线程中调用当前类中的函数和变量 (import进来的可以)
  let uid = process.uid
  Log.log(`task uid=${uid}`)
  let pid = process.pid
  Log.log(`task pid=${pid}`)
  let tid = process.tid
  Log.log(`task线程: tid=${tid}`) // 线程id
  return x + y
}

async function concurrentFunc(callback: (value: number) => void): Promise<void> {
  try {
    let tid = process.tid
    Log.log(`主线程tid: ${tid}`) // 线程id
    // 创建task
    let task: taskpool.Task = new taskpool.Task(add, 1, 2);
    // 执行task 设置优先级
    let result = await taskpool.execute(task, taskpool.Priority.MEDIUM);
    Log.log(`concurrentFunc result=${result}`)
    // 回调函数
    callback(result.valueOf() as number);
  } catch (e) {
    Log.error(`concurrentFunc error=${e}`);
  }
}

function a() {
  Log.log(`call function a`)
}

