import { relationalStore } from '@kit.ArkData';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { MessageReadStatusEntity } from '../tables/MessageReadStatusEntity';

/**
 * 数据库表名
 */
const TABLE_NAME: string = 'message_read_status';

/**
 * 列名常量
 */
const COL_ID: string = 'id';
const COL_MSG_ID: string = 'msg_id';
const COL_USER_ID: string = 'user_id';
const COL_TARGET_ID: string = 'target_id';
const COL_IS_READ: string = 'is_read';
const COL_MESSAGE_TYPE: string = 'message_type';
const COL_READ_TIME: string = 'read_time';
const COL_CREATED_TIME: string = 'created_time';
const COL_UPDATED_TIME: string = 'updated_time';

/**
 * 查询所需的所有列（按顺序）
 */
const ALL_COLUMNS: string[] = [
  COL_ID, COL_MSG_ID, COL_USER_ID, COL_TARGET_ID,
  COL_IS_READ, COL_MESSAGE_TYPE, COL_READ_TIME, COL_CREATED_TIME, COL_UPDATED_TIME,
];

// ══════════════════════════════════════════════
//  内部工具函数
// ══════════════════════════════════════════════

/**
 * 将 ResultSet 的当前行转换为 MessageReadStatusEntity 对象
 *
 * @param rs  ResultSet 实例（调用前须已定位到有效行）
 * @returns   转换后的实体对象
 */
function rowToEntity(rs: relationalStore.ResultSet): MessageReadStatusEntity {
  try {
    return new MessageReadStatusEntity(
      rs.getLong(rs.getColumnIndex(COL_ID)),
      rs.getString(rs.getColumnIndex(COL_MSG_ID)),
      rs.getLong(rs.getColumnIndex(COL_USER_ID)),
      rs.getLong(rs.getColumnIndex(COL_TARGET_ID)),
      rs.getLong(rs.getColumnIndex(COL_IS_READ)) === 1,
      rs.getLong(rs.getColumnIndex(COL_MESSAGE_TYPE)),
      rs.getString(rs.getColumnIndex(COL_READ_TIME)),
      rs.getString(rs.getColumnIndex(COL_CREATED_TIME)),
      rs.getString(rs.getColumnIndex(COL_UPDATED_TIME)),
    );
  } catch (error) {
    throw new Error('MessageReadStatusDao rowToEntity 转换失败: ' + JSON.stringify(error));
  }
}

/**
 * 将 MessageReadStatusEntity 转换为 ValuesBucket（用于 insert / update）
 *
 * @param entity     实体对象
 * @param includeId  是否包含 id 字段（update 时通常不需要）
 * @returns          ValuesBucket
 */
function entityToBucket(entity: MessageReadStatusEntity, includeId: boolean = false): relationalStore.ValuesBucket {
  try {
    const bucket: relationalStore.ValuesBucket = {
      'msg_id': entity.msgId,
      'user_id': entity.userId,
      'target_id': entity.targetId,
      'is_read': entity.isRead ? 1 : 0,
      'message_type': entity.messageType,
      'read_time': entity.readTime,
      'created_time': entity.createdTime,
      'updated_time': entity.updatedTime,
    };
    if (includeId) {
      bucket['id'] = entity.id;
    }
    return bucket;
  } catch (err) {
    throw new Error('MessageReadStatusDao entityToBucket 转换失败: ' + JSON.stringify(err));
  }
}

/**
 * 遍历整个 ResultSet 并转换为实体列表（调用后自动关闭结果集）
 *
 * @param resultSet  结果集
 * @returns          实体列表
 */
function resultSetToEntityList(resultSet: relationalStore.ResultSet): MessageReadStatusEntity[] {
  const list: MessageReadStatusEntity[] = [];
  try {
    while (resultSet.goToNextRow()) {
      list.push(rowToEntity(resultSet));
    }
    return list;
  } catch (err) {
    throw new Error('MessageReadStatusDao resultSetToEntityList 遍历结果集失败: ' + JSON.stringify(err));
  } finally {
    resultSet.close();
  }
}

// ══════════════════════════════════════════════
//  MessageReadStatusDao  — 数据库访问对象
// ══════════════════════════════════════════════

export class MessageReadStatusDao {
  private readonly rdbStore: relationalStore.RdbStore;

  constructor(rdbStore: relationalStore.RdbStore) {
    this.rdbStore = rdbStore;
  }

  // ────────────────────────────────────────────
  //  Create  —  插入
  // ────────────────────────────────────────────

  /**
   * 插入一条消息已读状态记录
   *
   * @param entity 消息已读状态实体（id 可忽略，由数据库自增）
   * @returns 插入成功后自动生成的主键 id
   */
  async insert(entity: MessageReadStatusEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const rowId: number = await store.insert(TABLE_NAME, bucket);
      return rowId;
    } catch (err) {
      throw new Error(
        'MessageReadStatusDao 插入记录失败 (msgId=' + entity.msgId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 批量插入多条消息已读状态记录（使用事务保证原子性）
   *
   * @param entities 消息已读状态实体列表
   * @returns 插入成功的数量
   */
  async insertBatch(entities: MessageReadStatusEntity[]): Promise<number> {
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
      throw new Error('MessageReadStatusDao 批量插入失败: ' + ErrorUtil.getErrorMessage(err));
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
      throw new Error('MessageReadStatusDao deleteById 删除记录失败 (id=' + id + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据消息 ID 删除已读状态
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
        'MessageReadStatusDao deleteByMsgId 删除记录失败 (msgId=' + msgId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户 ID 删除所有已读状态
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
        'MessageReadStatusDao deleteByUserId 删除记录失败 (userId=' + userId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 清空所有消息已读状态记录
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
      throw new Error('MessageReadStatusDao deleteAll 清空记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  // ────────────────────────────────────────────
  //  Update  —  修改
  // ────────────────────────────────────────────

  /**
   * 根据主键 id 更新消息已读状态
   *
   * @param entity 新的实体对象（必须包含有效的 id）
   * @returns 受影响的行数
   */
  async update(entity: MessageReadStatusEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_ID, entity.id);
      const rows: number = await store.update(bucket, predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'MessageReadStatusDao update 更新记录失败 (id=' + entity.id + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 标记指定消息为已读
   *
   * @param msgId    消息 ID
   * @param userId   用户 ID
   * @param readTime 已读时间
   * @returns 受影响的行数
   */
  async markAsRead(msgId: string, userId: number, readTime: string): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = {
        'is_read': 1,
        'read_time': readTime,
        'updated_time': readTime,
      };
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_MSG_ID, msgId);
      predicates.equalTo(COL_USER_ID, userId);
      const rows: number = await store.update(bucket, predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'MessageReadStatusDao markAsRead 标记已读失败 (msgId=' + msgId + '): ' + ErrorUtil.getErrorMessage(err));
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
  async getById(id: number): Promise<MessageReadStatusEntity | undefined> {
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
        'MessageReadStatusDao getById 查询记录失败 (id=' + id + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据消息 ID 查询已读状态
   *
   * @param msgId 消息 ID
   * @returns 匹配的实体对象列表
   */
  async getByMsgId(msgId: string): Promise<MessageReadStatusEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_MSG_ID, msgId);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'MessageReadStatusDao getByMsgId 查询记录失败 (msgId=' + msgId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户 ID 查询所有已读状态
   *
   * @param userId 用户 ID
   * @returns 匹配的实体对象列表
   */
  async getByUserId(userId: number): Promise<MessageReadStatusEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'MessageReadStatusDao getByUserId 查询记录失败 (userId=' + userId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询指定用户与目标用户之间的所有已读状态
   *
   * @param userId   用户 ID
   * @param targetId 目标用户 ID
   * @returns 匹配的实体对象列表
   */
  async getByUserPair(userId: number, targetId: number): Promise<MessageReadStatusEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      predicates.equalTo(COL_TARGET_ID, targetId);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'MessageReadStatusDao getByUserPair 查询记录失败 (userId=' + userId + ', targetId=' + targetId +
          '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询所有未读消息状态
   *
   * @param userId 用户 ID
   * @returns 未读消息的实体对象列表
   */
  async getUnreadByUserId(userId: number): Promise<MessageReadStatusEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID, userId);
      predicates.equalTo(COL_IS_READ, 0);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'MessageReadStatusDao getUnreadByUserId 查询未读消息失败 (userId=' + userId + '): ' +
          ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询所有消息已读状态记录
   *
   * @returns 全部实体对象列表
   */
  async getAll(): Promise<MessageReadStatusEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error('MessageReadStatusDao getAll 查询全部记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 执行自定义 SQL 查询（返回实体列表）
   *
   * @param sql    SQL 查询语句
   * @param params 绑定参数
   * @returns 实体对象列表
   */
  async getBySql(sql: string, params: relationalStore.ValueType[]): Promise<MessageReadStatusEntity[]> {
    try {
      const store = this.rdbStore;
      const resultSet: relationalStore.ResultSet = await store.querySql(sql, params);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'MessageReadStatusDao getBySql 执行SQL查询失败 (sql=' + sql + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }
}
