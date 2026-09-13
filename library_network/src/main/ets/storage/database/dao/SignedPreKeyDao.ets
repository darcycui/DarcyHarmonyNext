import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { SignedPreKeyEntity } from '../tables/SignedPreKeyEntity';

/**
 * 数据库表名
 */
const TABLE_NAME: string = 'signed_pre_key';

/**
 * 列名常量
 */
const COL_ID: string = 'id';
const COL_KEY_ID: string = 'key_id';
const COL_IDENTITY_KEY_ID: string = 'identity_key_id';
const COL_USER_ID: string = 'user_id';
const COL_PRIVATE_KEY: string = 'private_key';
const COL_PUBLIC_KEY: string = 'public_key';
const COL_SIGNATURE: string = 'signature';

/**
 * 查询所需的所有列（按顺序）
 */
const ALL_COLUMNS: string[] = [
  COL_ID, COL_KEY_ID, COL_IDENTITY_KEY_ID,
  COL_USER_ID, COL_PRIVATE_KEY, COL_PUBLIC_KEY, COL_SIGNATURE,
];

/**
 * 建表 SQL
 */
const CREATE_TABLE_SQL: string =
  'CREATE TABLE IF NOT EXISTS ' + TABLE_NAME + ' (' +
  COL_ID + ' INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  COL_KEY_ID + ' TEXT NOT NULL, ' +
  COL_IDENTITY_KEY_ID + ' TEXT NOT NULL, ' +
  COL_USER_ID + ' INTEGER NOT NULL, ' +
  COL_PRIVATE_KEY + ' TEXT NOT NULL, ' +
  COL_PUBLIC_KEY + ' TEXT NOT NULL, ' +
  COL_SIGNATURE + ' TEXT NOT NULL' +
  ')';

/**
 * 数据库配置
 */
const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'SignedPreKey.db',
  securityLevel: relationalStore.SecurityLevel.S3,
  encrypt: false,
};

// ══════════════════════════════════════════════
//  内部工具函数
// ══════════════════════════════════════════════

/**
 * 将 ResultSet 的当前行转换为 SignedPreKeyEntity 对象
 *
 * @param rs  ResultSet 实例（调用前须已定位到有效行）
 * @returns   转换后的实体对象
 */
function rowToEntity(rs: relationalStore.ResultSet): SignedPreKeyEntity {
  try {
    return new SignedPreKeyEntity(
      rs.getLong(rs.getColumnIndex(COL_ID)),
      rs.getString(rs.getColumnIndex(COL_KEY_ID)),
      rs.getString(rs.getColumnIndex(COL_IDENTITY_KEY_ID)),
      rs.getLong(rs.getColumnIndex(COL_USER_ID)),
      rs.getString(rs.getColumnIndex(COL_PRIVATE_KEY)),
      rs.getString(rs.getColumnIndex(COL_PUBLIC_KEY)),
      rs.getString(rs.getColumnIndex(COL_SIGNATURE)),
    );
  } catch (error) {
    throw new Error('SignedPreKeyDao rowToEntity 转换失败: ' + JSON.stringify(error));
  }
}

/**
 * 将 SignedPreKeyEntity 转换为 ValuesBucket（用于 insert / update）
 *
 * @param entity     实体对象
 * @param includeId  是否包含 id 字段（update 时通常不需要）
 * @returns          ValuesBucket
 */
function entityToBucket(entity: SignedPreKeyEntity, includeId: boolean = false): relationalStore.ValuesBucket {
  try {
    const bucket: relationalStore.ValuesBucket = {
      'key_id': entity.keyId,
      'identity_key_id': entity.identityKeyId,
      'user_id': entity.userId,
      'private_key': entity.privateKey,
      'public_key': entity.publicKey,
      'signature': entity.signature,
    };
    if (includeId) {
      bucket['id'] = entity.id;
    }
    return bucket;
  } catch (err) {
    throw new Error('SignedPreKeyDao entityToBucket 转换失败: ' + JSON.stringify(err));
  }
}

/**
 * 将 ResultSet 中所有行转换为 SignedPreKeyEntity 列表
 *
 * @param rs  已执行查询且未关闭的 ResultSet
 * @returns   实体列表（若无数据则返回空数组）
 */
function resultSetToEntityList(rs: relationalStore.ResultSet): SignedPreKeyEntity[] {
  const list: SignedPreKeyEntity[] = [];
  try {
    while (rs.goToNextRow()) {
      list.push(rowToEntity(rs));
    }
  } catch (err) {
    throw new Error('SignedPreKeyDao resultSetToEntityList 遍历结果集失败: ' + JSON.stringify(err));
  }
  return list;
}

// ══════════════════════════════════════════════
//  SignedPreKeyDao  — 数据库访问对象
// ══════════════════════════════════════════════

export class SignedPreKeyDao {
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
   * const dao = new SignedPreKeyDao(getContext(this));
   * await dao.initDatabase();
   * ```
   */
  async initDatabase(): Promise<void> {
    try {
      this.rdbStore = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
      await this.rdbStore.executeSql(CREATE_TABLE_SQL);
    } catch (err) {
      throw new Error('SignedPreKeyDao 数据库初始化失败: ' + JSON.stringify(err));
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
   * 插入一条已签名预密钥记录
   *
   * @param entity 已签名预密钥实体（id 可忽略，由数据库自增）
   * @returns 插入成功后自动生成的主键 id
   *
   * 示例：
   * ```ts
   * const newId = await dao.insert(
   *   new SignedPreKeyEntity(undefined, 'spk-001', 'ik-001', 1001, 'privKey...', 'pubKey...', 'signature...')
   * );
   * ```
   */
  async insert(entity: SignedPreKeyEntity): Promise<number> {
    try {
      const store = this.getRdbStore();
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const rowId: number = await store.insert(TABLE_NAME, bucket);
      return rowId;
    } catch (err) {
      throw new Error('SignedPreKeyDao 插入记录失败 (keyId=' + entity.keyId + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 批量插入多条已签名预密钥记录（使用事务保证原子性）
   *
   * @param entities 已签名预密钥实体列表
   * @returns 插入成功的数量
   */
  async insertBatch(entities: SignedPreKeyEntity[]): Promise<number> {
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
      throw new Error('SignedPreKeyDao 批量插入失败: ' + JSON.stringify(err));
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
   * @returns 删除的记录数
   */
  async deleteById(id: number): Promise<number> {
    try {
      const store = this.getRdbStore();
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_ID, id);
      const deletedRows: number = await store.delete(predicates);
      return deletedRows;
    } catch (err) {
      throw new Error('SignedPreKeyDao deleteById 删除记录失败 (id=' + id + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 根据 keyId 删除记录
   *
   * @param keyId 密钥唯一标识
   * @returns 删除的记录数
   */
  async deleteByKeyId(keyId: string): Promise<number> {
    try {
      const store = this.getRdbStore();
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_KEY_ID, keyId);
      const deletedRows: number = await store.delete(predicates);
      return deletedRows;
    } catch (err) {
      throw new Error('SignedPreKeyDao deleteByKeyId 删除记录失败 (keyId=' + keyId + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 根据 userId 删除记录
   *
   * @param userId 用户 ID
   * @returns 删除的记录数
   */
  async deleteByUserId(userId: number): Promise<number> {
    try {
      const store = this.getRdbStore();
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      const deletedRows: number = await store.delete(predicates);
      return deletedRows;
    } catch (err) {
      throw new Error('SignedPreKeyDao deleteByUserId 删除记录失败 (userId=' + userId + '): ' + JSON.stringify(err));
    }
  }

  // ────────────────────────────────────────────
  //  Update  —  修改
  // ────────────────────────────────────────────

  /**
   * 更新一条已签名预密钥记录
   *
   * @param entity 已签名预密钥实体（必须包含有效的 id）
   * @returns 更新的记录数
   */
  async update(entity: SignedPreKeyEntity): Promise<number> {
    try {
      const store = this.getRdbStore();
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, true);
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_ID, entity.id);
      const updatedRows: number = await store.update(bucket, predicates);
      return updatedRows;
    } catch (err) {
      throw new Error('SignedPreKeyDao 更新记录失败 (id=' + entity.id + '): ' + JSON.stringify(err));
    }
  }

  // ────────────────────────────────────────────
  //  Query  —  查询
  // ────────────────────────────────────────────

  /**
   * 查询所有已签名预密钥记录
   *
   * @returns 所有已签名预密钥实体列表
   */
  async getAll(): Promise<SignedPreKeyEntity[]> {
    try {
      const store = this.getRdbStore();
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      const rs: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      const list = resultSetToEntityList(rs);
      rs.close();
      return list;
    } catch (err) {
      throw new Error('SignedPreKeyDao getAll 查询失败: ' + JSON.stringify(err));
    }
  }

  /**
   * 根据主键 id 查询
   *
   * @param id 主键 id
   * @returns 实体对象，未找到时返回 null
   */
  async getById(id: number): Promise<SignedPreKeyEntity | null> {
    try {
      const store = this.getRdbStore();
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_ID, id);
      const rs: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      let result: SignedPreKeyEntity | null = null;
      if (rs.goToFirstRow()) {
        result = rowToEntity(rs);
      }
      rs.close();
      return result;
    } catch (err) {
      throw new Error('SignedPreKeyDao getById 查询失败 (id=' + id + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 根据 keyId 查询
   *
   * @param keyId 密钥唯一标识
   * @returns 实体对象，未找到时返回 null
   */
  async getByKeyId(keyId: string): Promise<SignedPreKeyEntity | null> {
    try {
      const store = this.getRdbStore();
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_KEY_ID, keyId);
      const rs: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      let result: SignedPreKeyEntity | null = null;
      if (rs.goToFirstRow()) {
        result = rowToEntity(rs);
      }
      rs.close();
      return result;
    } catch (err) {
      throw new Error('SignedPreKeyDao getByKeyId 查询失败 (keyId=' + keyId + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 根据 userId 查询所有关联的已签名预密钥
   *
   * @param userId 用户 ID
   * @returns 已签名预密钥实体列表
   */
  async getByUserId(userId: number): Promise<SignedPreKeyEntity[]> {
    try {
      const store = this.getRdbStore();
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      const rs: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      const list = resultSetToEntityList(rs);
      rs.close();
      return list;
    } catch (err) {
      throw new Error('SignedPreKeyDao getByUserId 查询失败 (userId=' + userId + '): ' + JSON.stringify(err));
    }
  }

  /**
   * 获取记录总数
   *
   * @returns 记录总数
   */
  async getCount(): Promise<number> {
    try {
      const store = this.getRdbStore();
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      const rs: relationalStore.ResultSet = await store.query(predicates, ['COUNT(*) AS count']);
      let count: number = 0;
      if (rs.goToFirstRow()) {
        count = rs.getLong(0);
      }
      rs.close();
      return count;
    } catch (err) {
      throw new Error('SignedPreKeyDao getCount 查询失败: ' + JSON.stringify(err));
    }
  }
}
