import { AbilityConstant, Want } from '@kit.AbilityKit';
import { PAGE_START } from '../pages/PageName';
import { HiLog, Log } from 'static_common';
import { BaseUIAbility } from '../base/BaseUIAbility';
import { EntryEvent } from '../event/EventName';
import { promptAction, window } from '@kit.ArkUI';
import { DataStorage } from '../pages/entry/status/localstorage/LocalStoragePage1';


export default class EntryAbility extends BaseUIAbility {
  getLocalStorage(): LocalStorage | null {
    return this.localStorage
  }
  // 创建LocalStorage
    para1: Record<string, number> = {
    'PropA': 47,
    'Tom': 100,
    'Jerry': 200
  };
  // 创建新实例并使用给定对象初始化
  localStorage: LocalStorage = new LocalStorage(this.para1);

  getInitPageName(): string {
    return PAGE_START
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onCreate(want, launchParam);
    // 获取want参数
    this.getParams(want);
    this.initEventHub()
    this.testLocalStorage()
    this.testAppStorage()
    // this.testPersistentStorage()
    // this.testEnvironment()
  }
  onWindowStageCreate(windowStage: window.WindowStage): void {
    super.onWindowStageCreate(windowStage)
    this.testPersistentStorage()

    let window = windowStage.getMainWindow()
    window.then(window => {
      let uiContext = window.getUIContext()
      uiContext.runScopedTask(() => {
        this.testEnvironment()
      })
    })
  }

  testEnvironment() {
    // 使用Environment.EnvProp将设备运行languageCode存入AppStorage中；
    Environment.envProp('languageCode', 'en');
    // 从AppStorage获取单向绑定的languageCode的变量
    const lang: SubscribedAbstractProperty<string> = AppStorage.prop('languageCode');

    if (lang.get() === 'zh') {
      Log.info('testEnvironment: 你好');
    } else {
      Log.info('testEnvironment: Hello!');
    }
  }

  testPersistentStorage() {
    PersistentStorage.persistProp('aProp', 45);
  }
  testAppStorage() {
    // 添加key value
    AppStorage.setOrCreate('PropA', 47);
    // 可以添加不同类型的 value 基本类型
    AppStorage.setOrCreate('name', "汤姆猫")
    // 可以添加不同类型的 value class类型
    AppStorage.setOrCreate('PropB', new DataStorage(100));
    // 使用AppStorage获取值
    let propA: number | undefined = AppStorage.get('PropA') // propA in AppStorage == 47, propA in LocalStorage == 17
    let link1: SubscribedAbstractProperty<number> = AppStorage.link('PropA'); // link1.get() == 47
    let link2: SubscribedAbstractProperty<number> = AppStorage.link('PropA'); // link2.get() == 47
    let prop: SubscribedAbstractProperty<number> = AppStorage.prop('PropA'); // prop.get() == 47

    link1.set(48); // 双向同步: link1.get() == link2.get() == prop.get() == 48
    Log.log(`AppStorage 修改link1-->pro=${prop.get()} link1=${link1.get()} link2=${link2.get()} propA=${propA}`)
    prop.set(1); // 单向同步: prop.get() == 1; 但 link1.get() == link2.get() == 48
    Log.log(`AppStorage 修改prop--->pro=${prop.get()} link1=${link1.get()} link2=${link2.get()} propA=${propA}`)
    link1.set(49); // 双向同步: link1.get() == link2.get() == prop.get() == 49
    Log.log(`AppStorage 修改link2-->pro=${prop.get()} link1=${link1.get()} link2=${link2.get()} propA=${propA}`)
  }

  private testLocalStorage() {
    // 添加key value
    this.localStorage.setOrCreate('Spike', 300)
    // 可以添加不同类型的 value 基本类型
    this.localStorage.setOrCreate('name', "汤姆猫")
    // 可以添加不同类型的 value class类型
    this.localStorage.setOrCreate('dataClass', new DataStorage(50));
    // 使用LocalStorage获取值
    let propA: number | undefined = this.localStorage.get('PropA') ?? -1; // propA == 47
    Log.log(`propA=${propA}`)
    let link1: SubscribedAbstractProperty<number> = this.localStorage.link('PropA'); // link1.get() == 47
    let link2: SubscribedAbstractProperty<number> = this.localStorage.link('PropA'); // link2.get() == 47
    let prop: SubscribedAbstractProperty<number> = this.localStorage.prop('PropA'); // prop.get() == 47
    link1.set(48); // 双向同步: link1.get() == link2.get() == prop.get() == 48
    Log.log(`LocalStorage 修改link1-->pro=${prop.get()} link1=${link1.get()} link2=${link2.get()} propA=${propA}`)
    prop.set(1); // 单向同步: prop.get() == 1; 但 link1.get() == link2.get() == 48
    Log.log(`LocalStorage 修改pop---->pro=${prop.get()} link1=${link1.get()} link2=${link2.get()} propA=${propA}`)
    link2.set(49); // 双向同步: link1.get() == link2.get() == prop.get() == 49
    Log.log(`LocalStorage 修改link2-->pro=${prop.get()} link1=${link1.get()} link2=${link2.get()} propA=${propA}`)
  }

  private initEventHub() {
    // eventHub 添加事件监听
    this.context.eventHub.on(EntryEvent.EVENT_CLICK, (data: string) => {
      HiLog.warn(this.TAG + 'EVENT_CLICK=' + data)
      promptAction.showToast({
        message: data
      })
    })
  }

  private getParams(want: Want) {
    let name = want.parameters?.["paramsName"];
    let id = want.parameters?.["paramsId"];
    HiLog.debug(this.TAG + 'paramsName=' + name + ' paramsId=' + id);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    super.onNewWant(want, launchParam);
    this.getParams(want);
  }

  onDestroy(): void {
    super.onDestroy();
    // 注销事件监听
    this.context.eventHub.off(EntryEvent.EVENT_CLICK)
  }
}
