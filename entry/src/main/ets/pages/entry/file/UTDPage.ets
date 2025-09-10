import { uniformTypeDescriptor } from '@kit.ArkData';

@Entry
@Component
struct UTDPage {
  @State message: string = '标准数据类型UTD';

  build() {
    Column() {
      Text(this.message)
      Button('根据.mp3 后缀查询类型').width('100%').onClick(() => {
        this.getByFileExtention('.mp3');
      }).margin({ top: 10 })
      Button('根据audio/mp3 MIME查询类型').width('100%').onClick(() => {
        this.getByMIME('audio/mp3');
      }).margin({ top: 10 })
      Button('比较两种查询得到的类型').width('100%').onClick(() => {
        this.compareTwoTypes();
      }).margin({ top: 10 })
      Button('根据后缀查MIME').width('100%').onClick(() => {
        this.getMIMEByExtention();
      }).margin({ top: 10 })
      Button('根据MIME查后缀').width('100%').onClick(() => {
        this.getExtentionByMIME();
      }).margin({ top: 10 })
      Button('根据.myImage 后缀查询自定义类型').width('100%').onClick(() => {
        this.getByFileExtention('.myImage');
      }).margin({ top: 10 })
      Button('根据 application/myImage MIME查询自定义类型').width('100%').onClick(() => {
        this.getByMIME('application/myImage');
      }).margin({ top: 10 })
    }
    .height('100%')
    .width('100%')
  }

  getExtentionByMIME() {
    try {
      // 2.可根据 “audio/mp3” MIMEType查询对应UTD数据类型
      let mineType = 'audio/mp3';
      let typeId = uniformTypeDescriptor.getUniformDataTypeByMIMEType(mineType);
      // 3. 根据UTD数据类型查询对应的MIMEType列表
      let typeObj = uniformTypeDescriptor.getTypeDescriptor(typeId);
      let filenameExtensions = typeObj.filenameExtensions;
      console.info('filenameExtensions:' + filenameExtensions);
    } catch (err) {
      console.error('err message:' + err.message + ', err code:' + err.code);
    }
  }

  getMIMEByExtention() {
    try {
      // 2.可根据 “.mp3” 文件后缀查询对应UTD数据类型
      let fileExtention = '.mp3';
      let typeId = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension(fileExtention);
      // 3.根据UTD数据类型查询对应的MIMEType列表
      let typeObj = uniformTypeDescriptor.getTypeDescriptor(typeId);
      let mimeTypes = typeObj.mimeTypes;
      console.info('mimeTypes:' + mimeTypes);
    } catch (err) {
      console.error('err message:' + err.message + ', err code:' + err.code);
    }
  }

  compareTwoTypes() {
    let typeObj1 = this.getByFileExtention('.mp3');
    let typeObj2 = this.getByMIME('audio/mp3');
    if (typeObj1 != null && typeObj2 != null) {
      let ret = typeObj1.equals(typeObj2);
      console.info('typeObj1 equals typeObj2, ret:' + ret);
    } else {
      console.info('typeObj1 or typeObj2 is null');
    }
  }

  private getByMIME(mineType: string) {
    try {
      let typeId2 = uniformTypeDescriptor.getUniformDataTypeByMIMEType(mineType);
      let typeObj2 = uniformTypeDescriptor.getTypeDescriptor(typeId2);
      console.info('typeId:' + typeObj2.typeId);
      console.info('belongingToTypes:' + typeObj2.belongingToTypes);
      console.info('description:' + typeObj2.description);
      console.info('filenameExtensions:' + typeObj2.filenameExtensions);
      console.info('mimeTypes:' + typeObj2.mimeTypes);
      return typeObj2
    } catch (e) {
      console.error('err message:' + e.message + ', err code:' + e.code);
    }
    return null
  }

  private getByFileExtention(fileExtention: string) {
    try {
      let typeId1 = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension(fileExtention);
      let typeObj1 = uniformTypeDescriptor.getTypeDescriptor(typeId1);
      console.info('typeId:' + typeObj1.typeId);
      console.info('belongingToTypes:' + typeObj1.belongingToTypes);
      console.info('description:' + typeObj1.description);
      console.info('referenceURL:' + typeObj1.referenceURL);
      console.info('filenameExtensions:' + typeObj1.filenameExtensions);
      console.info('mimeTypes:' + typeObj1.mimeTypes);
      return typeObj1
    } catch (e) {
      console.error('err message:' + e.message + ', err code:' + e.code);
    }
    return null
  }
}