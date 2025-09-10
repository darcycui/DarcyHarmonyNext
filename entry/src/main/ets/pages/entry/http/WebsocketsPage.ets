import { Log } from 'static_library_common';
import { closeWS, connectWS, other, self, sendWS, WSS_URL } from '../../../network/WebSocket';
import { saveByteArrayToFile } from '../../../utils/FileUtil';
import { common } from '@kit.AbilityKit';
import { MessageBean } from '../../../network/models/MessageBean';

let TAG = "[WebsocketsPage] ";

@Entry
@Component
struct WebsocketsPage {
  @State count: number = 0;
  @State wsText: string = 'default';
  private context = getContext(this) as common.UIAbilityContext;
  // private certFileName = "test2IPSelf137.crt"
  private certFileName = "test2IPSelf241.crt"
  // private certFileName = "test2ServerSelf.crt"
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
    Column({ space: 5 }) {
      this.connectButton()
      this.sendButton()
      this.disconnectButton()
      this.resultText()
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  resultText() {
    Scroll() {
      Text(this.wsText)
        .id('ResultText')
        .fontSize(16)
        .height('100%')

    }.scrollBar(BarState.On)
    .width('100%')
    .height('100%')
  }

  @Builder
  connectButton() {
    Button($r("app.string.WebsocketConnect")).width('100%')
      .id("WebsocketConnect")
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // TODO 连接
        this.connect()
      })
  }

  @Builder
  sendButton() {
    Button($r("app.string.WebsocketSend")).width('100%')
      .id("WebsocketSend")
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // TODO 断开连接
        this.send()
      })
  }

  @Builder
  disconnectButton() {
    Button($r("app.string.WebsocketDisconnect")).width('100%')
      .id("WebsocketDisconnect")
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // TODO 断开连接
        this.disconnect()
      })
  }

  send() {
    this.count++
    sendWS("hello " + this.count, self, other)
  }

  disconnect() {
    closeWS()
  }

  connect() {
    connectWS(
      WSS_URL,
      this.filePath,
      () => {
        Log.log("on open");
      },
      (data: string | ArrayBuffer) => {
        Log.log(`onmessage data=${data}`);
        this.wsText += "\n" + (data as string);
      },
      () => {
        Log.log(`onclose`);
      },
      (message: string) => {
        Log.log(`onerror:${message}`)
        this.wsText = message
      }
    )
  }
}