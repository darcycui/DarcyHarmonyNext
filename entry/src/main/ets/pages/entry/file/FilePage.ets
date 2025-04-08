import { common } from '@kit.AbilityKit';
import { Log } from 'static_library_common';
import { fileIo, ReadOptions, WriteOptions } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';

@Entry
@Component
struct FilePage {
  @State fileInfo: string = 'default';
  context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      this.resultText()
      this.appFileButton()
      this.userFileButton()
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  resultText() {
    Text(this.fileInfo)
      .id('FileInfo')
      .fontSize(16)
  }

  @Builder
  appFileButton() {
    Button($r("app.string.AppFile"))
      .id("AppFile")
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // 创建文件并写入文本
        let readMessage = createAppFile(this.context)
        this.fileInfo = readMessage
        // 手动复制文件
        copyAppFile(this.context)
        // 手动复制文件stream
        copyAppFileStream(this.context)
        // 手动复制文件stream2
        copyAppFileStream2(this.context)
      })
  }

  @Builder
  userFileButton() {
    Button($r("app.string.UserFile"))
      .id("UserFile")
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        openUserFile()
      })
  }
}

function createAppFile(context: Context): string {
  try {
    // app文件路径
    let fileDir = context.filesDir;
    let tempDir = context.tempDir;
    let cacheDir = context.cacheDir;
    let preferenceDir = context.preferencesDir;
    Log.info(`fileDir=${fileDir}`);
    Log.info(`tempDIr=${tempDir}`);
    Log.info(`cacheDir=${cacheDir}`);
    Log.info(`preferenceDir=${preferenceDir}`);

    // let folder = fileDir
    let folder = tempDir
    let fileName = "test.txt"
    let filePath = folder + "/" + fileName
    // 新建文件并打开
    let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
    let writeLen = fileIo.writeSync(file.fd, "this is a text file\nthis is a text file")
    Log.info(`writeLen=${writeLen}`)
    // 从文件中读取
    let arrayBuffer = new ArrayBuffer(1024)
    let readOptions: ReadOptions = {
      offset: 0,
      length: 1024
    }
    let readLen = fileIo.readSync(file.fd, arrayBuffer, readOptions)
    Log.info(`readLen=${readLen}`)
    // 截取arrayBuffer 前readLen个字节
    let buf = buffer.from(arrayBuffer, 0, readLen)
    // 转换为字符串
    let readMessage = buf.toString()
    Log.info(`read content=${readMessage}`)
    // 关闭文件
    fileIo.closeSync(file.fd)
    return readMessage
  } catch (e) {
    Log.error(`openUserFile error=${e}`)
  }
  return "default"

}

function copyAppFile(context: Context) {
  try {
    // app文件路径
    let fileDir = context.filesDir;
    Log.info(`fileDir=${fileDir}`);

    let folder = fileDir
    let fileName = "test.txt"
    let filePath = folder + "/" + fileName
    let filePathCopy = folder + "/" + "test_copy.txt"
    // 检查原文件是否存在
    let exist = fileIo.accessSync(filePath)
    if (!exist) {
      Log.error(`file ${filePath} not exist, can not copy!`)
      return
    }
    // 检查目标文件是否存在
    exist = fileIo.accessSync(filePathCopy)
    if (exist) {
      Log.error(`file ${filePathCopy} exist, delete first.`)
      // 删除文件
      fileIo.unlinkSync(filePathCopy)
    }
    // 打开原文件
    let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE)
    // 创建目标文件
    let destFile = fileIo.openSync(filePathCopy, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
    let arrayBuffer = new ArrayBuffer(1024)
    let readSize = 0
    while (true) {
      let readOptions: ReadOptions = {
        offset: readSize,
        length: 1024
      }
      // 读取原文件内容
      let readLen = fileIo.readSync(file.fd, arrayBuffer, readOptions)
      Log.info(`read readLen=${readLen}`)
      if (readLen <= 0) {
        break
      }
      readSize += readLen
      // 写入目标文件
      // arrayBuffer截取 0-readLen
      let realArrayBuffer = arrayBuffer.slice(0, readLen)
      Log.info(`write realArrayBuffer=${realArrayBuffer.byteLength}`)
      let writeOptions: WriteOptions = {
        length: readLen
      }
      fileIo.writeSync(destFile.fd, realArrayBuffer, writeOptions)
    }
  } catch (e) {
    Log.error(`openUserFile error=${e}`)
  }

}

async function copyAppFileStream(context: Context) {

  try {
    let fileDir = context.filesDir;
    Log.info(`fileDir=${fileDir}`);

    let folder = fileDir
    let fileName = "test.txt"
    let filePath = folder + "/" + fileName
    let filePathCopy = folder + "/" + "test_copy_stream.txt"
    // 检查原文件是否存在
    let exist = fileIo.accessSync(filePath)
    if (!exist) {
      Log.error(`file ${filePath} not exist, can not copy!`)
      return
    }
    // 检查目标文件是否存在
    exist = fileIo.accessSync(filePathCopy)
    if (exist) {
      Log.error(`file ${filePathCopy} exist, delete first.`)
      // 删除文件
      fileIo.unlinkSync(filePathCopy)
    }
    // 打开原文件输入流
    let fileInputStream = fileIo.createStreamSync(filePath, 'r+')
    // 打开目标文件输出流
    let fileOutputStream = fileIo.createStreamSync(filePathCopy, 'w+')

    let arrayBuffer = new ArrayBuffer(1024)
    let readSize = 0
    while (true) {
      let readOptions: ReadOptions = {
        offset: readSize,
        length: 1024
      }
      // 读取原文件内容
      let readLen: number = await fileInputStream.read(arrayBuffer, readOptions)
      Log.info(`read readLen=${readLen}`)
      if (readLen <= 0) {
        break
      }
      readSize += readLen
      // 写入目标文件
      // arrayBuffer截取 0-readLen
      let realArrayBuffer = arrayBuffer.slice(0, readLen)
      Log.info(`write realArrayBuffer=${realArrayBuffer.byteLength}`)
      let writeOptions: WriteOptions = {
        length: readLen
      }
      await fileOutputStream.write(realArrayBuffer, writeOptions)
    }
    // 关闭流
    fileInputStream.close()
    fileOutputStream.close()
  } catch (e) {
    Log.error(`openUserFile error=${e}`)
  }

}

function copyAppFileStream2(context: Context) {
  try {
    let fileDir = context.filesDir;
    Log.info(`fileDir=${fileDir}`);

    let folder = fileDir
    let fileName = "test.txt"
    let filePath = folder + "/" + fileName
    // 检查原文件是否存在
    let exist = fileIo.accessSync(filePath)
    if (!exist) {
      Log.error(`file ${filePath} not exist, can not copy!`)
      return
    }
    let filePathCopy = folder + "/" + "test_copy_stream2.txt"
    // 检查目标文件是否存在
    exist = fileIo.accessSync(filePathCopy)
    if (exist) {
      Log.error(`file ${filePathCopy} exist, delete first.`)
      // 删除文件
      fileIo.unlinkSync(filePathCopy)
    }
    // 打开原文件输入流
    let fileInputStream = fileIo.createReadStream(filePath)
    // 打开目标文件输出流
    let fileOutputStream = fileIo.createWriteStream(filePathCopy)
    //// 1.暂停模式复制
    // fileInputStream.on('readable', () => {
    //   // 读取原文件内容
    //   let data = fileInputStream.read()
    //   Log.info(`read data=${data}`)
    //   if (data) {
    //     Log.info(`read data=${data}`)
    //     // 写入目标文件
    //     fileOutputStream.write(data)
    //   } else {
    //     Log.error(`read data=null`)
    //   }
    // })
    // 2.流动模式复制
    fileInputStream.on('data', (emitData) => {
      let data = emitData?.data
      Log.info(`read data=${data}`)
      // 写入目标文件
      if (data) {
        fileOutputStream.write(data as Uint8Array)
      } else {
            Log.error(`read data=null`)
      }
    })

  } catch (e) {
    Log.error(`openUserFile error=${e}`)
  }

}

function openUserFile() {

}
