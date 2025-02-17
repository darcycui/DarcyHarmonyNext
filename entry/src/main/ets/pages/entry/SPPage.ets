import { common, Context } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { Log } from 'static_common/src/main/ets/utils/Log';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct SPPage {
  @State info: string = 'default';
  context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      this.aText()
      this.aButton()
      this.bButton()
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  aText() {
    Text(this.info)
      .id('FileInfo')
      .fontSize(16)
  }

  @Builder
  aButton() {
    Button($r("app.string.TextSP"))
      .id("TextSP")
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        testPreferences(this.context)
      })
  }

  @Builder
  bButton() {
    Button($r("app.string.AnotherSP"))
      .id("AnotherSP")
      .margin({ left: 10 })// 外边距
      .onClick((event: ClickEvent) => {
        // 指定sp名称
        let options: preferences.Options = {
          name: 'test.sp',
          // dataGroupId: 'group_id_1',
        }
        // 获取sp实例
        let sp = preferences.getPreferencesSync(this.context, options);
        // 读取数据
        Log.error('testPreferences get second')
        readSP(sp);
        // sp.putSync('key1', 'value111')
        // spFlush(sp);
      })
  }
}

function testPreferences(context: Context) {
  // 指定sp名称
  let options: preferences.Options = {
    name: 'test.sp',
    // dataGroupId: 'group_id_1',
  }
  // 获取sp实例
  let sp = preferences.getPreferencesSync(context, options);
  // 读取数据
  Log.error('testPreferences get first')
  readSP(sp);
  // 存储数据(存储到内存)
  Log.info('testPreferences put')
  sp.putSync('key1', 'value1');
  sp.putSync('key2', 'value2');
  // 持久化写入文件
  spFlush(sp);
  // 读取数据
  readSP(sp);
  // 删除数据
  // sp.deleteSync('key1')
  // Log.info('testPreferences delete key1')
  // readSP(sp);
  // Log.info('testPreferences clear')
  // sp.clearSync()
  // readSP(sp);
  // 等待3秒
  setTimeout(()=>{
    // 订阅数据变更
    Log.info('testPreferences on listener')
    sp.on('change', (key: string)=>{
      Log.warn(`The key ${key} changed.`)
      readSP(sp)
    })
    Log.info('testPreferences change key1')
    sp.putSync('key1', 'value100');
    spFlush(sp);
  }, 3000)
  // 持久化写入文件 触发订阅
  // spFlush(sp);
  // // 删除sp
  // preferences.deletePreferences(context, options, (error: BusinessError) => {
  //   if (error) {
  //     Log.error(`testPreferences deletePreferences error=${error}`)
  //   } else {
  //     Log.info('testPreferences deletePreferences success')
  //   }
  // })

}

function spFlush(sp: preferences.Preferences) {
  sp.flush((error: BusinessError) => {
    if (error) {
      Log.error(`testPreferences flush error=${error}`);
    } else {
      Log.info('testPreferences flush success');
    }
  });
}

function readSP(sp: preferences.Preferences) {
  let value1 = sp.getSync('key1', 'default');
  Log.warn(`readSP value1=${value1}`)
  let value2 = sp.getSync('key2', 'default');
  Log.warn(`readSP value2=${value2}`)
}
