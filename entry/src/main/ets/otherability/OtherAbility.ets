import { AbilityConstant, Want } from '@kit.AbilityKit';
import { BaseUIAbility } from '../base/BaseUIAbility';
import { PAGE_START_OTHER } from '../pages/PageName';
import { HiLog, Log } from 'static_library_common';

export default class OtherAbility extends BaseUIAbility {

  localStorage = new LocalStorage()

  getInitPageName(): string {
    return PAGE_START_OTHER
  }

  getLocalStorage(): LocalStorage | null {
    return this.localStorage
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    HiLog.info(this.TAG + 'Ability onCreate');
    this.getWantParams(want)
    // 在另一个Ability获取AppStorage的值
    this.testAppStorage()
  }


  private getWantParams(want: Want) {
    // 获取want的参数
    let name = want.parameters?.["name"] ?? 'default name';
    let id = want.parameters?.["id"] ?? -1;
    HiLog.debug(this.TAG + 'name=' + name + ' id=' + id);
    // 将want解析到的参数 存储到localStorage
    this.localStorage.setOrCreate('name1', name)
    this.localStorage.setOrCreate('id1', id)
  }

  testAppStorage() {
    // 使用AppStorage获取值
    let propA: number | undefined = AppStorage.get('PropA') // propA in AppStorage == 47, propA in LocalStorage == 17
    let link1: SubscribedAbstractProperty<number> = AppStorage.link('PropA'); // link1.get() == 47
    let link2: SubscribedAbstractProperty<number> = AppStorage.link('PropA'); // link2.get() == 47
    let prop: SubscribedAbstractProperty<number> = AppStorage.prop('PropA'); // prop.get() == 47

    Log.log(`AppStorage in OtherAbility-->pro=${prop.get()} link1=${link1.get()} link2=${link2.get()} propA=${propA}`)
  }

  onDestroy(): void {
    HiLog.info(this.TAG + 'Ability onDestroy');
  }
}
