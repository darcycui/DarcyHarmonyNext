import { BusinessError } from '@kit.BasicServicesKit';
import { CameraHelper } from '../../CameraHelper';
import { Constants } from '../../constants/Constants';
import grantPermission from '../../utils/PermissionUtils';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { GlobalCameraContext } from '../../state/GlobalCameraContext';
import { image } from '@kit.ImageKit';
import { Log } from 'static_library_common';

// darcyRefactor: 实现 Navigation 路由函数
@Builder
export function CameraEntryBuilder() {
  CameraEntryPage()
}

@Component
export struct CameraEntryPage {
  private XComponentController: XComponentController = new XComponentController();
  private surfaceId: string = '';
  @State private camera: CameraHelper = new CameraHelper();
  // 图片数据
  @State private pixelMap: image.PixelMap | undefined = undefined;
  // 图片uri
  @State private uri: string | undefined = undefined;
  // Navigation 路由 栈控制器
  pathStack: NavPathStack = new NavPathStack();
  // 路由参数
  pageParam: Map<string, string> = new Map();

  async aboutToAppear() {
    await grantPermission().then(async () => {
      this.XComponentInit();
      // 回调显示图片
      this.camera.setShowImagePixelCallback((pixelMap: image.PixelMap) => {
        this.pixelMap = pixelMap
      })
      // 回调显示图片
      this.camera.setShowImageUriCallback((uri: string) => {
        this.uri = uri
      })
    }).catch((err: BusinessError) => {
      console.info(`grantPermission faild  ${JSON.stringify(err.code)}`);
    })
  }

  onPageShow() {
    this.XComponentInit();
  }

  onPageHide() {
    this.camera.releaseCamera();
  }

  async aboutToDisappear() {
    await this.camera.releaseCamera();
  }

  async XComponentInit() {
    let surfaceRect: SurfaceRect = {
      surfaceWidth: Constants.X_COMPONENT_SURFACE_HEIGHT,
      surfaceHeight: Constants.X_COMPONENT_SURFACE_WIDTH
    };
    this.XComponentController.setXComponentSurfaceRect(surfaceRect);
    this.surfaceId = this.XComponentController.getXComponentSurfaceId();
    await this.camera.initCamera(this.surfaceId);
  }

  // 设置安全控件按钮属性
  @State saveButtonOptions: SaveButtonOptions = {
    icon: SaveIconStyle.FULL_FILLED,
    text: SaveDescription.SAVE_IMAGE,
    buttonType: ButtonType.Capsule
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          Row() {
            XComponent({ type: XComponentType.SURFACE, controller: this.XComponentController })
              .onLoad(async () => {
                await this.camera.releaseCamera()
                await this.XComponentInit()
              })// 设置宽高 组件的宽高与预览内容相反
              .width(px2vp(Constants.X_COMPONENT_SURFACE_HEIGHT))
              .height(px2vp(Constants.X_COMPONENT_SURFACE_WIDTH))
              .align(Alignment.Center)
              .margin({ left: 30 })
          }.width('100%').margin({ top: 30 }).flexGrow(1)

          Column() {
            Text('拍照').fontSize(14).fontColor(Color.White).margin({ top: 16 })
            Row()
              .backgroundColor('#0A59F7')
              .width(6)
              .height(6)
              .border({ radius: 3 })
              .margin({ top: 6, bottom: 20 })
            Row() {
              Row().backgroundColor(Color.White).width(60).height(60).border({ radius: 30 })
            }
            .onClick(async () => {
              console.log('click')
              await this.camera.takePicture()
            })
            .backgroundColor(Color.Black)
            .width(76)
            .height(76)
            .border({ color: Color.White, width: 1, radius: 37 })
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .flexShrink(0)
          .height(228)
          .backgroundColor(Color.Black)
          .alignItems(HorizontalAlign.Center)
        }.width('100%').height('100%').backgroundColor(Color.Black)

        Row() {
          Image(this.pixelMap)
            .alt($r('app.media.aaa'))
            .objectFit(ImageFit.Contain)
            .width(100)
            .height(100)

          Image(this.uri)
            .alt($r('app.media.aaa'))
            .objectFit(ImageFit.Contain)
            .width(100)
            .height(100)
        }
        .margin({ left: 30, top: 30 })

        // 创建安全控件按钮
        Row() {
          SaveButton(this.saveButtonOptions)
            .onClick(async (event, result: SaveButtonOnClickResult) => {
              if (result == SaveButtonOnClickResult.SUCCESS) {
                try {
                  let context = getContext();
                  let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
                  // 需要确保fileUri对应的资源存在
                  // 文档 fileUri = 'file://com.example.temptest/data/storage/el2/base/haps/entry/files/test.jpg';
                  // 我 photoUri=file://media/Photo/47/IMG_1727426644_044/1727426544781.jpg
                  let fileUri = GlobalCameraContext.getInstance().getT<string>('photoUri');
                  console.warn('get photoUri=' + fileUri);
                  // 将图片插入相册 fixme 待修改
                  let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
                    photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(context, fileUri);
                  await phAccessHelper.applyChanges(assetChangeRequest);
                  console.info('createAsset successfully, uri: ' + assetChangeRequest.getAsset().uri);
                } catch (err) {
                  console.error(`create asset failed with error: ${err.code}, ${err.message}`);
                }
              } else {
                console.error('SaveButtonOnClickResult create asset failed');
              }
            })
        }.margin({ left: 30, top: 150 })
      }.align(Alignment.TopStart)
      .width('100%').height('100%')
    }.title('Camera')
    .onReady((context: NavDestinationContext)=>{
      this.pathStack = context.pathStack
      this.pageParam = context.pathInfo.param as Map<string, string>
      Log.info(`pageParam: ${JSON.stringify(this.pageParam)}`)
    })
  }
}