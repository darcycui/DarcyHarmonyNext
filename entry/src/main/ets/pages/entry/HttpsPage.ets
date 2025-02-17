import { Log } from 'static_common';
import { IPBean, ResultBean } from '../../bean/HttpBean';
import { doGet } from '../../network/Http';
import { common } from '@kit.AbilityKit';
import { saveByteArrayToFile } from '../../utils/FileUtil';

let TAG = "[HttpPage] ";

export let httpsUrl: string = "https://10.0.0.126/web/hello"

@Entry
@Component
struct HttpsPage {
  @State httpText: string = 'default';
  private context = getContext(this) as common.UIAbilityContext;
  //   private certFileName = "test.crt"
  private certFileName = "test2.crt"
  // private certFileName = "test2.pem"
  private filePath = this.context.filesDir + "/" + this.certFileName;

  // 生命周期回调:页面即将显示 所有组件
  aboutToAppear(): void {
    Log.info(TAG + "aboutToAppear");
    Log.error(`juheCertPath=${this.filePath}`);
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
    Button($r("app.string.HttpTest"))
      .id("HttpTest")
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // TODO 访问网络
        this.requestHttp()
      })
  }

  // 发起网络请求
  private requestHttp() {
    // TODO 证书路径(沙箱路径)
    Log.warn(`caPath=${this.filePath}`);
    doGet(
      httpsUrl,
      (bean: ResultBean<IPBean>) => {
        this.httpText = bean.result?.Country ?? "Empty Value";
        Log.log(`bean=${JSON.stringify(bean)}`);
      },
      (data: string) => {
        this.httpText = data;
      },
      this.filePath
    );
  }
}