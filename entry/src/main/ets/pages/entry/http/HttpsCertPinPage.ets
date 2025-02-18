import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';
import { http } from '@kit.NetworkKit';
import { cert } from '@kit.DeviceCertificateKit';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util } from '@kit.ArkTS';
import { Log } from 'static_common';
import { uint8ArrayToString } from '../../../utils/StringUnit8ArrayUtil';
import { base64DecodeToString } from '../../../utils/Bese64Util';
import { saveByteArrayToFile } from '../../../utils/FileUtil';

@Entry
@Component
struct HttpsCertPinPage {
  @State title: string = '服务端证书锁定防范中间人攻击示例';
  //连接、通讯历史记录
  @State msgHistory: string = ''
  //请求的HTTPS地址
  @State httpsUrl: string = "https://apis.whyta.cn/"
  //是否锁定服务端证书
  @State isServerCertFixed: boolean = true
  //选择的锁定的证书文件
  @State fixedCertFileUri: string = ''
  //锁定证书的公钥哈希
  @State fixedCertPubKeyHash: string = ""
  scroller: Scroller = new Scroller()
  // private context = getContext(this) as common.UIAbilityContext;
  private context = getContext(this).getApplicationContext();
  private certFileName = "whyta.crt"

  private filePath = this.context.filesDir + "/" + this.certFileName;

  aboutToAppear(): void {
    Log.error(`CertPath=${this.filePath}`);
    // 读取rawfile目录下的证书文件
    getContext(this).resourceManager.getRawFileContent(this.certFileName, (_err, value) => {
      saveByteArrayToFile(value, this.filePath)
    });
  }

  build() {
    Row() {
      Column() {
        Text(this.title)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Column() {
            Text("是否锁定服务端证书")
              .fontSize(14)
              .width(150)
          }

          Column() {
            Text('不锁定').fontSize(14)
            Radio({ value: '0', group: 'rgFixed' }).checked(!this.isServerCertFixed)
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.isServerCertFixed = false
                }
              })
          }.width(100)

          Column() {
            Text('锁定').fontSize(14)
            Radio({ value: '1', group: 'rgFixed' }).checked(this.isServerCertFixed)
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.isServerCertFixed = true
                }
              })
          }.width(100)
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text("锁定的服务端证书")
            .fontSize(14)
            .width(90)
            .flexGrow(1)

          Button("选择")
            .onClick(async () => {
              this.fixedCertFileUri = await this.selectFile()
              this.fixedCertPubKeyHash = await this.getPubKeyHash(this.fixedCertFileUri)
            })
            .width(70)
            .fontSize(14)
        }
        .width('100%')
        .padding(10)
        .visibility(this.isServerCertFixed ? Visibility.Visible : Visibility.None)

        Text("服务端证书公钥SHA256摘要：")
          .width('100%')
          .fontSize(14)
          .padding(10)
          .visibility(this.isServerCertFixed ? Visibility.Visible : Visibility.None)

        Text(this.fixedCertPubKeyHash)
          .width('100%')
          .fontSize(14)
          .padding(10)
          .visibility(this.isServerCertFixed ? Visibility.Visible : Visibility.None)

        Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Text("请求地址：")
            .fontSize(14)
            .width(80)
          TextInput({ text: this.httpsUrl })
            .onChange((value) => {
              this.httpsUrl = value
            })
            .width(110)
            .fontSize(12)
            .flexGrow(1)
          Button("请求")
            .onClick(() => {
              this.doHttpRequest()
            })
            .width(60)
            .fontSize(14)
        }
        .width('100%')
        .padding(10)

        Scroll(this.scroller) {
          Text(this.msgHistory)
            .textAlign(TextAlign.Start)
            .padding(10)
            .width('100%')
            .backgroundColor(0xeeeeee)
        }
        .align(Alignment.Top)
        .backgroundColor(0xeeeeee)
        .height(300)
        .flexGrow(1)
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarWidth(20)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height('100%')
    }
    .height('100%')
  }

  //发起http请求
  doHttpRequest() {
    //http请求对象
    let httpRequest = http.createHttp();

    let opt: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      expectDataType: http.HttpDataType.STRING,
      connectTimeout: 5000,
    }
    // TODO 证书路径
    Log.warn(`caPath=${this.filePath}`);
    opt.caPath = this.filePath

    //配置服务端证书PIN码
    if (this.isServerCertFixed) {
      let certPinning: http.CertificatePinning = { publicKeyHash: this.fixedCertPubKeyHash, hashAlgorithm: "SHA-256" }
      opt.certificatePinning = certPinning
    }

    httpRequest.request(this.httpsUrl, opt)
      .then((resp) => {
        this.msgHistory += "响应码：" + resp.responseCode + "\r\n"
        this.msgHistory += '请求响应信息： ' + resp.result + "\r\n";
      })
      .catch((err: BusinessError) => {
        this.msgHistory += `请求失败：err code is ${err.code}, err message is ${JSON.stringify(err)}\r\n`;
      })
  }

  //选择文件
  async selectFile() {
    let selectFile = ""
    let documentPicker = new picker.DocumentViewPicker();
    await documentPicker.select().then((result) => {
      if (result.length > 0) {
        selectFile = result[0]
        this.msgHistory += "select file: " + selectFile + "\r\n";
      }
    }).catch((err: BusinessError) => {
      this.msgHistory += `选择文件失败：err code is ${err.code}, err message is ${JSON.stringify(err)}\r\n`;
    });
    return selectFile
  }

  //加载文件内容
  getContent(filePath: string): ArrayBuffer | undefined {
    let content: ArrayBuffer | undefined = undefined
    try {
      let buf = new ArrayBuffer(1024 * 64);
      let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      let readLen = fs.readSync(file.fd, buf, { offset: 0 });
      content = buf.slice(0, readLen)
      fs.closeSync(file);
    } catch (e) {
      this.msgHistory += '读取文件内容失败 ' + e.message + "\r\n";
    }
    return content
  }

  //获取证书文件对应的公钥SHA256摘要
  async getPubKeyHash(filePath: string) {
    Log.info(`filePath=${filePath}`)
    let result = ""
    if (filePath != "") {
      let fixedCert = await this.getCertFromFile(filePath)
      if (fixedCert) {
        try {
          //获取公钥
          let pubKey = fixedCert.getItem(cert.CertItemType.CERT_ITEM_TYPE_PUBLIC_KEY);
          Log.info(`pubKey.data=${pubKey.data}`)
          let mdSHA256 = cryptoFramework.createMd("SHA256")
          mdSHA256.updateSync({ data: pubKey.data });
          //公钥摘要计算结果
          let mdResult = mdSHA256.digestSync();
          Log.info(`mdResult.data=${mdResult.data}`)
          let pubKeyHash = uint8ArrayToString(mdResult.data)
          Log.info(`pubKeyHash=${pubKeyHash}`)
          let tool = new util.Base64Helper()
          //公钥摘要转换为base64编码字符串
          result = tool.encodeToStringSync(mdResult.data)
          Log.info(`pubKeyHashBase64=${result}`)
          let pubHashDecode = base64DecodeToString(result)
          Log.info(`pubKeyHashDecode=${pubHashDecode}`)
        } catch (e) {
          this.msgHistory += '获取公钥摘要失败 ' + e.message + "\r\n";
        }
      }
    }
    return result
  }

  //从文件获取X509证书
  async getCertFromFile(filePath: string): Promise<cert.X509Cert | undefined> {
    let newCert: cert.X509Cert | undefined = undefined
    let certData = this.getContent(filePath);
    if (certData) {
      let encodingBlob: cert.EncodingBlob = {
        data: new Uint8Array(certData),
        encodingFormat: cert.EncodingFormat.FORMAT_PEM
      };

      await cert.createX509Cert(encodingBlob)
        .then((x509Cert: cert.X509Cert) => {
          newCert = x509Cert
        })
        .catch((err: BusinessError) => {
          this.msgHistory += `创建X509证书失败：err code is ${err.code}, err message is ${JSON.stringify(err)}\r\n`;
        })
    }
    return newCert
  }
}