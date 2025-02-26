import { Log } from 'static_common';
import { promptAction } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';

class Data {
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
  @StorageProp('PropB') storageLinkObject: Data = new Data(-100);
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
  try {
    let want: Want = {
      deviceId: "", // TODO deviceId为空表示当前设备
      bundleName: "com.darcy.harmonys",
      abilityName: "OtherAbility",
      // 传参数
      parameters: { "name": "张三", "id": 100 }
    };
    // 吐司 toast
    promptAction.showToast({ message: "Go Ability Success" })
    context.startAbility(want);
    Log.info(`explicit start ability succeed`);
  } catch (error) {
    Log.error(`explicit start ability failed with ${error.code}`);
  }
}
