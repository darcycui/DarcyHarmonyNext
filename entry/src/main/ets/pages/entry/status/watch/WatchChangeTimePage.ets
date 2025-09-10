import { Log } from 'static_library_common';

@Observed
class Task {
  isFinished: boolean = false;

  constructor(isFinished: boolean) {
    this.isFinished = isFinished;
  }
}

@Entry
@Component
struct WatchChangeTimePage {
  @State @Watch('onTaskAChanged') taskA: Task = new Task(false);
  @State @Watch('onTaskBChanged') taskB: Task = new Task(false);

  onTaskAChanged(changedPropertyName: string): void {
    Log.log(`观测到父组件任务属性变化: ${changedPropertyName}`);
  }

  onTaskBChanged(changedPropertyName: string): void {
    Log.log(`观测到父组件任务属性变化: ${changedPropertyName}`);
  }

  build() {
    Column() {
      Text(`父组件任务A状态: ${this.taskA.isFinished ? '已完成' : '未完成'}`)
      Text(`父组件任务B状态: ${this.taskB.isFinished ? '已完成' : '未完成'}`)
      ChildComponent({ taskA: this.taskA, taskB: this.taskB })
      Button('切换任务状态')
        .width('100%').onClick(() => {
          this.taskB = new Task(!this.taskB.isFinished);
          this.taskA = new Task(!this.taskA.isFinished);
          // TODO 执行顺序如下: 父组件 B--A 子组件 A--B
          // 观测到父组件任务属性变化: taskB
          // 观测到父组件任务属性变化: taskA
          // 观测到子组件@Link关联的任务属性变化: taskA
          // 观测到子组件@ObjectLink关联的任务属性变化: taskB
        })
    }
  }
}

@Component
struct ChildComponent {
  // @ObjectLink状态更新依赖渲染刷新
  @ObjectLink @Watch('onObjectLinkTaskChanged') taskB: Task;
  // @Link状态更新不依赖渲染刷新
  @Link @Watch('onLinkTaskChanged') taskA: Task;

  onObjectLinkTaskChanged(changedPropertyName: string): void {
    Log.log(`观测到子组件@ObjectLink关联的任务属性变化: ${changedPropertyName}`);
  }

  onLinkTaskChanged(changedPropertyName: string): void {
    Log.log(`观测到子组件@Link关联的任务属性变化: ${changedPropertyName}`);
  }

  build() {
    Column() {
      Text(`子组件任务A状态: ${this.taskA.isFinished ? '已完成' : '未完成'}`)
      Text(`子组件任务B状态: ${this.taskB.isFinished ? '已完成' : '未完成'}`)
    }
  }
}