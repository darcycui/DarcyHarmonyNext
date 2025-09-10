import { common } from '@kit.AbilityKit';
import { AbilityHelper } from 'static_library_common/src/main/ets/utils/AbilityHelper';

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
      Button(`From AppStorage ${this.storageLink}`).width('100%')
        .onClick(() => {
          this.storageLink += 1;
        })

      Button(`From AppStorage ${this.storageLinkObject.code}`).width('100%')
        .onClick(() => {
          this.storageLinkObject.code += 1;
        })
      Button(`跳转另一个Ability`).width('100%')
        .onClick(() => {
          startOtherAbility(this.context)
        })
    }
  }
}

function startOtherAbility(context: common.UIAbilityContext) {
  AbilityHelper.startAbility(context, "OtherAbility", {"name": "张三", "id": 100})
}
