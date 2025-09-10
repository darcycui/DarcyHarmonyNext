import { promptAction } from '@kit.ArkUI';
import { cameraPicker as picker } from '@kit.CameraKit';
import { camera } from '@kit.CameraKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Log } from 'static_library_common';

@Entry
@Component
struct ImagePage {
  @State message: string = 'Hello World';
  @State uri: Resource | string | undefined = undefined;

  build() {
    Column() {
      Text(this.message)
        .id('ImagePageHelloWorld')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
      Image(this.uri)
        .alt($r('app.media.startIcon'))
        .width("100%")
        .height(150)
        .objectFit(ImageFit.Contain)
        .margin({ top: 10 })
        .onClick(() => {
          promptAction.showToast({ message: "Image Click" })
        })
      Button($r('app.string.TakeImage')).width('100%')
        .margin({ top: 10 })
        .onClick(() => {
        promptAction.showToast({ message: "Take Image" })
        startCameraPreview((resultUri: string) => {
          // Get image URI
          this.uri = resultUri;
        })
      })
    }
    .height('100%')
    .width('100%')
  }
}

let mContext = getContext(this) as common.Context;

async function startCameraPreview(callback: (resultUri: string) => void) {
  try {
    let pickerProfile: picker.PickerProfile = {
      cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
    };
    let pickerResult: picker.PickerResult = await picker.pick(mContext,
      [picker.PickerMediaType.PHOTO, picker.PickerMediaType.VIDEO], pickerProfile);
    Log.log("the pick pickerResult is:" + JSON.stringify(pickerResult));
    callback(pickerResult.resultUri);
  } catch (error) {
    let err = error as BusinessError;
    Log.error(`the pick call failed. error code: ${err.code}`);
  }
}
