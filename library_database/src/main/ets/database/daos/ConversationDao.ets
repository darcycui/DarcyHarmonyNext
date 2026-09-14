import { relationalStore } from '@kit.ArkData';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { ConversationEntity } from '../tables/ConversationEntity';

/**
 * 数据库表名
 */
const TABLE_NAME: string = 'conversation';

/**
 * 列名常量
 */
const COL_CONVERSATION_ID: string = 'conversation_id';
const COL_USER_ID_FROM: string = 'user_id_from';
const COL_USER_ID_TO: string = 'user_id_to';
const COL_TYPE: string = 'type';
const COL_NAME: string = 'name';
const COL_CREATED_TIME: string = 'created_time';
const COL_UPDATED_TIME: string = 'updated_time';
const COL_DELETED_TIME: string = 'deleted_time';

/**
 * 查询所需的所有列（按顺序）
 */
const ALL_COLUMNS: string[] = [
  COL_CONVERSATION_ID, COL_USER_ID_FROM, COL_USER_ID_TO,
  COL_TYPE, COL_NAME, COL_CREATED_TIME, COL_UPDATED_TIME, COL_DELETED_TIME,
];

// ══════════════════════════════════════════════
//  内部工具函数
// ══════════════════════════════════════════════

/**
 * 将 ResultSet 的当前行转换为 ConversationEntity 对象
 *
 * @param rs  ResultSet 实例（调用前须已定位到有效行）
 * @returns   转换后的实体对象
 */
function rowToEntity(rs: relationalStore.ResultSet): ConversationEntity {
  try {
    return new ConversationEntity(
      rs.getLong(rs.getColumnIndex(COL_CONVERSATION_ID)),
      rs.getLong(rs.getColumnIndex(COL_USER_ID_FROM)),
      rs.getLong(rs.getColumnIndex(COL_USER_ID_TO)),
      rs.getLong(rs.getColumnIndex(COL_TYPE)),
      rs.getString(rs.getColumnIndex(COL_NAME)),
      rs.getLong(rs.getColumnIndex(COL_CREATED_TIME)),
      rs.getLong(rs.getColumnIndex(COL_UPDATED_TIME)),
      rs.getLong(rs.getColumnIndex(COL_DELETED_TIME)),
    );
  } catch (error) {
    throw new Error('ConversationDao rowToEntity 转换失败: ' + JSON.stringify(error));
  }
}

/**
 * 将 ConversationEntity 转换为 ValuesBucket（用于 insert / update）
 *
 * @param entity     实体对象
 * @param includeId  是否包含 id 字段（update 时通常不需要）
 * @returns          ValuesBucket
 */
function entityToBucket(entity: ConversationEntity, includeId: boolean = false): relationalStore.ValuesBucket {
  try {
    const bucket: relationalStore.ValuesBucket = {
      'user_id_from': entity.userIdFrom,
      'user_id_to': entity.userIdTo,
      'type': entity.type,
      'name': entity.name,
      'created_time': entity.createdTime,
      'updated_time': entity.updatedTime,
      'deleted_time': entity.deletedTime,
    };
    if (includeId) {
      bucket['conversation_id'] = entity.conversationId;
    }
    return bucket;
  } catch (err) {
    throw new Error('ConversationDao entityToBucket 转换失败: ' + JSON.stringify(err));
  }
}

/**
 * 遍历整个 ResultSet 并转换为实体列表（调用后自动关闭结果集）
 *
 * @param resultSet  结果集
 * @returns          实体列表
 */
function resultSetToEntityList(resultSet: relationalStore.ResultSet): ConversationEntity[] {
  const list: ConversationEntity[] = [];
  try {
    while (resultSet.goToNextRow()) {
      list.push(rowToEntity(resultSet));
    }
    return list;
  } catch (err) {
    throw new Error('ConversationDao resultSetToEntityList 遍历结果集失败: ' + JSON.stringify(err));
  } finally {
    resultSet.close();
  }
}

// ══════════════════════════════════════════════
//  ConversationDao  — 数据库访问对象
// ══════════════════════════════════════════════

export class ConversationDao {
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
   * @param entity 会话实体（conversationId 可忽略，由数据库自增）
   * @returns 插入成功后自动生成的主键 id
   */
  async insert(entity: ConversationEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const rowId: number = await store.insert(TABLE_NAME, bucket);
      return rowId;
    } catch (err) {
      throw new Error('ConversationDao 插入记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 批量插入多条会话记录（使用事务保证原子性）
   *
   * @param entities 会话实体列表
   * @returns 插入成功的数量
   */
  async insertBatch(entities: ConversationEntity[]): Promise<number> {
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
      throw new Error('ConversationDao 批量插入失败: ' + ErrorUtil.getErrorMessage(err));
    }
    return successCount;
  }

  // ────────────────────────────────────────────
  //  Delete  —  删除
  // ────────────────────────────────────────────

  /**
   * 根据主键 conversationId 删除记录
   *
   * @param conversationId 主键 id
   * @returns 受影响的行数
   */
  async deleteById(conversationId: number): Promise<number> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_CONVERSATION_ID, conversationId);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'ConversationDao deleteById 删除记录失败 (conversationId=' + conversationId + '): ' +
          ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户对（userIdFrom + userIdTo）删除会话
   *
   * @param userIdFrom 发起方用户 ID
   * @param userIdTo   接收方用户 ID
   * @returns 受影响的行数
   */
  async deleteByUserPair(userIdFrom: number, userIdTo: number): Promise<number> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID_FROM, userIdFrom);
      predicates.equalTo(COL_USER_ID_TO, userIdTo);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'ConversationDao deleteByUserPair 删除记录失败 (userIdFrom=' + userIdFrom + ', userIdTo=' + userIdTo +
          '): ' + ErrorUtil.getErrorMessage(err));
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
      throw new Error('ConversationDao deleteAll 清空记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  // ────────────────────────────────────────────
  //  Update  —  修改
  // ────────────────────────────────────────────

  /**
   * 根据主键 conversationId 更新会话记录
   *
   * @param entity 新的实体对象（必须包含有效的 conversationId）
   * @returns 受影响的行数
   */
  async update(entity: ConversationEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_CONVERSATION_ID, entity.conversationId);
      const rows: number = await store.update(bucket, predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'ConversationDao update 更新记录失败 (conversationId=' + entity.conversationId + '): ' +
          ErrorUtil.getErrorMessage(err));
    }
  }

  // ────────────────────────────────────────────
  //  Query  —  查询
  // ────────────────────────────────────────────

  /**
   * 根据主键 conversationId 查询单条记录
   *
   * @param conversationId 主键 id
   * @returns 匹配的实体对象，未找到时返回 undefined
   */
  async getById(conversationId: number): Promise<ConversationEntity | undefined> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_CONVERSATION_ID, conversationId);
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
        'ConversationDao getById 查询记录失败 (conversationId=' + conversationId + '): ' +
          ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户对（userIdFrom + userIdTo）查询会话
   *
   * @param userIdFrom 发起方用户 ID
   * @param userIdTo   接收方用户 ID
   * @returns 匹配的实体对象，未找到时返回 undefined
   */
  async getByUserPair(userIdFrom: number, userIdTo: number): Promise<ConversationEntity | undefined> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_USER_ID_FROM, userIdFrom);
      predicates.equalTo(COL_USER_ID_TO, userIdTo);
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
        'ConversationDao getByUserPair 查询记录失败 (userIdFrom=' + userIdFrom + ', userIdTo=' + userIdTo +
          '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询指定用户参与的所有会话（作为发起方或接收方）
   *
   * @param userId 用户 ID
   * @returns 匹配的实体对象列表
   */
  async getByUserId(userId: number): Promise<ConversationEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.beginWrap();
      predicates.equalTo(COL_USER_ID_FROM, userId);
      predicates.or();
      predicates.equalTo(COL_USER_ID_TO, userId);
      predicates.endWrap();
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'ConversationDao getByUserId 查询记录失败 (userId=' + userId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询所有会话记录
   *
   * @returns 全部实体对象列表
   */
  async getAll(): Promise<ConversationEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error('ConversationDao getAll 查询全部记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 执行自定义 SQL 查询（返回实体列表）
   *
   * @param sql    SQL 查询语句
   * @param params 绑定参数
   * @returns 实体对象列表
   */
  async getBySql(sql: string, params: relationalStore.ValueType[]): Promise<ConversationEntity[]> {
    try {
      const store = this.rdbStore;
      const resultSet: relationalStore.ResultSet = await store.querySql(sql, params);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error('ConversationDao getBySql 执行SQL查询失败 (sql=' + sql + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }
}
