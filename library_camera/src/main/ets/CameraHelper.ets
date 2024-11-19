import { fileIo } from '@kit.CoreFileKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { camera } from '@kit.CameraKit'
import { image } from '@kit.ImageKit'
import { common } from '@kit.AbilityKit'
import { JSON, uri } from '@kit.ArkTS'
import { GlobalCameraContext } from './state/GlobalCameraContext'

export class CameraHelper {
  private cameraManager?: camera.CameraManager
  private cameraInput?: camera.CameraInput
  public previewOutput?: camera.PreviewOutput
  public photoOutput?: camera.PhotoOutput
  private photoSession?: camera.PhotoSession
  private receiver: image.ImageReceiver | undefined = undefined;
  // 推荐预览分辨率之一
  private previewProfileObj: camera.Profile = {
    format: 1003,
    size: {
      width: 1920,
      height: 1080
    }
  };
  // 推荐拍照分辨率之一
  private photoProfileObj: camera.Profile = {
    format: 2000,
    size: {
      width: 1920,
      height: 1080
    }
  };

  async initCamera(surfaceId: string): Promise<void> {
    // 1.输入配置
    // 获取cameraManager对象
    this.cameraManager = camera.getCameraManager(getContext(this) as common.UIAbilityContext);
    // 获取当前设备支持的相机列表
    let cameras: Array<camera.CameraDevice> = this.cameraManager.getSupportedCameras();
    for (let index = 0; index < cameras.length; index++) {
      console.info('cameraId : ' + cameras[index].cameraId); // 获取相机ID
      console.info('cameraPosition : ' + cameras[index].cameraPosition); // 获取相机位置
      console.info('cameraType : ' + cameras[index].cameraType); // 获取相机类型
      console.info('connectionType : ' + cameras[index].connectionType); // 获取相机连接类型
    }
    // 获取支持的模式类型
    let sceneModes: Array<camera.SceneMode> = this.cameraManager.getSupportedSceneModes(cameras[0]);
    let isSupported: boolean = sceneModes.indexOf(camera.SceneMode.NORMAL_PHOTO) >= 0;
    if (!isSupported) {
      console.error('photo mode not support');
      return;
    }
    let cameraDevice = cameras[0]; // 0
    // 创建相机输入流
    try {
      this.cameraInput = this.cameraManager.createCameraInput(cameraDevice);
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to createCameraInput errorCode = ' + err.code + ' error = ' + JSON.stringify(error));
      return
    }
    // 监听cameraInput错误信息
    this.cameraInput.on('error', cameraDevice, (error: BusinessError) => {
      console.error(`Camera input error code: ${error.code} error=${JSON.stringify(error)}`);
    });
    // 打开相机
    await this.cameraInput.open();
    // 获取当前设备支持的所有输出流，如预览流、拍照流
    let cameraOutputCapability: camera.CameraOutputCapability =
      this.cameraManager!.getSupportedOutputCapability(cameraDevice, camera.SceneMode.NORMAL_PHOTO);
    if (!cameraOutputCapability) {
      console.error("cameraManager.getSupportedOutputCapability error");
      return;
    }
    console.info("outputCapability: " + JSON.stringify(cameraOutputCapability));
    let previewProfile = this.getPreviewProfile(cameraOutputCapability);
    if (previewProfile === undefined) {
      console.error('The resolution of the current preview stream is not supported.');
      return;
    }
    this.previewProfileObj = previewProfile;
    console.warn(`previewProfileObj= ${JSON.stringify(previewProfile)}`)
    // 监听相机状态，包括新相机的出现、相机的移除、相机的可用状态
    this.cameraManager.on('cameraStatus', (err: BusinessError, cameraStatusInfo: camera.CameraStatusInfo) => {
      if (err !== undefined && err.code !== 0) {
        console.error(`Callback Error, errorCode: ${err.code}`);
        return;
      }
      // console.info(`camera: ${cameraStatusInfo.camera.cameraId}`);
      // console.info(`status: ${cameraStatusInfo.status}`);
    });
    // 2. 输出配置 预览输出流
    // 创建预览输出流
    this.previewOutput = this.cameraManager!.createPreviewOutput(this.previewProfileObj, surfaceId);
    // 监听预览状态
    // 预览启动
    this.previewOutput.on('frameStart', (err: BusinessError) => {
      if (err !== undefined && err.code !== 0) {
        return;
      }
      console.info('Preview frame started');
    });
    // 预览结束
    this.previewOutput.on('frameEnd', (err: BusinessError) => {
      if (err !== undefined && err.code !== 0) {
        return;
      }
      console.info('Preview frame ended');
    });
    // 预览错误
    this.previewOutput.on('error', (previewOutputError: BusinessError) => {
      console.error(`Preview output error code: ${previewOutputError.code}`);
    });
    let size: image.Size = {
      height: 2592, width: 1200
    };
    // 3. 输出配置 拍照输出流
    this.receiver = image.createImageReceiver(size, image.ImageFormat.JPEG, 8);
    let photoProfile = this.getPhotoProfile(cameraOutputCapability);
    if (photoProfile === undefined) {
      console.error('The resolution of the current photo stream is not supported.');
      return;
    }
    this.photoProfileObj = photoProfile;
    this.photoOutput = this.cameraManager!.createPhotoOutput(this.photoProfileObj);
    if (this.photoOutput === undefined) {
      console.error('Failed to create the photo stream.');
      return;
    }
    // 设置拍照回调 api11 调用photoOutput的capture方法，就会将拍照的buffer回传到回调中
    this.photoOutput.on('photoAvailable', (errCode: BusinessError, photo: camera.Photo): void => {
      let imageObj = photo.main;
      imageObj.getComponent(image.ComponentType.JPEG, async (errCode: BusinessError, component: image.Component) => {
        if (errCode || component === undefined) {
          return;
        }
        let buffer: ArrayBuffer;
        buffer = component.byteBuffer;
        console.warn(`image buffer=${JSON.stringify(buffer)} ${buffer.byteLength}`);
        await this.savePicture(buffer);
        imageObj.release();
      })
    })
    // 设置拍照回调 api12
    // this.photoOutput.on('photoAssetAvailable', (err: BusinessError, photoAsset: photoAccessHelper.PhotoAsset) => {
    //   console.warn('photoAssetAvailable begin');
    //   if (photoAsset === undefined) {
    //     console.error('photoAsset is undefined');
    //     return;
    //   }
    //   // this.handlePhotoAssetCb(photoAsset);
    // });
    // 拍照开始
    this.photoOutput.on('captureStartWithInfo', (err: BusinessError, captureStartInfo: camera.CaptureStartInfo) => {
      if (err !== undefined && err.code !== 0) {
        return;
      }
      console.info(`photo capture started, captureId : ${captureStartInfo.captureId}`);
    });
    // 拍照结束
    this.photoOutput.on('captureEnd', (err: BusinessError, captureEndInfo: camera.CaptureEndInfo) => {
      if (err !== undefined && err.code !== 0) {
        return;
      }
      console.info(`photo capture end, captureId : ${captureEndInfo.captureId}`);
      console.info(`frameCount : ${captureEndInfo.frameCount}`);
    });
    // 拍照错误
    this.photoOutput.on('error', (error: BusinessError) => {
      console.error(`Photo output error code: ${error.code}`);
    });

    // 4. 创建会话
    // 创建一个会话
    this.photoSession = this.cameraManager!.createSession(camera.SceneMode.NORMAL_PHOTO);
    // 配置会话
    this.photoSession.beginConfig();
    // 添加输入流
    this.photoSession.addInput(this.cameraInput);
    // 添加输出流: 预览输出流
    this.photoSession.addOutput(this.previewOutput);
    // 添加输出流: 拍照输出流
    this.photoSession.addOutput(this.photoOutput);
    // 提交相关配置
    await this.photoSession.commitConfig();
    // 启动会话
    await this.photoSession.start();
    this.photoSession.on('error', (error: BusinessError) => {
      console.error(`Photo session error code: ${error.code}`);
    });
  }

  /**
   * 触发拍照
   */
  async takePicture() {
    console.log('takePicture');
    // 触发拍照
    let settings: camera.PhotoCaptureSetting = {
      quality: camera.QualityLevel.QUALITY_LEVEL_HIGH, // 设置图片质量高
      rotation: camera.ImageRotation.ROTATION_0, // 设置图片旋转角度0
      location: undefined, // 设置图片地理位置
      mirror: false  // 设置镜像使能开关(默认关)
    };
    this.photoOutput!.capture(settings, (err: BusinessError) => {
      if (err) {
        console.error(`Failed to capture the photo. error: ${JSON.stringify(err)}`);
        return;
      }
      console.info('Callback invoked to indicate the photo capture request success.');
    });
  }

  // 保存byte数组为图片
  async savePicture(buffer: ArrayBuffer): Promise<void> {
    let photoHelper: photoAccessHelper.PhotoAccessHelper =
      photoAccessHelper.getPhotoAccessHelper(getContext(this) as common.UIAbilityContext);
    let options: photoAccessHelper.CreateOptions = {
      title: Date.now().toString()
    };
    //createAsset的调用需要 ohos.permission.READ_IMAGEVIDEO 和 ohos.permission.WRITE_IMAGEVIDEO 的权限
    let photoUri: string = await photoHelper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg', options);
    console.info(`save photoUri=${photoUri}`);

    // 保存到file
    let file: fileIo.File = fileIo.openSync(photoUri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    await fileIo.write(file.fd, buffer);
    fileIo.closeSync(file);

    // 创建图片数据
    let imageSource: image.ImageSource = image.createImageSource(buffer);
    imageSource.createPixelMap((err: BusinessError, pixelMap: image.PixelMap) => {
      if (!pixelMap) {
        return;
      }
      // 回调 图片数据
      this.showImagePixelCallback(pixelMap);
    })
    // 回调 图片uri
    this.showImageUriCallback(photoUri);
    GlobalCameraContext.getInstance().setObject('photoUri', photoUri)
  }

  private showImagePixelCallback: (pixelMap: image.PixelMap) => void = () => {
  };
  private showImageUriCallback: (uri: string) => void = () => {
  };

  setShowImagePixelCallback(callback: (pixelMap: image.PixelMap) => void): void {
    this.showImagePixelCallback = callback;
  }

  setShowImageUriCallback(callback: (uri: string) => void): void {
    this.showImageUriCallback = callback;
  }

  async releaseCamera(): Promise<void> {
    if (this.cameraInput) {
      await this.cameraInput.close();
    }
    if (this.previewOutput) {
      await this.previewOutput.release();
    }
    if (this.photoOutput) {
      await this.photoOutput.release();
    }
    if (this.photoSession) {
      await this.photoSession.release();
      this.photoSession = undefined;
    }
  }

  getPreviewProfile(cameraOutputCapability: camera.CameraOutputCapability): camera.Profile | undefined {
    let previewProfiles = cameraOutputCapability.previewProfiles;
    if (previewProfiles.length < 1) {
      return undefined;
    }
    let index = previewProfiles.findIndex((previewProfile: camera.Profile) => {
      return previewProfile.size.width === this.previewProfileObj.size.width &&
        previewProfile.size.height === this.previewProfileObj.size.height &&
        previewProfile.format === this.previewProfileObj.format;
    });
    if (index === -1) {
      return undefined;
    }
    return previewProfiles[index];
  }

  getPhotoProfile(cameraOutputCapability: camera.CameraOutputCapability): camera.Profile | undefined {
    let photoProfiles = cameraOutputCapability.photoProfiles;
    if (photoProfiles.length < 1) {
      return undefined;
    }
    let index = photoProfiles.findIndex((photoProfile: camera.Profile) => {
      return photoProfile.size.width === this.photoProfileObj.size.width &&
        photoProfile.size.height === this.photoProfileObj.size.height &&
        photoProfile.format === this.photoProfileObj.format;
    });
    if (index === -1) {
      return undefined;
    }
    return photoProfiles[index];
  }
}

export default new CameraHelper();