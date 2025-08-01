import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'liblibrary_camera.so';
import { Log } from 'static_library_common';

@Component
export struct CameraComponent {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            Log.info(`Test NAPI 2 + 3 = ${testNapi.add(2, 3)}`)
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}