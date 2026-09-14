import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { IdentityKeyDao } from './daos/IdentityKeyDao';
import { OneTimePreKeyDao } from './daos/OneTimePreKeyDao';
import { SignedPreKeyDao } from './daos/SignedPreKeyDao';
import { Contexts } from 'static_library_common';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';

// ══════════════════════════════════════════════
//  数据库配置（合并为单个数据库）
// ══════════════════════════════════════════════

const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'darcy_im_database',
  securityLevel: relationalStore.SecurityLevel.S3,
  encrypt: false,
};

// ══════════════════════════════════════════════
//  建表 SQL（所有表建在同一个数据库中）
// ══════════════════════════════════════════════

const CREATE_IDENTITY_KEY_TABLE_SQL: string =
  'CREATE TABLE IF NOT EXISTS identity_key (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'key_id TEXT NOT NULL, ' +
  'user_id INTEGER NOT NULL, ' +
  'private_key TEXT NOT NULL, ' +
  'public_key TEXT NOT NULL' +
  ')';

const CREATE_ONE_TIME_PRE_KEY_TABLE_SQL: string =
  'CREATE TABLE IF NOT EXISTS one_time_pre_key (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'key_id TEXT NOT NULL, ' +
  'user_id INTEGER NOT NULL, ' +
  'private_key TEXT NOT NULL, ' +
  'public_key TEXT NOT NULL' +
  ')';

const CREATE_SIGNED_PRE_KEY_TABLE_SQL: string =
  'CREATE TABLE IF NOT EXISTS signed_pre_key (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'key_id TEXT NOT NULL, ' +
  'identity_key_id TEXT NOT NULL, ' +
  'user_id INTEGER NOT NULL, ' +
  'private_key TEXT NOT NULL, ' +
  'public_key TEXT NOT NULL, ' +
  'signature TEXT NOT NULL' +
  ')';

// ══════════════════════════════════════════════
//  DarcyIMDatabase  — 数据库管理器（单例）
// ══════════════════════════════════════════════

export class DarcyIMDatabase {
  private static instance: DarcyIMDatabase | null = null;

  /** 单个 RdbStore，供所有 DAO 共享 */
  private rdbStore: relationalStore.RdbStore | null = null;
  private context: common.Context;

  private constructor(context: common.Context) {
    this.context = context;
  }

  /**
   * 获取 DarcyIMDatabase 单例（首次调用时必须传入 context）
   *
   * @param context 应用上下文（仅首次调用时需要）
   * @returns DarcyIMDatabase 单例实例
   *
   * 示例：
   * ```ts
   * const db = DarcyIMDatabase.getInstance(getContext(this));
   * await db.initDatabase();
   * const dao = db.getIdentityKeyDao();
   * ```
   */
  static getInstance(context: common.Context = Contexts.getContext()): DarcyIMDatabase {
    if (DarcyIMDatabase.instance == null) {
      if (context == null) {
        throw new Error('DarcyIMDatabase 首次调用 getInstance 时必须传入 context')
      }
      DarcyIMDatabase.instance = new DarcyIMDatabase(context)
      DarcyIMDatabase.instance.initDatabase()
    }
    return DarcyIMDatabase.instance;
  }

  // ────────────────────────────────────────────
  //  数据库初始化
  // ────────────────────────────────────────────

  /**
   * 初始化 darcy_im_database & 建所有表
   *
   * 使用方式（在 UIAbility 或页面中）：
   * ```ts
   * const db = DarcyIMDatabase.getInstance(getContext(this));
   * await db.initDatabase();
   * ```
   */
  async initDatabase(): Promise<void> {
    try {
      // 1. 创建/打开单个数据库
      this.rdbStore = await relationalStore.getRdbStore(this.context, STORE_CONFIG);

      // 2. 建所有表
      await this.rdbStore.executeSql(CREATE_IDENTITY_KEY_TABLE_SQL);
      await this.rdbStore.executeSql(CREATE_ONE_TIME_PRE_KEY_TABLE_SQL);
      await this.rdbStore.executeSql(CREATE_SIGNED_PRE_KEY_TABLE_SQL);
    } catch (err) {
      throw new Error('DarcyIMDatabase 数据库初始化失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 获取内部的 RdbStore 实例（若未初始化则抛出异常）
   */
  private getRdbStore(): relationalStore.RdbStore {
    if (this.rdbStore === null) {
      throw new Error('RdbStore 尚未初始化，请先调用 initDatabase 方法');
    }
    return this.rdbStore;
  }

  // ────────────────────────────────────────────
  //  DAO 工厂方法（所有 DAO 共享同一个 rdbStore）
  // ────────────────────────────────────────────

  /**
   * 获取 IdentityKeyDao 实例
   */
  getIdentityKeyDao(): IdentityKeyDao {
    return new IdentityKeyDao(this.getRdbStore());
  }

  /**
   * 获取 OneTimePreKeyDao 实例
   */
  getOneTimePreKeyDao(): OneTimePreKeyDao {
    return new OneTimePreKeyDao(this.getRdbStore());
  }

  /**
   * 获取 SignedPreKeyDao 实例
   */
  getSignedPreKeyDao(): SignedPreKeyDao {
    return new SignedPreKeyDao(this.getRdbStore());
  }
}
