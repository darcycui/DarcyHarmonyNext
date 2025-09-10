import { nativeAdd } from 'library_camera';
import { promptAction } from '@kit.ArkUI';
import { Log } from 'static_library_common';
import { Student } from '../../../network/models/HttpBean';

@Entry
@Component
struct NApiPage {
  @State message: string = '调用NApi Click';

  @State stu: Student | undefined = new Student("Tom", 7);

  build() {
    Column({ space: 10 }) {
      Button('调用function Click').width('100%')
        // TODO 传递函数 包一层 ()=>{}
        .onClick(() => {
          this.callFunction()
        })
      Button('调用NApi Click').width('100%')
        .onClick(() => {
          let sum = nativeAdd(1, 2);
          promptAction.showToast({ message: `NApiPage sum=${sum}` });
        })
    }
    .height('100%')
    .width('100%')
  }

  callFunction() {
    Log.log(`NApiPage callFunction this=${this}`);
    Log.log(`stu.getName()=${this.stu?.getName()}`);
    Log.log(`stu.name=${this.stu?.name}`);
    Log.log(`stu.getAge()=${this.stu?.getAge()}`);
    Log.log(`stu.age=${this.stu?.age}`);
  }
}
