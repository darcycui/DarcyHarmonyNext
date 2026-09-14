import { relationalStore } from '@kit.ArkData';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { FriendshipEntity } from '../tables/FriendshipEntity';

/**
 * 数据库表名
 */
const TABLE_NAME: string = 'friendship';

/**
 * 列名常量
 */
const COL_FRIENDSHIP_ID: string = 'friendship_id';
const COL_USER_ID_FROM: string = 'user_id_from';
const COL_USER_ID_TO: string = 'user_id_to';
const COL_MARK_NAME_OF_TO: string = 'mark_name_of_to';
const COL_MARK_NAME_OF_FROM: string = 'mark_name_of_from';
const COL_CREATED_TIME: string = 'created_time';
const COL_UPDATED_TIME: string = 'updated_time';
const COL_DELETED_TIME: string = 'deleted_time';
const COL_NAME: string = 'name';

/**
 * 查询所需的所有列（按顺序）
 */
const ALL_COLUMNS: string[] = [
  COL_FRIENDSHIP_ID, COL_USER_ID_FROM, COL_USER_ID_TO,
  COL_MARK_NAME_OF_TO, COL_MARK_NAME_OF_FROM,
  COL_CREATED_TIME, COL_UPDATED_TIME, COL_DELETED_TIME, COL_NAME,
];

// ══════════════════════════════════════════════
//  内部工具函数
// ══════════════════════════════════════════════

/**
 * 将 ResultSet 的当前行转换为 FriendshipEntity 对象
 *
 * @param rs  ResultSet 实例（调用前须已定位到有效行）
 * @returns   转换后的实体对象
 */
function rowToEntity(rs: relationalStore.ResultSet): FriendshipEntity {
  try {
    return new FriendshipEntity(
      rs.getLong(rs.getColumnIndex(COL_FRIENDSHIP_ID)),
      rs.getLong(rs.getColumnIndex(COL_USER_ID_FROM)),
      rs.getLong(rs.getColumnIndex(COL_USER_ID_TO)),
      rs.getString(rs.getColumnIndex(COL_MARK_NAME_OF_TO)),
      rs.getString(rs.getColumnIndex(COL_MARK_NAME_OF_FROM)),
      rs.getLong(rs.getColumnIndex(COL_CREATED_TIME)),
      rs.getLong(rs.getColumnIndex(COL_UPDATED_TIME)),
      rs.getLong(rs.getColumnIndex(COL_DELETED_TIME)),
      rs.getString(rs.getColumnIndex(COL_NAME)),
    );
  } catch (error) {
    throw new Error('FriendshipUserDao rowToEntity 转换失败: ' + JSON.stringify(error));
  }
}

/**
 * 将 FriendshipEntity 转换为 ValuesBucket（用于 insert / update）
 *
 * @param entity     实体对象
 * @param includeId  是否包含 id 字段（update 时通常不需要）
 * @returns          ValuesBucket
 */
function entityToBucket(entity: FriendshipEntity, includeId: boolean = false): relationalStore.ValuesBucket {
  try {
    const bucket: relationalStore.ValuesBucket = {
      'user_id_from': entity.userIdFrom,
      'user_id_to': entity.userIdTo,
      'mark_name_of_to': entity.markNameOfTo,
      'mark_name_of_from': entity.markNameOfFrom,
      'created_time': entity.createdTime,
      'updated_time': entity.updatedTime,
      'deleted_time': entity.deletedTime,
      'name': entity.name,
    };
    if (includeId) {
      bucket['friendship_id'] = entity.friendshipId;
    }
    return bucket;
  } catch (err) {
    throw new Error('FriendshipUserDao entityToBucket 转换失败: ' + JSON.stringify(err));
  }
}

/**
 * 遍历整个 ResultSet 并转换为实体列表（调用后自动关闭结果集）
 *
 * @param resultSet  结果集
 * @returns          实体列表
 */
function resultSetToEntityList(resultSet: relationalStore.ResultSet): FriendshipEntity[] {
  const list: FriendshipEntity[] = [];
  try {
    while (resultSet.goToNextRow()) {
      list.push(rowToEntity(resultSet));
    }
    return list;
  } catch (err) {
    throw new Error('FriendshipUserDao resultSetToEntityList 遍历结果集失败: ' + JSON.stringify(err));
  } finally {
    resultSet.close();
  }
}

// ══════════════════════════════════════════════
//  FriendshipUserDao  — 数据库访问对象
// ══════════════════════════════════════════════

export class FriendshipUserDao {
  private readonly rdbStore: relationalStore.RdbStore;

  constructor(rdbStore: relationalStore.RdbStore) {
    this.rdbStore = rdbStore;
  }

  // ────────────────────────────────────────────
  //  Create  —  插入
  // ────────────────────────────────────────────

  /**
   * 插入一条好友关系记录
   *
   * @param entity 好友关系实体（friendshipId 可忽略，由数据库自增）
   * @returns 插入成功后自动生成的主键 id
   */
  async insert(entity: FriendshipEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const rowId: number = await store.insert(TABLE_NAME, bucket);
      return rowId;
    } catch (err) {
      throw new Error('FriendshipUserDao 插入记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 批量插入多条好友关系记录（使用事务保证原子性）
   *
   * @param entities 好友关系实体列表
   * @returns 插入成功的数量
   */
  async insertBatch(entities: FriendshipEntity[]): Promise<number> {
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
      throw new Error('FriendshipUserDao 批量插入失败: ' + ErrorUtil.getErrorMessage(err));
    }
    return successCount;
  }

  // ────────────────────────────────────────────
  //  Delete  —  删除
  // ────────────────────────────────────────────

  /**
   * 根据主键 friendshipId 删除记录
   *
   * @param friendshipId 主键 id
   * @returns 受影响的行数
   */
  async deleteById(friendshipId: number): Promise<number> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_FRIENDSHIP_ID, friendshipId);
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'FriendshipUserDao deleteById 删除记录失败 (friendshipId=' + friendshipId + '): ' +
          ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户对（userIdFrom + userIdTo）删除好友关系
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
        'FriendshipUserDao deleteByUserPair 删除记录失败 (userIdFrom=' + userIdFrom + ', userIdTo=' + userIdTo +
          '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 删除指定用户的所有好友关系
   *
   * @param userId 用户 ID（作为发起方或接收方）
   * @returns 受影响的行数
   */
  async deleteByUserId(userId: number): Promise<number> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.beginWrap();
      predicates.equalTo(COL_USER_ID_FROM, userId);
      predicates.or();
      predicates.equalTo(COL_USER_ID_TO, userId);
      predicates.endWrap();
      const rows: number = await store.delete(predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'FriendshipUserDao deleteByUserId 删除记录失败 (userId=' + userId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 清空所有好友关系记录
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
      throw new Error('FriendshipUserDao deleteAll 清空记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  // ────────────────────────────────────────────
  //  Update  —  修改
  // ────────────────────────────────────────────

  /**
   * 根据主键 friendshipId 更新好友关系记录
   *
   * @param entity 新的实体对象（必须包含有效的 friendshipId）
   * @returns 受影响的行数
   */
  async update(entity: FriendshipEntity): Promise<number> {
    try {
      const store = this.rdbStore;
      const bucket: relationalStore.ValuesBucket = entityToBucket(entity, false);
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_FRIENDSHIP_ID, entity.friendshipId);
      const rows: number = await store.update(bucket, predicates);
      return rows;
    } catch (err) {
      throw new Error(
        'FriendshipUserDao update 更新记录失败 (friendshipId=' + entity.friendshipId + '): ' +
          ErrorUtil.getErrorMessage(err));
    }
  }

  // ────────────────────────────────────────────
  //  Query  —  查询
  // ────────────────────────────────────────────

  /**
   * 根据主键 friendshipId 查询单条记录
   *
   * @param friendshipId 主键 id
   * @returns 匹配的实体对象，未找到时返回 undefined
   */
  async getById(friendshipId: number): Promise<FriendshipEntity | undefined> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo(COL_FRIENDSHIP_ID, friendshipId);
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
        'FriendshipUserDao getById 查询记录失败 (friendshipId=' + friendshipId + '): ' +
          ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 根据用户对（userIdFrom + userIdTo）查询好友关系
   *
   * @param userIdFrom 发起方用户 ID
   * @param userIdTo   接收方用户 ID
   * @returns 匹配的实体对象，未找到时返回 undefined
   */
  async getByUserPair(userIdFrom: number, userIdTo: number): Promise<FriendshipEntity | undefined> {
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
        'FriendshipUserDao getByUserPair 查询记录失败 (userIdFrom=' + userIdFrom + ', userIdTo=' + userIdTo +
          '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询指定用户的所有好友关系（作为发起方或接收方）
   *
   * @param userId 用户 ID
   * @returns 匹配的实体对象列表
   */
  async getByUserId(userId: number): Promise<FriendshipEntity[]> {
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
        'FriendshipUserDao getByUserId 查询记录失败 (userId=' + userId + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 查询所有好友关系记录
   *
   * @returns 全部实体对象列表
   */
  async getAll(): Promise<FriendshipEntity[]> {
    try {
      const store = this.rdbStore;
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      const resultSet: relationalStore.ResultSet = await store.query(predicates, ALL_COLUMNS);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error('FriendshipUserDao getAll 查询全部记录失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 执行自定义 SQL 查询（返回实体列表）
   *
   * @param sql    SQL 查询语句
   * @param params 绑定参数
   * @returns 实体对象列表
   */
  async getBySql(sql: string, params: relationalStore.ValueType[]): Promise<FriendshipEntity[]> {
    try {
      const store = this.rdbStore;
      const resultSet: relationalStore.ResultSet = await store.querySql(sql, params);
      return resultSetToEntityList(resultSet);
    } catch (err) {
      throw new Error(
        'FriendshipUserDao getBySql 执行SQL查询失败 (sql=' + sql + '): ' + ErrorUtil.getErrorMessage(err));
    }
  }
}
