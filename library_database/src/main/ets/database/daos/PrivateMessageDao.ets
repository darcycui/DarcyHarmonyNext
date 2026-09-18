import { relationalStore } from '@kit.ArkData';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { PrivateMessageEntity } from '../tables/PrivateMessageEntity';

/**
 * 数据库表名
 */
const TABLE_NAME: string = 'private_message';

/**
 * 列名常量
 */
const COL_ID: string = 'id';
const COL_MSG_ID: string = 'msg_id';
const COL_USER_ID: string = 'user_id';
const COL_TARGET_ID: string = 'target_id';
const COL_CONTENT: string = 'content';
const COL_MESSAGE_TYPE: string = 'message_type';
const COL_CREATED_TIME: string = 'created_time';
const COL_UPDATED_TIME: string = 'updated_time';
const COL_DH_PUBLIC_KEY: string = 'dh_public_key';
const COL_N_KEY: string = 'n_key';
const COL_PN_KEY: string = 'pn_key';

/**
 * 查询所需的所有列（按顺序）
 */
const ALL_COLUMNS: string[] = [
  COL_ID, COL_MSG_ID, COL_USER_ID, COL_TARGET_ID, COL_CONTENT,
  COL_MESSAGE_TYPE, COL_CREATED_TIME, COL_UPDATED_TIME,
  COL_DH_PUBLIC_KEY, COL_N_KEY, COL_PN_KEY,
];

// ══════════════════════════════════════════════
//  内部工具函数
// ══════════════════════════════════════════════

/**
 * 将 ResultSet 的当前行转换为 PrivateMessageEntity 对象
 *
 * @param rs  ResultSet 实例（调用前须已定位到有效行）
 * @returns   转换后的实体对象
 */
function rowToEntity(rs: relationalStore.ResultSet): PrivateMessageEntity {
  try {
    return new PrivateMessageEntity(
      rs.getLong(rs.getColumnIndex(COL_ID)),
      rs.getString(rs.getColumnIndex(COL_MSG_ID)),
      rs.getLong(rs.getColumnIndex(COL_USER_ID)),
      rs.getLong(rs.getColumnIndex(COL_TARGET_ID)),
      rs.getString(rs.getColumnIndex(COL_CONTENT)),
      rs.getLong(rs.getColumnIndex(COL_MESSAGE_TYPE)),
      rs.getString(rs.getColumnIndex(COL_CREATED_TIME)),
      rs.getString(rs.getColumnIndex(COL_UPDATED_TIME)),
      rs.getString(rs.getColumnIndex(COL_DH_PUBLIC_KEY)),
      rs.getLong(rs.getColumnIndex(COL_N_KEY)),
      rs.getLong(rs.getColumnIndex(COL_PN_KEY)),
    );
  } catch (error) {
    throw new Error('PrivateMessageDao rowToEntity 转换失败: ' + JSON.stringify(error));
  }
}

/**
 * 将 PrivateMessageEntity 转换为 ValuesBucket（用于 insert / update）
 *
 * @param entity     实体对象
 * @param includeId  是否包含 id 字段（update 时通常不需要）
 * @returns          ValuesBucket
 */
function entityToBucket(entity: PrivateMessageEntity, includeId: boolean = false): relationalStore.ValuesBucket {
  try {
    const bucket: relationalStore.ValuesBucket = {
      'msg_id': entity.msgId,
      'user_id': entity.userId,
      'target_id': entity.targetId,
      'content': entity.content,
      'message_type': entity.messageType,
      'created_time': entity.createdTime,
      'updated_time': entity.updatedTime,
      'dh_public_key': entity.dhPublicKey,
      'n_key': entity.nKey,
      'pn_key': entity.pnKey,
    };
    if (includeId) {
      bucket['id'] = entity.id;
    }
    return bucket;
  } catch (err) {
    throw new Error('PrivateMessageDao entityToBucket 转换失败: ' + JSON.stringify(err));
  }
}

/**
 * 遍历整个 ResultSet 并转换为实体列表（调用后自动关闭结果集）
 *
 * @param resultSet  结果集
 * @returns          实体列表
 */
function resultSetToEntityList(resultSet: relationalStore.ResultSet): PrivateMessageEntity[] {
  const list: PrivateMessageEntity[] = [];
  try {
    while (resultSet.goToNextRow()) {
      list.push(rowToEntity(resultSet));
    }
    return list;
  } catch (err) {
    throw new Error('PrivateMessageDao resultSetToEntityList 遍历结果集失败: ' + JSON.stringify(err));
  } finally {
    resultSet.close();
  }
}

// ══════════════════════════════════════════════
//  PrivateMessageDao  — 数据库访问对象
// ══════════════════════════════════════════════

export class PrivateMessageDao {
  private readonly rdbStore: relationalStore.RdbStore;

  constructor(rdbStore: relationalStore.RdbStore) {
    this.rdbStore = rdbStore;
  }

  // ────────────────────────────────────────────
  //  Create  —  插入
  // ────────────────────────────────────────────

  /**
   * 插入一条私密消息记录
   *
   * @param entity 私密消息实体（id 可忽略，由数据库自增）
   * @returns 插入成功后自动生成的主键 id
   */
  async insert(entity: PrivateMessageEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const rowId: number = await store.insert(TABLE_NAME, bucket);
      return rowId;
    } catch (err) {
      throw new Error(
        'PrivateMessageDao 插入记录失败 (msgId=' + entity.msgId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 批量插入多条私密消息记录（使用事务保证原子性）
   *
   * @param entities 私密消息实体列表
   * @returns 插入成功的数量
   */
  async insertBatch(entities: PrivateMessageEntity[]): Promise<number> {
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
      throw new Error('PrivateMessageDao 批量插入失败: ' + ErrorUtil.getErrorMessage(err));
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
      throw new Error('PrivateMessageDao deleteById 删除记录失败 (id=' + id + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据消息 ID 删除记录
   *
   * @param msgId 消息 ID
   * @returns 受影响的行数
   */
  async deleteByMsgId(msgId: string): Promise<number> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_MSG_ID, msgId);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'PrivateMessageDao deleteByMsgId 删除记录失败 (msgId=' + msgId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 删除指定用户的所有私密消息
   *
   * @param userId 用户 ID（作为发送方或接收方）
   * @returns 受影响的行数
   */
  async deleteByUserId(userId: number): Promise<number> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.beginWrap();
      predicates.equalTo(COL_USER_ID, userId);
      predicates.or();
      predicates.equalTo(COL_TARGET_ID, userId);
      predicates.endWrap();
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'PrivateMessageDao deleteByUserId 删除记录失败 (userId=' + userId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 清空所有私密消息记录
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
      throw new Error('PrivateMessageDao deleteAll 清空记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  // ────────────────────────────────────────────
  //  Update  —  修改
  // ────────────────────────────────────────────

  /**
   * 根据主键 id 更新私密消息记录
   *
   * @param entity 新的实体对象（必须包含有效的 id）
   * @returns 受影响的行数
   */
  async update(entity: PrivateMessageEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_ID, entity.id);
      const rows: number = await store.update(bucket, predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'PrivateMessageDao update 更新记录失败 (id=' + entity.id + '): ' + ErrorUtil.getErrorMessage(err));
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
  async getById(id: number): Promise<PrivateMessageEntity | undefined> {
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
        'PrivateMessageDao getById 查询记录失败 (id=' + id + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据消息 ID 查询单条记录
   *
   * @param msgId 消息 ID
   * @returns 匹配的实体对象，未找到时返回 undefined
   */
  async getByMsgId(msgId: string): Promise<PrivateMessageEntity | undefined> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_MSG_ID, msgId);
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
        'PrivateMessageDao getByMsgId 查询记录失败 (msgId=' + msgId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询用户之间的所有私密消息（按创建时间升序排列）
   *
   * @param userId   发送方用户 ID
   * @param targetId 接收方用户 ID
   * @returns 匹配的实体对象列表
   */
  async getByUserPair(userId: number, targetId: number): Promise<PrivateMessageEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      predicates.equalTo(COL_TARGET_ID, targetId);
      predicates.orderByAsc(COL_CREATED_TIME);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'PrivateMessageDao getByUserPair 查询记录失败 (userId=' + userId + ', targetId=' + targetId +
          '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询指定用户的所有私密消息（作为发送方或接收方）
   *
   * @param userId 用户 ID
   * @returns 匹配的实体对象列表
   */
  async getByUserId(userId: number): Promise<PrivateMessageEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.beginWrap();
      predicates.equalTo(COL_USER_ID, userId);
      predicates.or();
      predicates.equalTo(COL_TARGET_ID, userId);
      predicates.endWrap();
      predicates.orderByDesc(COL_CREATED_TIME);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'PrivateMessageDao getByUserId 查询记录失败 (userId=' + userId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 分页查询用户之间的私密消息
   *
   * @param userId   发送方用户 ID
   * @param targetId 接收方用户 ID
   * @param offset   偏移量
   * @param limit    每页数量
   * @returns 匹配的实体对象列表
   */
  async getByUserPairPaged(userId: number, targetId: number, offset: number, limit: number): Promise<PrivateMessageEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      predicates.equalTo(COL_TARGET_ID, targetId);
      predicates.orderByDesc(COL_CREATED_TIME);
      predicates.offsetAs(offset);
      predicates.limitAs(limit);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'PrivateMessageDao getByUserPairPaged 分页查询失败 (userId=' + userId + ', targetId=' + targetId +
          '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询所有私密消息记录
   *
   * @returns 全部实体对象列表
   */
  async getAll(): Promise<PrivateMessageEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error('PrivateMessageDao getAll 查询全部记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 执行自定义 SQL 查询（返回实体列表）
   *
   * @param sql    SQL 查询语句
   * @param params 绑定参数
   * @returns 实体对象列表
   */
  async getBySql(sql: string, params: relationalStore.ValueType[]): Promise<PrivateMessageEntity[]> {
    try {
      const store = this.rdbStore;
      const resultSet: relationalStore.ResultSet = await store.querySql(sql, params);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'PrivateMessageDao getBySql 执行SQL查询失败 (sql=' + sql + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }
}
