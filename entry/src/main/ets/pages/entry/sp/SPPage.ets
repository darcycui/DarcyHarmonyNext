import { common, Context } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { Log } from 'static_common/src/main/ets/utils/Log';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct SPPage {
  @State info: string = 'default';
  context = getContext(this) as common.UIAbilityContext;
  // 指定sp名称
  options: preferences.Options = {
    name: 'test.sp',
    // dataGroupId: 'group_id_1',
  }
  // 获取sp实例
  sp = preferences.getPreferencesSync(this.context, this.options);

  build() {
    Column() {
      Text(this.info)
      Button("监听变化")
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          addListener(this.sp)
        })
      Button("写入内存")
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          putSP('key1', 'value1', this.sp)
        })
      Button("写入文件")
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          flushSP(this.sp)
        })
      Button("读取")
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          getSP(this.sp)
        })
      Button("删除key")
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          deleteSP('key1', this.sp)
        })
      Button("清空sp")
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          clearSP(this.sp)
        })
      Button("删除sp")
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          deletePreference(this.context, this.options)
        })
    }
    .height('100%')
    .width('100%')
  }
}

function deletePreference(context: Context, options: preferences.Options) {
  Log.info('deletePreference')
  preferences.deletePreferences(context, options, (error: BusinessError) => {
    if (error) {
      Log.error(`deletePreferences error=${error}`);
    } else {
      Log.info('deletePreferences success');
    }
  });
}

function clearSP(sp: preferences.Preferences) {
  Log.info('clear')
  sp.clearSync()
}

function flushSP(sp: preferences.Preferences) {
  sp.flush((error: BusinessError) => {
    if (error) {
      Log.error(`flush error=${error}`);
    } else {
      Log.info('flush success');
    }
  });
}

function deleteSP(key: string, sp: preferences.Preferences) {
  Log.info(`delete key=${key}`)
  sp.deleteSync(key)
}

function putSP(key: string, value: string, sp: preferences.Preferences) {
  Log.info(`put key=${key} value=${value}`)
  sp.putSync(key, value)
}

function getSP(sp: preferences.Preferences) {
  Log.info('on read')
  let value1 = sp.getSync('key1', 'default');
  Log.warn(`readSP value1=${value1}`)
  let value2 = sp.getSync('key2', 'default');
  Log.warn(`readSP value2=${value2}`)
}

// 订阅数据变更 当执行flush()时触发
function addListener(sp: preferences.Preferences) {
  Log.info('on listener')
  sp.on('change', (key: string) => {
    Log.warn(`The key ${key} changed.`)
    getSP(sp)
  })
}
