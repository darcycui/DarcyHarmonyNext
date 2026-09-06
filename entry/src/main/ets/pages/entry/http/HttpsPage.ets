import { Log } from 'static_library_common';
import { HttpResultEntity, doPost, UserResponse, HttpErrorEntity, RegisterRequestDTO } from 'library_network';
import { common } from '@kit.AbilityKit';
import { saveByteArrayToFile } from '../../../utils/FileUtil';
import { HashUtil } from '../../../utils/HashUtil';
import { ArrayUtil } from '../../../utils/ArrayUtil';

let TAG = "[HttpPage] ";

export let httpsUrl: string = "https://darcycui.com.cn/api/register"

@Entry
@Component
struct HttpsPage {
  @State httpText: string = 'default';
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private certFileName = "test2ServerSelf.crt"
  private filePath = this.context.filesDir + "/" + this.certFileName;

  // 生命周期回调:页面即将显示 所有组件
  aboutToAppear(): void {
    Log.info(TAG + "aboutToAppear");
    Log.error(`Https 自定义证书路径=${this.filePath}`);
    // 读取rawfile目录下的证书文件
    getContext(this).resourceManager.getRawFileContent(this.certFileName, (_err, value) => {
      saveByteArrayToFile(value, this.filePath);
    });
  }

  build() {
    Column() {
      this.httpButton()
      this.resultText()
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  resultText() {
    Text(this.httpText)
      .id('HttpText')
      .fontSize(16)
  }

  @Builder
  httpButton() {
    Button($r("app.string.HttpTest")).width('100%')
      .id("HttpTest")
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // TODO 访问网络
        this.postHttp()
      })
  }

  // 发起网络请求
  private postHttp() {
    // TODO 证书路径(沙箱路径)
    Log.warn(`caPath=${this.filePath}`);
    const userRegisterRequest = new RegisterRequestDTO({
      username: '张三',
      password: HashUtil.sha256FromBytesSync(ArrayUtil.stringToBytes('123456')),
      nickname: 'ZhangSan',
      email: 'zhangsan@email.com',
      phone: '159000111222',
      gender: "male",
      avatar: 'https://avatars.githubusercontent.com/u/15907?v=4',
      roles: 'user',
      signature: '',
      settings: ''
    })
    const bodyJson = JSON.stringify(userRegisterRequest)
    doPost(
      httpsUrl,
      bodyJson,
      (bean: HttpResultEntity<UserResponse>) => {
        this.httpText = JSON.stringify(bean.result) ?? "请求异常";
        Log.log(`bean=${JSON.stringify(bean)}`);
      },
      (data: HttpErrorEntity) => {
        this.httpText = JSON.stringify(data);
      },
      this.filePath
    );
  }
}