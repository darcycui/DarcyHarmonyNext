import { relationalStore } from '@kit.ArkData';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { SkippedMessageKeyEntity } from '../tables/SkippedMessageKeyEntity';

/**
 * 数据库表名
 */
const TABLE_NAME: string = 'skipped_message_key';

/**
 * 列名常量
 */
const COL_ID: string = 'id';
const COL_USER_ID: string = 'user_id';
const COL_TARGET_ID: string = 'target_id';
const COL_MSG_ID: string = 'msg_id';
const COL_DH_PUBLIC_KEY: string = 'dh_public_key';
const COL_CHAIN_INDEX: string = 'chain_index';
const COL_MESSAGE_KEY: string = 'message_key';
const COL_MAC_KEY: string = 'mac_key';
const COL_IV: string = 'iv';
const COL_CREATED_TIME: string = 'created_time';

/**
 * 查询所需的所有列（按顺序）
 */
const ALL_COLUMNS: string[] = [
  COL_ID, COL_USER_ID, COL_TARGET_ID, COL_MSG_ID, COL_DH_PUBLIC_KEY,
  COL_CHAIN_INDEX, COL_MESSAGE_KEY, COL_MAC_KEY, COL_IV, COL_CREATED_TIME,
];

// ══════════════════════════════════════════════
//  内部工具函数
// ══════════════════════════════════════════════

/**
 * 将 ResultSet 的当前行转换为 SkippedMessageKeyEntity 对象
 *
 * @param rs  ResultSet 实例（调用前须已定位到有效行）
 * @returns   转换后的实体对象
 */
function rowToEntity(rs: relationalStore.ResultSet): SkippedMessageKeyEntity {
  try {
    return new SkippedMessageKeyEntity(
      rs.getLong(rs.getColumnIndex(COL_ID)),
      rs.getLong(rs.getColumnIndex(COL_USER_ID)),
      rs.getLong(rs.getColumnIndex(COL_TARGET_ID)),
      rs.getString(rs.getColumnIndex(COL_MSG_ID)),
      rs.getString(rs.getColumnIndex(COL_DH_PUBLIC_KEY)),
      rs.getLong(rs.getColumnIndex(COL_CHAIN_INDEX)),
      rs.getString(rs.getColumnIndex(COL_MESSAGE_KEY)),
      rs.getString(rs.getColumnIndex(COL_MAC_KEY)),
      rs.getString(rs.getColumnIndex(COL_IV)),
      rs.getString(rs.getColumnIndex(COL_CREATED_TIME)),
    );
  } catch (error) {
    throw new Error('SkippedMessageKeyDao rowToEntity 转换失败: ' + JSON.stringify(error));
  }
}

/**
 * 将 SkippedMessageKeyEntity 转换为 ValuesBucket（用于 insert / update）
 *
 * @param entity     实体对象
 * @param includeId  是否包含 id 字段（update 时通常不需要）
 * @returns          ValuesBucket
 */
function entityToBucket(entity: SkippedMessageKeyEntity, includeId: boolean = false): relationalStore.ValuesBucket {
  try {
    const bucket: relationalStore.ValuesBucket = {
      'user_id': entity.userId,
      'target_id': entity.targetId,
      'msg_id': entity.msgId,
      'dh_public_key': entity.dhPublicKey,
      'chain_index': entity.chainIndex,
      'message_key': entity.messageKey,
      'mac_key': entity.macKey,
      'iv': entity.iv,
      'created_time': entity.createdTime,
    };
    if (includeId) {
      bucket['id'] = entity.id;
    }
    return bucket;
  } catch (err) {
    throw new Error('SkippedMessageKeyDao entityToBucket 转换失败: ' + JSON.stringify(err));
  }
}

/**
 * 遍历整个 ResultSet 并转换为实体列表（调用后自动关闭结果集）
 *
 * @param resultSet  结果集
 * @returns          实体列表
 */
function resultSetToEntityList(resultSet: relationalStore.ResultSet): SkippedMessageKeyEntity[] {
  const list: SkippedMessageKeyEntity[] = [];
  try {
    while (resultSet.goToNextRow()) {
      list.push(rowToEntity(resultSet));
    }
    return list;
  } catch (err) {
    throw new Error('SkippedMessageKeyDao resultSetToEntityList 遍历结果集失败: ' + JSON.stringify(err));
  } finally {
    resultSet.close();
  }
}

// ══════════════════════════════════════════════
//  SkippedMessageKeyDao  — 数据库访问对象
// ══════════════════════════════════════════════

export class SkippedMessageKeyDao {
  private readonly rdbStore: relationalStore.RdbStore;

  constructor(rdbStore: relationalStore.RdbStore) {
    this.rdbStore = rdbStore;
  }

  // ────────────────────────────────────────────
  //  Create  —  插入
  // ────────────────────────────────────────────

  /**
   * 插入一条跳过的消息密钥记录
   *
   * @param entity 跳过的消息密钥实体（id 可忽略，由数据库自增）
   * @returns 插入成功后自动生成的主键 id
   */
  async insert(entity: SkippedMessageKeyEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const rowId: number = await store.insert(TABLE_NAME, bucket);
      return rowId;
    } catch (err) {
      throw new Error('SkippedMessageKeyDao 插入记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 批量插入多条跳过的消息密钥记录（使用事务保证原子性）
   *
   * @param entities 跳过的消息密钥实体列表
   * @returns 插入成功的数量
   */
  async insertBatch(entities: SkippedMessageKeyEntity[]): Promise<number> {
    const store = this.rdbStore;
    let successCount = 0;
    try {
      store.beginTransaction();
      for (const entity of entities) {
        const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
        await store.insert(TABLE_NAME, bucket);
        successCount++;
      }
      store.commit();
    } catch (err) {
      try {
        store.rollBack();
      } catch (error) {
        ErrorUtil.logError(error);
      }
      throw new Error('SkippedMessageKeyDao 批量插入失败: ' + ErrorUtil.getErrorMessage(err));
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
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_ID, id);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'SkippedMessageKeyDao deleteById 删除记录失败 (id=' + id + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户 ID 删除所有跳过的消息密钥
   *
   * @param userId 用户 ID
   * @returns 受影响的行数
   */
  async deleteByUserId(userId: number): Promise<number> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'SkippedMessageKeyDao deleteByUserId 删除记录失败 (userId=' + userId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户对（userId + targetId）删除跳过的消息密钥
   *
   * @param userId   用户 ID
   * @param targetId 目标用户 ID
   * @returns 受影响的行数
   */
  async deleteUserPair(userId: number, targetId: number): Promise<number> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      predicates.equalTo(COL_TARGET_ID, targetId);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'SkippedMessageKeyDao deleteUserPair 删除记录失败 (userId=' + userId + ', targetId=' + targetId +
          '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 清空所有跳过的消息密钥记录
   *
   * @returns 受影响的行数
   */
  async deleteAll(): Promise<number> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error('SkippedMessageKeyDao deleteAll 清空记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  // ────────────────────────────────────────────
  //  Update  —  修改
  // ────────────────────────────────────────────

  /**
   * 根据主键 id 更新跳过的消息密钥记录
   *
   * @param entity 新的实体对象（必须包含有效的 id）
   * @returns 受影响的行数
   */
  async update(entity: SkippedMessageKeyEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_ID, entity.id);
      const rows: number = await store.update(bucket, predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'SkippedMessageKeyDao update 更新记录失败 (id=' + entity.id + '): ' + ErrorUtil.getErrorMessage(err));
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
  async getById(id: number): Promise<SkippedMessageKeyEntity | undefined> {
    try {
      const store = this.rdbStore;
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
      throw new Error(
        'SkippedMessageKeyDao getById 查询记录失败 (id=' + id + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户 ID 查询所有跳过的消息密钥
   *
   * @param userId 用户 ID
   * @returns 匹配的实体对象列表
   */
  async getByUserId(userId: number): Promise<SkippedMessageKeyEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'SkippedMessageKeyDao getByUserId 查询记录失败 (userId=' + userId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户对（userId + targetId）查询跳过的消息密钥
   *
   * @param userId   用户 ID
   * @param targetId 目标用户 ID
   * @returns 匹配的实体对象列表
   */
  async getByUserPair(userId: number, targetId: number): Promise<SkippedMessageKeyEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      predicates.equalTo(COL_TARGET_ID, targetId);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'SkippedMessageKeyDao getByUserPair 查询记录失败 (userId=' + userId + ', targetId=' + targetId +
          '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据 DH 公钥和链索引查询跳过的消息密钥
   *
   * @param dhPublicKey DH 公钥
   * @param chainIndex  链索引
   * @returns 匹配的实体对象列表
   */
  async getByDhPublicKeyAndChainIndex(dhPublicKey: string, chainIndex: number): Promise<SkippedMessageKeyEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_DH_PUBLIC_KEY, dhPublicKey);
      predicates.equalTo(COL_CHAIN_INDEX, chainIndex);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'SkippedMessageKeyDao getByDhPublicKeyAndChainIndex 查询记录失败 (dhPublicKey=' + dhPublicKey +
          ', chainIndex=' + chainIndex + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询所有跳过的消息密钥记录
   *
   * @returns 全部实体对象列表
   */
  async getAll(): Promise<SkippedMessageKeyEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error('SkippedMessageKeyDao getAll 查询全部记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 执行自定义 SQL 查询（返回实体列表）
   *
   * @param sql    SQL 查询语句
   * @param params 绑定参数
   * @returns 实体对象列表
   */
  async getBySql(sql: string, params: relationalStore.ValueType[]): Promise<SkippedMessageKeyEntity[]> {
    try {
      const store = this.rdbStore;
      const resultSet: relationalStore.ResultSet = await store.querySql(sql, params);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'SkippedMessageKeyDao getBySql 执行SQL查询失败 (sql=' + sql + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }
}
