import { relationalStore } from '@kit.ArkData';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { SessionRecordEntity } from '../tables/SessionRecordEntity';

/**
 * 数据库表名
 */
const TABLE_NAME: string = 'session_record';

/**
 * 列名常量
 */
const COL_ID: string = 'id';
const COL_LOCAL_USER_ID: string = 'local_user_id';
const COL_REMOTE_USER_ID: string = 'remote_user_id';
const COL_REMOTE_IDENTITY_KEY: string = 'remote_identity_key';
const COL_REMOTE_DH_KEY: string = 'remote_dh_key';
const COL_LOCAL_EPHEMERAL_PRIVATE_KEY: string = 'local_ephemeral_private_key';
const COL_LOCAL_EPHEMERAL_PUBLIC_KEY: string = 'local_ephemeral_public_key';
const COL_ROOT_KEY: string = 'root_key';
const COL_SENDING_CHAIN_KEY: string = 'sending_chain_key';
const COL_RECEIVING_CHAIN_KEY: string = 'receiving_chain_key';
const COL_RECEIVING_CHAIN_INDEX: string = 'receiving_chain_index';
const COL_N: string = 'n';
const COL_PN: string = 'pn';
const COL_CREATED_TIME: string = 'created_time';
const COL_UPDATED_TIME: string = 'updated_time';

/**
 * 查询所需的所有列（按顺序）
 */
const ALL_COLUMNS: string[] = [
  COL_ID, COL_LOCAL_USER_ID, COL_REMOTE_USER_ID,
  COL_REMOTE_IDENTITY_KEY, COL_REMOTE_DH_KEY,
  COL_LOCAL_EPHEMERAL_PRIVATE_KEY, COL_LOCAL_EPHEMERAL_PUBLIC_KEY,
  COL_ROOT_KEY, COL_SENDING_CHAIN_KEY, COL_RECEIVING_CHAIN_KEY,
  COL_RECEIVING_CHAIN_INDEX, COL_N, COL_PN, COL_CREATED_TIME, COL_UPDATED_TIME,
];

// ══════════════════════════════════════════════
//  内部工具函数
// ══════════════════════════════════════════════

/**
 * 将 ResultSet 的当前行转换为 SessionRecordEntity 对象
 *
 * @param rs  ResultSet 实例（调用前须已定位到有效行）
 * @returns   转换后的实体对象
 */
function rowToEntity(rs: relationalStore.ResultSet): SessionRecordEntity {
  try {
    return new SessionRecordEntity(
      rs.getLong(rs.getColumnIndex(COL_ID)),
      rs.getLong(rs.getColumnIndex(COL_LOCAL_USER_ID)),
      rs.getLong(rs.getColumnIndex(COL_REMOTE_USER_ID)),
      rs.getString(rs.getColumnIndex(COL_REMOTE_IDENTITY_KEY)),
      rs.getString(rs.getColumnIndex(COL_REMOTE_DH_KEY)),
      rs.getString(rs.getColumnIndex(COL_LOCAL_EPHEMERAL_PRIVATE_KEY)),
      rs.getString(rs.getColumnIndex(COL_LOCAL_EPHEMERAL_PUBLIC_KEY)),
      rs.getString(rs.getColumnIndex(COL_ROOT_KEY)),
      rs.getString(rs.getColumnIndex(COL_SENDING_CHAIN_KEY)),
      rs.getString(rs.getColumnIndex(COL_RECEIVING_CHAIN_KEY)),
      rs.getLong(rs.getColumnIndex(COL_RECEIVING_CHAIN_INDEX)),
      rs.getLong(rs.getColumnIndex(COL_N)),
      rs.getLong(rs.getColumnIndex(COL_PN)),
      rs.getString(rs.getColumnIndex(COL_CREATED_TIME)),
      rs.getString(rs.getColumnIndex(COL_UPDATED_TIME)),
    );
  } catch (error) {
    throw new Error('SessionRecordDao rowToEntity 转换失败: ' + JSON.stringify(error));
  }
}

/**
 * 将 SessionRecordEntity 转换为 ValuesBucket（用于 insert / update）
 *
 * @param entity     实体对象
 * @param includeId  是否包含 id 字段（update 时通常不需要）
 * @returns          ValuesBucket
 */
function entityToBucket(entity: SessionRecordEntity, includeId: boolean = false): relationalStore.ValuesBucket {
  try {
    const bucket: relationalStore.ValuesBucket = {
      'local_user_id': entity.localUserId,
      'remote_user_id': entity.remoteUserId,
      'remote_identity_key': entity.remoteIdentityKey,
      'remote_dh_key': entity.remoteDHKey,
      'local_ephemeral_private_key': entity.localEphemeralPrivateKey,
      'local_ephemeral_public_key': entity.localEphemeralPublicKey,
      'root_key': entity.rootKey,
      'sending_chain_key': entity.sendingChainKey,
      'receiving_chain_key': entity.receivingChainKey,
      'receiving_chain_index': entity.receivingChainIndex,
      'n': entity.N,
      'pn': entity.PN,
      'created_time': entity.createdTime,
      'updated_time': entity.updatedTime,
    };
    if (includeId) {
      bucket['id'] = entity.id;
    }
    return bucket;
  } catch (err) {
    throw new Error('SessionRecordDao entityToBucket 转换失败: ' + JSON.stringify(err));
  }
}

/**
 * 遍历整个 ResultSet 并转换为实体列表（调用后自动关闭结果集）
 *
 * @param resultSet  结果集
 * @returns          实体列表
 */
function resultSetToEntityList(resultSet: relationalStore.ResultSet): SessionRecordEntity[] {
  const list: SessionRecordEntity[] = [];
  try {
    while (resultSet.goToNextRow()) {
      list.push(rowToEntity(resultSet));
    }
    return list;
  } catch (err) {
    throw new Error('SessionRecordDao resultSetToEntityList 遍历结果集失败: ' + JSON.stringify(err));
  } finally {
    resultSet.close();
  }
}

// ══════════════════════════════════════════════
//  SessionRecordDao  — 数据库访问对象
// ══════════════════════════════════════════════

export class SessionRecordDao {
  private readonly rdbStore: relationalStore.RdbStore;

  constructor(rdbStore: relationalStore.RdbStore) {
    this.rdbStore = rdbStore;
  }

  // ────────────────────────────────────────────
  //  Create  —  插入
  // ────────────────────────────────────────────

  /**
   * 插入一条会话记录
   *
   * @param entity 会话记录实体（id 可忽略，由数据库自增）
   * @returns 插入成功后自动生成的主键 id
   */
  async insert(entity: SessionRecordEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const rowId: number = await store.insert(TABLE_NAME, bucket);
      return rowId;
    } catch (err) {
      throw new Error('SessionRecordDao 插入记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 批量插入多条会话记录（使用事务保证原子性）
   *
   * @param entities 会话记录实体列表
   * @returns 插入成功的数量
   */
  async insertBatch(entities: SessionRecordEntity[]): Promise<number> {
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
      throw new Error('SessionRecordDao 批量插入失败: ' + ErrorUtil.getErrorMessage(err));
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
      throw new Error('SessionRecordDao deleteById 删除记录失败 (id=' + id + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户对（localUserId + remoteUserId）删除会话记录
   *
   * @param localUserId  本地用户 ID
   * @param remoteUserId 远程用户 ID
   * @returns 受影响的行数
   */
  async deleteUserPair(localUserId: number, remoteUserId: number): Promise<number> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_LOCAL_USER_ID, localUserId);
      predicates.equalTo(COL_REMOTE_USER_ID, remoteUserId);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'SessionRecordDao deleteUserPair 删除记录失败 (localUserId=' + localUserId + ', remoteUserId=' +
          remoteUserId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 删除指定用户的所有会话记录
   *
   * @param userId 用户 ID（作为本地用户或远程用户）
   * @returns 受影响的行数
   */
  async deleteByUserId(userId: number): Promise<number> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.beginWrap();
      predicates.equalTo(COL_LOCAL_USER_ID, userId);
      predicates.or();
      predicates.equalTo(COL_REMOTE_USER_ID, userId);
      predicates.endWrap();
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'SessionRecordDao deleteByUserId 删除记录失败 (userId=' + userId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 清空所有会话记录
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
      throw new Error('SessionRecordDao deleteAll 清空记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  // ────────────────────────────────────────────
  //  Update  —  修改
  // ────────────────────────────────────────────

  /**
   * 根据主键 id 更新会话记录
   *
   * @param entity 新的实体对象（必须包含有效的 id）
   * @returns 受影响的行数
   */
  async update(entity: SessionRecordEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_ID, entity.id);
      const rows: number = await store.update(bucket, predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'SessionRecordDao update 更新记录失败 (id=' + entity.id + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户对更新会话记录
   *
   * @param localUserId  本地用户 ID
   * @param remoteUserId 远程用户 ID
   * @param entity       新的实体数据
   * @returns 受影响的行数
   */
  async updateByUserPair(localUserId: number, remoteUserId: number, entity: SessionRecordEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_LOCAL_USER_ID, localUserId);
      predicates.equalTo(COL_REMOTE_USER_ID, remoteUserId);
      const rows: number = await store.update(bucket, predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'SessionRecordDao updateByUserPair 更新记录失败 (localUserId=' + localUserId + ', remoteUserId=' +
          remoteUserId + '): ' + ErrorUtil.getErrorMessage(err));
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
  async getById(id: number): Promise<SessionRecordEntity | undefined> {
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
        'SessionRecordDao getById 查询记录失败 (id=' + id + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户对（localUserId + remoteUserId）查询会话记录
   *
   * @param localUserId  本地用户 ID
   * @param remoteUserId 远程用户 ID
   * @returns 匹配的实体对象，未找到时返回 undefined
   */
  async getByUserPair(localUserId: number, remoteUserId: number): Promise<SessionRecordEntity | undefined> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_LOCAL_USER_ID, localUserId);
      predicates.equalTo(COL_REMOTE_USER_ID, remoteUserId);
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
        'SessionRecordDao getByUserPair 查询记录失败 (localUserId=' + localUserId + ', remoteUserId=' +
          remoteUserId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询指定用户的所有会话记录（作为本地用户或远程用户）
   *
   * @param userId 用户 ID
   * @returns 匹配的实体对象列表
   */
  async getByUserId(userId: number): Promise<SessionRecordEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.beginWrap();
      predicates.equalTo(COL_LOCAL_USER_ID, userId);
      predicates.or();
      predicates.equalTo(COL_REMOTE_USER_ID, userId);
      predicates.endWrap();
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'SessionRecordDao getByUserId 查询记录失败 (userId=' + userId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询所有会话记录
   *
   * @returns 全部实体对象列表
   */
  async getAll(): Promise<SessionRecordEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error('SessionRecordDao getAll 查询全部记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 执行自定义 SQL 查询（返回实体列表）
   *
   * @param sql    SQL 查询语句
   * @param params 绑定参数
   * @returns 实体对象列表
   */
  async getBySql(sql: string, params: relationalStore.ValueType[]): Promise<SessionRecordEntity[]> {
    try {
      const store = this.rdbStore;
      const resultSet: relationalStore.ResultSet = await store.querySql(sql, params);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'SessionRecordDao getBySql 执行SQL查询失败 (sql=' + sql + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }
}
