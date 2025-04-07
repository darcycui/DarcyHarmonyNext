import { Log } from 'static_common';
import { promptAction } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { startAbility } from '../../../../utils/RouterHelper';

class DataAppStorage {
  code: number;

  constructor(code: number) {
    this.code = code;
  }
}

// AppStorage.setOrCreate('PropA', 47);
// AppStorage.setOrCreate('PropB', new Data(50));

@Entry()
@Component
struct AppStoragePage1 {
  @StorageLink('PropA') storageLink: number = -1;
  @StorageProp('PropB') storageLinkObject: DataAppStorage = new DataAppStorage(-100);
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext

  build() {
    Column({ space: 20 }) {
      Button(`From AppStorage ${this.storageLink}`)
        .onClick(() => {
          this.storageLink += 1;
        })

      Button(`From AppStorage ${this.storageLinkObject.code}`)
        .onClick(() => {
          this.storageLinkObject.code += 1;
        })
      Button(`跳转另一个Ability`)
        .onClick(() => {
          startOtherAbility(this.context)
        })
    }
  }
}

function startOtherAbility(context: common.UIAbilityContext) {
  startAbility(context, "OtherAbility", {"name": "张三", "id": 100})
}
