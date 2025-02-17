import { Log } from "static_common";
import { fileIo } from "@kit.CoreFileKit";

export function saveByteArrayToFile(value: Uint8Array, filePath: string) {
  let myBuffer: ArrayBufferLike = value.buffer;
  // 将证书文件复制到沙箱
  Log.info('filePath:' + filePath);
  // 检查filePath文件是否存在
  if (checkFileExists(filePath)){
    Log.info(`file ${filePath} exists, no need to create it again!`)
    return
  }
  let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
  let writeLen = fileIo.writeSync(file.fd, myBuffer);
  Log.info('write data to file succeed and size is:' + writeLen);
  fileIo.closeSync(file);
}

export function checkFileExists(filePath: string): boolean {
  try {
    // 使用fileIo.accessSync方法检查文件是否存在
    return fileIo.accessSync(filePath, fileIo.AccessModeType.EXIST);
  } catch (error) {
    return false;
  }
}