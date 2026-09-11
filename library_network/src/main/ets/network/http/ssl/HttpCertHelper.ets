import { Log, FileUtil } from "static_library_common";
import { JSON } from "@kit.ArkTS";

export class HttpCertHelper {

  private static certPath: string = "";

  static initSelfCert(context: Context): void {
    let certFileName:string = "test2ServerSelf.crt";
    HttpCertHelper.certPath = context.filesDir + "/" + certFileName
    Log.error(`Https 自定义证书路径=${HttpCertHelper.certPath}`);
    // 读取rawfile目录下的证书文件
    try {
      context.resourceManager.getRawFileContent(certFileName, (_err, value) => {
        FileUtil.saveByteArrayToFile(value, HttpCertHelper.certPath);
      });
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : JSON.stringify(error);
      Log.error(`Https 自定义证书读取失败=${errorMsg}`)
    }
  }

  static getCertPath(): string {
    if (HttpCertHelper.certPath == "")
      throw new Error("Https 自定义证书路径未初始化");
    return HttpCertHelper.certPath;
  }
}