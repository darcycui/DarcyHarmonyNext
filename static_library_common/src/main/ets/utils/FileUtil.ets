import { Log } from "./Log";
import { fileIo } from "@kit.CoreFileKit";
import ErrorUtil from "./ErrorUtil";

export class FileUtil {
  static saveByteArrayToFile(value: Uint8Array, filePath: string): void {
    let myBuffer: ArrayBufferLike = value.buffer;
    // 将证书文件复制到沙箱
    Log.info('filePath:' + filePath);
    // 检查filePath文件是否存在
    if (FileUtil.checkFileExists(filePath)) {
      Log.info(`file ${filePath} exists, no need to create it again!`)
      return
    }
    let file: fileIo.File | null = null
    try {
      file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      let writeLen = fileIo.writeSync(file.fd, myBuffer);
      Log.info('write data to file succeed and size is:' + writeLen);
    } catch (error) {
      ErrorUtil.logError(error)
    } finally {
      try {
        if (file) {
          fileIo.closeSync(file);
        } else {
          Log.info('file is null 无需关闭!');
        }
      } catch (error) {
        ErrorUtil.logError(error)
      }
    }
  }

  static checkFileExists(filePath: string): boolean {
    try {
      // 使用fileIo.accessSync方法检查文件是否存在
      return fileIo.accessSync(filePath, fileIo.AccessModeType.EXIST);
    } catch (error) {
      ErrorUtil.logError(error)
      return false;
    }
  }
}
