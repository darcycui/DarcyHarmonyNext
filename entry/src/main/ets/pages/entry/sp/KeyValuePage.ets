import { common } from '@kit.AbilityKit';
import { distributedKVStore } from '@kit.ArkData';
import { Log } from 'static_library_common';
import { BusinessError } from '@kit.BasicServicesKit';

const KEY_ = 'key_test_string';
const VALUE_ = 'value_test_string';

@Entry
@Component
struct KeyValuePage {
  @State info: string = 'default';
  context = getContext(this) as common.UIAbilityContext;
  // kvManager配置
  kvManagerConfig: distributedKVStore.KVManagerConfig = {
    context: this.context,
    bundleName: 'com.darcy.harmonys'
  };
  // 获取kvManager实例
  kvManager: distributedKVStore.KVManager = distributedKVStore.createKVManager(this.kvManagerConfig);
  // 创建kvStore
  kvStore: distributedKVStore.SingleKVStore | undefined = undefined;

  aboutToAppear(): void {
    Log.info(`aboutToAppear`);
    try {
      const options: distributedKVStore.Options = {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: false,
        // kvStoreType不填时，默认创建多设备协同数据库
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
        // 多设备协同数据库：kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION,
        securityLevel: distributedKVStore.SecurityLevel.S1
      };
      this.kvManager.getKVStore<distributedKVStore.SingleKVStore>('storeId', options,
        (err, store: distributedKVStore.SingleKVStore) => {
          if (err) {
            console.error(`Failed to get KVStore: Code:${err.code},message:${err.message}`);
            return;
          }
          console.info('Succeeded in getting KVStore.');
          this.kvStore = store;
          // 请确保获取到键值数据库实例后，再进行相关数据操作
        });
    } catch (e) {
      Log.error(`createKVStore error: ${e}`);
    }
  }
  onDidBuild(): void {
    Log.info(`onDidBuild`);
  }
  aboutToDisappear(): void {
    Log.info(`aboutToDisappear`);
    try {
      closeKV(this.kvManager, this.kvStore)
    } catch (e) {
      Log.error(`closeKVStore error: ${e}`);
    }
  }

  build() {
    Column() {
      Text(this.info)
      Button("创建KVStore").width('100%')
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          Log.log('已经在aboutToAppear中创建kvStore')
        })
      Button("写入").width('100%')
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          if (this.kvStore != undefined) {
            putKV(this.kvStore);
          } else {
            Log.error(`kvStore is undefined`);
          }
        })
      Button("读取").width('100%')
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          if (this.kvStore != undefined) {
            getKV(this.kvStore);
          } else {
            Log.error(`kvStore is undefined`);
          }
        })
      Button("删除key").width('100%')
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          if (this.kvStore != undefined) {
            deleteKV(this.kvStore);
          } else {
            Log.error(`kvStore is undefined`);
          }
        })
      Button("关闭KVStore").width('100%')
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          closeKV(this.kvManager, this.kvStore);
        })
      Button("删除KvStore").width('100%')
        .margin({ top: 10 })// 外边距
        .onClick((event: ClickEvent) => {
          if (this.kvStore != undefined) {
            deleteKV(this.kvStore);
          } else {
            Log.error(`kvStore is undefined`);
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}


function closeKV(kvManager: distributedKVStore.KVManager, kvStore: distributedKVStore.SingleKVStore | undefined) {
  try {
    kvStore = undefined;
    kvManager.closeKVStore('appId', 'storeId', (err: BusinessError) => {
      if (err) {
        console.error(`Failed to close KVStore.code is ${err.code},message is ${err.message}`);
        return;
      }
      console.info('Succeeded in closing KVStore');
    });
  } catch (e) {
    let error = e as BusinessError;
    console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
  }
}

function deleteKV(kvStore: distributedKVStore.SingleKVStore) {
  try {
    kvStore.delete(KEY_, (err) => {
      if (err !== undefined) {
        console.error(`Failed to delete data. Code:${err.code},message:${err.message}`);
        return;
      }
      console.info('Succeeded in deleting data.');
    });
  } catch (e) {
    let error = e as BusinessError;
    console.error(`Failed to delete data. Code:${error.code},message:${error.message}`);
  }
}

function getKV(kvStore: distributedKVStore.SingleKVStore) {
  try {
    kvStore.get(KEY_, (err, data) => {
      if (err != undefined) {
        console.error(`Failed to get data. Code:${err.code},message:${err.message}`);
        return;
      }
      console.info(`Succeeded in getting data. Data:${data}`);
    });
  } catch (e) {
    let error = e as BusinessError;
    console.error(`Failed to get data. Code:${error.code},message:${error.message}`);
  }
}

function putKV(kvStore: distributedKVStore.SingleKVStore) {
  try {
    kvStore.put(KEY_, VALUE_, (err) => {
      if (err !== undefined) {
        console.error(`Failed to put data. Code:${err.code},message:${err.message}`);
        return;
      }
      console.info('Succeeded in putting data.');
    });
  } catch (e) {
    let error = e as BusinessError;
    console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
  }
}
