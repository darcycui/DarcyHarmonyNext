import { Log } from 'static_common';
import { relationalStore } from '@kit.ArkData';
import { common, Context } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct DatabasePage {
  @State message: string = 'Use Database';
  context: Context = getContext(this) as common.UIAbilityContext
  rDBStore: relationalStore.RdbStore | null = null;

  aboutToAppear(): void {
    Log.log('aboutToAppear init database')
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'RdbTest.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
      encrypt: false, // 可选参数，指定数据库是否加密，默认不加密
      customDir: 'customDir/subCustomDir', // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
      isReadOnly: false // 可选参数，指定数据库是否以只读方式打开。该参数默认为false，表示数据库可读可写。该参数为true时，只允许从数据库读取数据，不允许对数据库进行写操作，否则会返回错误码801。
    };

    // 判断数据库版本，如果不匹配则需进行升降级操作
    // 假设当前数据库版本为3，表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, IDENTITY)
    const SQL_CREATE_TABLE =
      'CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, AGE INTEGER, SALARY REAL, CODES BLOB, IDENTITY UNLIMITED INT)'; // 建表Sql语句, IDENTITY为bigint类型，sql中指定类型为UNLIMITED INT

    relationalStore.getRdbStore(this.context, STORE_CONFIG, (err, store) => {
      if (err) {
        Log.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      Log.info('Succeeded in getting RdbStore.');

      // 当数据库创建时，数据库默认版本为0
      if (store.version === 0) {
        store.executeSql(SQL_CREATE_TABLE); // 创建数据表
        // 设置数据库的版本，入参为大于0的整数
        store.version = 3;
      }

      // 如果数据库版本不为0且和当前数据库版本不匹配，需要进行升降级操作
      // 当数据库存在并假定版本为1时，例应用从某一版本升级到当前版本，数据库需要从1版本升级到2版本
      if (store.version === 1) {
        // version = 1：表结构：EMPLOYEE (NAME, SALARY, CODES, ADDRESS) => version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS)
        (store as relationalStore.RdbStore).executeSql('ALTER TABLE EMPLOYEE ADD COLUMN AGE INTEGER');
        store.version = 2;
      }

      // 当数据库存在并假定版本为2时，例应用从某一版本升级到当前版本，数据库需要从2版本升级到3版本
      if (store.version === 2) {
        // version = 2：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES, ADDRESS) => version = 3：表结构：EMPLOYEE (NAME, AGE, SALARY, CODES)
        (store as relationalStore.RdbStore).executeSql('ALTER TABLE EMPLOYEE DROP COLUMN ADDRESS TEXT');
        store.version = 3;
      }
      this.rDBStore = store as relationalStore.RdbStore;
    });
    // 请确保获取到RdbStore实例后，再进行数据库的增、删、改、查等操作
  }

  build() {
    Column() {
      Text(this.message)
      Button('增')
        .margin({top: 10})
        .onClick(() => {
          if (this.rDBStore != null) {
            insertItem(this.rDBStore)
          } else {
            Log.error('rDBStore is null')
          }
        })
      Button('查')
        .margin({top: 10})
        .onClick(() => {
          if (this.rDBStore != null) {
            queryItem(this.rDBStore)
          } else {
            Log.error('rDBStore is null')
          }
        })
      Button('改')
        .margin({top: 10})
        .onClick(() => {
          if (this.rDBStore != null) {
            updateItem(this.rDBStore)
          } else {
            Log.error('rDBStore is null')
          }
        })
      Button('删')
        .margin({top: 10})
        .onClick(() => {
          if (this.rDBStore != null) {
            deleteItem(this.rDBStore)
          } else {
            Log.error('rDBStore is null')
          }
        })
      Button('删除数据库')
        .margin({top: 10})
        .onClick(() => {
          if (this.rDBStore != null) {
            deleteRDatabase(this.context)
          } else {
            Log.error('rDBStore is null')
          }
        })
      Button('备份数据库')
        .margin({top: 10})
        .onClick(() => {
          if (this.rDBStore != null) {
            backupDatabase(this.context, this.rDBStore)
          } else {
            Log.error('rDBStore is null')
          }
        })
      Button('恢复数据库')
        .margin({top: 10})
        .onClick(() => {
          if (this.rDBStore != null) {
            restoreDatabase(this.rDBStore)
          } else {
            Log.error('rDBStore is null')
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}

function deleteRDatabase(context: Context) {
  relationalStore.deleteRdbStore(context, 'RdbTest.db', (err: BusinessError) => {
    if (err) {
      Log.error(`Failed to delete RdbStore. Code:${err.code}, message:${err.message}`);
      return;
    }
    Log.info('Succeeded in deleting RdbStore.');
  });

}

function restoreDatabase(rDBStore: relationalStore.RdbStore) {
  rDBStore.restore("Backup.db", (err: BusinessError) => {
    if (err) {
      Log.error(`Failed to restore RdbStore. Code:${err.code}, message:${err.message}`);
      return;
    }
    Log.info(`Succeeded in restoring RdbStore.`);
  })
}

function backupDatabase(context:Context, rDBStore: relationalStore.RdbStore) {
  let backupPath = context.databaseDir + '/rdb/customDir/' + "Backup.db"
  // "Backup.db"为备份数据库文件名，默认在RdbStore同路径下备份。也可指定路径：customDir + "backup.db"
  rDBStore.backup(backupPath, (err: BusinessError) => {
    if (err) {
      Log.error(`Failed to backup RdbStore. Code:${err.code}, message:${err.message}`);
      return;
    }
    Log.info(`Succeeded in backing up RdbStore.`);
  })
}

function queryItem(rDBStore: relationalStore.RdbStore) {
  let predicates2 = new relationalStore.RdbPredicates('EMPLOYEE');
  // predicates2.equalTo('NAME', 'Lisa');
  // predicates2.equalTo('NAME', 'Rose');
  rDBStore.query(predicates2, [], (err: BusinessError, resultSet) => {
    if (err) {
      Log.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
      return;
    }
    Log.info(`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);
    // resultSet是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始。
    while (resultSet.goToNextRow()) {
      const id = resultSet.getLong(resultSet.getColumnIndex('ID'));
      const name = resultSet.getString(resultSet.getColumnIndex('NAME'));
      const age = resultSet.getLong(resultSet.getColumnIndex('AGE'));
      const salary = resultSet.getDouble(resultSet.getColumnIndex('SALARY'));
      const identity = resultSet.getValue(resultSet.getColumnIndex('IDENTITY'));
      Log.info(`id=${id}, name=${name}, age=${age}, salary=${salary}, identity=${identity}`);
    }
    // TODO 释放数据集的内存
    resultSet.close();
  })
}

function deleteItem(rDBStore: relationalStore.RdbStore) {
  // 删除数据
  let predicates = new relationalStore.RdbPredicates('EMPLOYEE');
  predicates.equalTo('NAME', 'Rose');
  rDBStore.delete(predicates, (err: BusinessError, rows: number) => {
    if (err) {
      Log.error(`Failed to delete data. Code:${err.code}, message:${err.message}`);
      return;
    }
    Log.info(`Delete rows: ${rows}`);
  })
}

function updateItem(rDBStore: relationalStore.RdbStore) {
  let value6 = 'Rose';
  let value7 = 22;
  let value8 = 200.5;
  let value9 = new Uint8Array([1, 2, 3, 4, 5]);
  let value10 = BigInt('15822401018187971967863');
  const valueBucket5: relationalStore.ValuesBucket = {
    NAME: value6,
    AGE: value7,
    SALARY: value8,
    CODES: value9,
    IDENTITY: value10,
  };

  // 修改数据
  let predicates = new relationalStore.RdbPredicates('EMPLOYEE'); // 创建表EMPLOYEE的predicates
  predicates.equalTo('NAME', 'Lisa'); // 匹配表EMPLOYEE中NAME为Lisa的字段
  rDBStore.update(valueBucket5, predicates, (err: BusinessError, rows: number) => {
    if (err) {
      Log.error(`Failed to update data. Code:${err.code}, message:${err.message}`);
      return;
    }
    Log.info(`Succeeded in updating data. row count: ${rows}`);
  })
}

function insertItem(rDBStore: relationalStore.RdbStore) {
  let value1 = 'Lisa';
  let value2 = 18;
  let value3 = 100.5;
  let value4 = new Uint8Array([1, 2, 3, 4, 5]);
  let value5 = BigInt('15822401018187971961171');

  const valueBucket2: relationalStore.ValuesBucket = {
    NAME: value1,
    AGE: value2,
    SALARY: value3,
    CODES: value4,
    IDENTITY: value5,
  };
  let table = 'EMPLOYEE'
  // 插入数据
  rDBStore.insert(table, valueBucket2, (err: BusinessError, rowId: number) => {
    if (err) {
      Log.error(`Failed to insert data. Code:${err.code}, message:${err.message}`);
      return;
    }
    Log.info(`Succeeded in inserting data. rowId:${rowId}`);
  })
}