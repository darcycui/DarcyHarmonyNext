import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { IdentityKeyEntity } from './tables/IdentityKeyEntity';

/**
 * 数据库表名
 */
const TABLE_NAME: string = 'identity_key';

/**
 * 列名常量
 */
const COL_ID: string = 'id';
const COL_KEY_ID: string = 'key_id';
const COL_USER_ID: string = 'user_id';
const COL_PRIVATE_KEY: string = 'private_key';
const COL_PUBLIC_KEY: string = 'public_key';

/**
 * 查询所需的所有列（按顺序：id, key_id, user_id, private_key, public_key）
 */
const ALL_COLUMNS: string[] = [COL_ID, COL_KEY_ID, COL_USER_ID, COL_PRIVATE_KEY, COL_PUBLIC_KEY];

/**
 * 建表 SQL
 */
const CREATE_TABLE_SQL: string =
  'CREATE TABLE IF NOT EXISTS ' + TABLE_NAME + ' (' +
  COL_ID + ' INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  COL_KEY_ID + ' TEXT NOT NULL, ' +
  COL_USER_ID + ' INTEGER NOT NULL, ' +
  COL_PRIVATE_KEY + ' TEXT NOT NULL, ' +
  COL_PUBLIC_KEY + ' TEXT NOT NULL' +
  ')';

/**
 * 数据库配置
 */
const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'IdentityKey.db',
  securityLevel: relationalStore.SecurityLevel.S3,
  encrypt: false,
};

// ══════════════════════════════════════════════
//  内部工具函数
// ══════════════════════════════════════════════

/**
 * 将 ResultSet 的当前行转换为 IdentityKeyEntity 对象
 *
 * @param rs  ResultSet 实例（调用前须已定位到有效行）
 * @returns   转换后的实体对象
 */
function rowToEntity(rs: relationalStore.ResultSet): IdentityKeyEntity {
  return new IdentityKeyEntity(
    rs.getLong(rs.getColumnIndex(COL_ID)),
    rs.getString(rs.getColumnIndex(COL_KEY_ID)),
    rs.getLong(rs.getColumnIndex(COL_USER_ID)),
    rs.getString(rs.getColumnIndex(COL_PRIVATE_KEY)),
    rs.getString(rs.getColumnIndex(COL_PUBLIC_KEY)),
  );
}

/**
 * 将 IdentityKeyEntity 转换为 ValuesBucket（用于 insert / update）
 *
 * @param entity     实体对象
 * @param includeId  是否包含 id 字段（update 时通常不需要）
 * @returns          ValuesBucket
 */
function entityToBucket(entity: IdentityKeyEntity, includeId: boolean = false): relationalStore.ValuesBucket {
  try {
    const bucket: relationalStore.ValuesBucket = {
      'key_id': entity.keyId,
      'user_id': entity.userId,
      'private_key': entity.privateKey,
      'public_key': entity.publicKey,
    };
    if (includeId) {
      bucket['id'] = entity.id;
    }
    return bucket;
  } catch (err) {
    throw new Error('IdentityKeyDao entityToBucket 转换失败: ' + JSON.stringify(err));
  }
}

/**
 * 遍历整个 ResultSet 并转换为实体列表（调用后自动关闭结果集）
 *
 * @param resultSet  结果集
 * @returns          实体列表
 */
function resultSetToEntityList(resultSet: relationalStore.ResultSet): IdentityKeyEntity[] {
  const list: IdentityKeyEntity[] = [];
  try {
    while (resultSet.goToNextRow()) {
      list.push(rowToEntity(resultSet));
    }
    return list;
  } catch (err) {
    throw new Error('IdentityKeyDao resultSetToEntityList 遍历结果集失败: ' + JSON.stringify(err));
  } finally {
    resultSet.close();
  }
}

// ══════════════════════════════════════════════
//  IdentityKeyDao  — 数据库访问对象
// ══════════════════════════════════════════════

export class IdentityKeyDao {
  private rdbStore: relationalStore.RdbStore | null = null;
  private context: common.Context;

  constructor(context: common.Context) {
    this.context = context;
  }

  // ────────────────────────────────────────────
  //  数据库初始化
  // ────────────────────────────────────────────

  /**
   * 初始化数据库 & 建表
   *
   * 使用方式（在 UIAbility 或页面中）：
   * ```ts
   * const dao = new IdentityKeyDao(getContext(this));
   * await dao.initDatabase();
   * ```
   */
  async initDatabase(): Promise<void> {
    try {
      this.rdbStore = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
      await this.rdbStore.executeSql(CREATE_TABLE_SQL);
    } catch (err) {
      throw new Error('IdentityKeyDao 数据库初始化失败: ' + JSON.stringify(err));
    }
  }

  /**
   * 获取内部的 RdbStore 实例（若未初始化则抛出异常）
   */
  private getRdbStore(): relationalStore.RdbStore {
    if (this.rdbStore === null) {
      throw new Error('RdbStore 尚未初始化，请先调用 initDatabase 方法');
    }
    return this.rdbStore!;
  }

  // ────────────────────────────────────────────
  //  Create  —  插入
  // ────────────────────────────────────────────

  /**
   * 插入一条身份密钥记录
   *
   * @param entity 身份密钥实体（id 可忽略，由数据库自增）
   * @returns 插入成功后自动生成的主键 id
   *
   * 示例：
   * ```ts
   * const newId = await dao.insert(
   *   new IdentityKeyEntity(undefined, 'key-001', 1001, 'privKey...', 'pubKey...')
   * );
   * ```
   */
  async insert(entity: IdentityKeyEntity): Promise<number> {
    try {
      const store = this.getRdbStore();
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const rowId: number = await store.insert(TABLE_NAME, bucket);
      return rowId;
    } catch (err) {
      throw new Error('IdentityKeyDao 插入记录失败 (keyId=' + entity.keyId + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 批量插入多条身份密钥记录（使用事务保证原子性）
   *
   * @param entities 身份密钥实体列表
   * @returns 插入成功的数量
   */
  async insertBatch(entities: IdentityKeyEntity[]): Promise<number> {
    const store = this.getRdbStore();
    let successCount = 0;
    store.beginTransaction();
    try {
      for (const entity of entities) {
        const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
        await store.insert(TABLE_NAME, bucket);
        successCount++;
      }
      store.commit();
    } catch (err) {
      store.rollBack();
      throw new Error('IdentityKeyDao 批量插入失败: ' + JSON.stringify(err));
    }
    return successCount;
  }

  // ────────────────────────────────────────────
  //  Delete  —  删除
  // ────────────────────────────────────────────

  /**
   * 根据主键 id 删除记录
   *
   * @param id 主键 id
   * @returns 受影响的行数
   */
  async deleteById(id: number): Promise<number> {
    try {
      const store = this.getRdbStore();
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_ID, id);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error('IdentityKeyDao deleteById 删除记录失败 (id=' + id + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 根据 keyId 删除记录
   *
   * @param keyId 密钥唯一标识
   * @returns 受影响的行数
   */
  async deleteByKeyId(keyId: string): Promise<number> {
    try {
      const store = this.getRdbStore();
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_KEY_ID, keyId);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error('IdentityKeyDao deleteByKeyId 删除记录失败 (keyId=' + keyId + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 删除指定用户的所有身份密钥
   *
   * @param userId 用户 ID
   * @returns 受影响的行数
   */
  async deleteByUserId(userId: number): Promise<number> {
    try {
      const store = this.getRdbStore();
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error('IdentityKeyDao deleteByUserId 删除记录失败 (userId=' + userId + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 清空所有身份密钥记录
   *
   * @returns 受影响的行数
   */
  async deleteAll(): Promise<number> {
    try {
      const store = this.getRdbStore();
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error('IdentityKeyDao deleteAll 清空记录失败: ' + JSON.stringify(err));
    }
  }

  // ────────────────────────────────────────────
  //  Update  —  修改
  // ────────────────────────────────────────────

  /**
   * 根据主键 id 更新身份密钥记录
   *
   * @param entity 新的实体对象（必须包含有效的 id）
   * @returns 受影响的行数
   *
   * 示例：
   * ```ts
   * entity.publicKey = 'newPubKey...';
   * const affected = await dao.update(entity);
   * ```
   */
  async update(entity: IdentityKeyEntity): Promise<number> {
    try {
      const store = this.getRdbStore();
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_ID, entity.id);
      const rows: number = await store.update(bucket, predicates);
      return rows;
    } catch (err) {
      throw new Error('IdentityKeyDao update 更新记录失败 (id=' + entity.id + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 根据 keyId 更新身份密钥记录
   *
   * @param keyId  要匹配的密钥标识
   * @param entity 新的实体数据
   * @returns 受影响的行数
   */
  async updateByKeyId(keyId: string, entity: IdentityKeyEntity): Promise<number> {
    try {
      const store = this.getRdbStore();
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_KEY_ID, keyId);
      const rows: number = await store.update(bucket, predicates);
      return rows;
    } catch (err) {
      throw new Error('IdentityKeyDao updateByKeyId 更新记录失败 (keyId=' + keyId + '): ' + JSON.stringify(err));
    }
  }

  // ────────────────────────────────────────────
  //  Query  —  查询
  // ────────────────────────────────────────────

  /**
   * 根据主键 id 查询单条记录
   *
   * @param id 主键 id
   * @returns 匹配的实体对象，未找到时返回 undefined
   */
  async queryById(id: number): Promise<IdentityKeyEntity | undefined> {
    try {
      const store = this.getRdbStore();
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_ID, id);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      try {
        if (resultSet.goToFirstRow()) {
          return rowToEntity(resultSet);
        }
        return undefined;
      } finally {
        resultSet.close();
      }
    } catch (err) {
      throw new Error('IdentityKeyDao queryById 查询记录失败 (id=' + id + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 根据 keyId 查询单条记录
   *
   * @param keyId 密钥唯一标识
   * @returns 匹配的实体对象，未找到时返回 undefined
   */
  async queryByKeyId(keyId: string): Promise<IdentityKeyEntity | undefined> {
    try {
      const store = this.getRdbStore();
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_KEY_ID, keyId);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      try {
        if (resultSet.goToFirstRow()) {
          return rowToEntity(resultSet);
        }
        return undefined;
      } finally {
        resultSet.close();
      }
    } catch (err) {
      throw new Error('IdentityKeyDao queryByKeyId 查询记录失败 (keyId=' + keyId + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 根据 userId 查询该用户的所有身份密钥
   *
   * @param userId 用户 ID
   * @returns 匹配的实体对象列表
   */
  async queryByUserId(userId: number): Promise<IdentityKeyEntity[]> {
    try {
      const store = this.getRdbStore();
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error('IdentityKeyDao queryByUserId 查询记录失败 (userId=' + userId + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 查询所有身份密钥记录
   *
   * @returns 全部实体对象列表
   */
  async queryAll(): Promise<IdentityKeyEntity[]> {
    try {
      const store = this.getRdbStore();
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error('IdentityKeyDao queryAll 查询全部记录失败: ' + JSON.stringify(err));
    }
  }

  /**
   * 根据 keyId 列表批量查询
   *
   * @param keyIds 密钥标识列表
   * @returns 匹配的实体对象列表
   */
  async queryByKeyIds(keyIds: string[]): Promise<IdentityKeyEntity[]> {
    if (keyIds.length === 0) {
      return [];
    }
    try {
      const store = this.getRdbStore();
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.in(COL_KEY_ID, keyIds);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error('IdentityKeyDao queryByKeyIds 批量查询失败 (count=' + keyIds.length + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 根据 userId + keyId 组合查询（精确匹配）
   *
   * @param userId 用户 ID
   * @param keyId  密钥标识
   * @returns 匹配的实体对象，未找到时返回 undefined
   */
  async queryByUserIdAndKeyId(userId: number, keyId: string): Promise<IdentityKeyEntity | undefined> {
    try {
      const store = this.getRdbStore();
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      predicates.equalTo(COL_KEY_ID, keyId);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      try {
        if (resultSet.goToFirstRow()) {
          return rowToEntity(resultSet);
        }
        return undefined;
      } finally {
        resultSet.close();
      }
    } catch (err) {
      throw new Error('IdentityKeyDao queryByUserIdAndKeyId 组合查询失败 (userId=' + userId + ', keyId=' + keyId + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 执行自定义 SQL 查询（返回实体列表）
   *
   * @param sql    SQL 查询语句（如 "SELECT * FROM identity_key WHERE user_id = ?"）
   * @param params 绑定参数
   * @returns 实体对象列表
   */
  async queryBySql(sql: string, params: relationalStore.ValueType[]): Promise<IdentityKeyEntity[]> {
    try {
      const store = this.getRdbStore();
      const resultSet: relationalStore.ResultSet = await store.querySql(sql, params);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error('IdentityKeyDao queryBySql 执行SQL查询失败 (sql=' + sql + '): ' + JSON.stringify(err));
    }
  }
}
