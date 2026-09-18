import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { IdentityKeyDao } from './daos/IdentityKeyDao';
import { MessageReadStatusDao } from './daos/MessageReadStatusDao';
import { OneTimePreKeyDao } from './daos/OneTimePreKeyDao';
import { SessionRecordDao } from './daos/SessionRecordDao';
import { SignedPreKeyDao } from './daos/SignedPreKeyDao';
import { SkippedMessageKeyDao } from './daos/SkippedMessageKeyDao';
import { Contexts } from 'static_library_common';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { ConversationDao } from './daos/ConversationDao';
import { FriendshipUserDao } from './daos/FriendshipUserDao';
import { PrivateMessageDao } from './daos/PrivateMessageDao';

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

const CREATE_SESSION_RECORD_TABLE_SQL: string =
  'CREATE TABLE IF NOT EXISTS session_record (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'local_user_id INTEGER NOT NULL, ' +
    'remote_user_id INTEGER NOT NULL, ' +
    'remote_identity_key TEXT NOT NULL, ' +
    'remote_dh_key TEXT NOT NULL, ' +
    'local_ephemeral_private_key TEXT NOT NULL, ' +
    'local_ephemeral_public_key TEXT NOT NULL, ' +
    'root_key TEXT NOT NULL, ' +
    'sending_chain_key TEXT NOT NULL, ' +
    'receiving_chain_key TEXT NOT NULL, ' +
    'receiving_chain_index INTEGER NOT NULL, ' +
    'n INTEGER NOT NULL, ' +
    'pn INTEGER NOT NULL, ' +
    'created_time TEXT NOT NULL, ' +
    'updated_time TEXT NOT NULL' +
    ')';

const CREATE_MESSAGE_READ_STATUS_TABLE_SQL: string =
  'CREATE TABLE IF NOT EXISTS message_read_status (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'msg_id TEXT NOT NULL, ' +
    'user_id INTEGER NOT NULL, ' +
    'target_id INTEGER NOT NULL, ' +
    'is_read INTEGER NOT NULL, ' +
    'message_type INTEGER NOT NULL, ' +
    'read_time TEXT NOT NULL, ' +
    'created_time TEXT NOT NULL, ' +
    'updated_time TEXT NOT NULL' +
    ')';

const CREATE_SKIPPED_MESSAGE_KEY_TABLE_SQL: string =
  'CREATE TABLE IF NOT EXISTS skipped_message_key (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'user_id INTEGER NOT NULL, ' +
    'target_id INTEGER NOT NULL, ' +
    'msg_id TEXT NOT NULL, ' +
    'dh_public_key TEXT NOT NULL, ' +
    'chain_index INTEGER NOT NULL, ' +
    'message_key TEXT NOT NULL, ' +
    'mac_key TEXT NOT NULL, ' +
    'iv TEXT NOT NULL, ' +
    'created_time TEXT NOT NULL' +
    ')';

// ══════════════════════════════════════════════
//  DarcyIMDatabase  — 数据库管理器（单例）
// ══════════════════════════════════════════════

export class DarcyIMDatabase {
  private static instance: DarcyIMDatabase | null = null;
  /** 单个 RdbStore，供所有 DAO 共享 */
  private rdbStore: relationalStore.RdbStore | null = null;
  private initPromise: Promise<void> | null = null;
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
    if (context == null) {
      throw new Error('DarcyIMDatabase 首次调用 getInstance 时必须传入 context')
    }
    if (DarcyIMDatabase.instance == null) {
      DarcyIMDatabase.instance = new DarcyIMDatabase(context)
      DarcyIMDatabase.instance.initPromise = DarcyIMDatabase.instance.initDatabase()
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
      await this.rdbStore.executeSql(CREATE_SESSION_RECORD_TABLE_SQL);
      await this.rdbStore.executeSql(CREATE_MESSAGE_READ_STATUS_TABLE_SQL);
      await this.rdbStore.executeSql(CREATE_SKIPPED_MESSAGE_KEY_TABLE_SQL);
    } catch (err) {
      throw new Error('DarcyIMDatabase 数据库初始化失败: ' + ErrorUtil.getErrorMessage(err));
    }
  }

  /**
   * 获取内部的 RdbStore 实例（若未初始化则抛出异常）
   */
  private async getRdbStore(): Promise<relationalStore.RdbStore> {
    if (this.initPromise !== null) {
      await this.initPromise;
    }
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
  async getIdentityKeyDao(): Promise<IdentityKeyDao> {
    return new IdentityKeyDao(await this.getRdbStore());
  }

  /**
   * 获取 OneTimePreKeyDao 实例
   */
  async getOneTimePreKeyDao(): Promise<OneTimePreKeyDao> {
    return new OneTimePreKeyDao(await this.getRdbStore());
  }

  /**
   * 获取 SignedPreKeyDao 实例
   */
  async getSignedPreKeyDao(): Promise<SignedPreKeyDao> {
    return new SignedPreKeyDao(await this.getRdbStore());
  }

  /**
   * 获取 SessionRecordDao 实例
   */
  async getSessionRecordDao(): Promise<SessionRecordDao> {
    return new SessionRecordDao(await this.getRdbStore());
  }

  /**
   * 获取 MessageReadStatusDao 实例
   */
  async getMessageReadStatusDao(): Promise<MessageReadStatusDao> {
    return new MessageReadStatusDao(await this.getRdbStore());
  }

  /**
   * 获取 SkippedMessageKeyDao 实例
   */
  async getSkippedMessageKeyDao(): Promise<SkippedMessageKeyDao> {
    return new SkippedMessageKeyDao(await this.getRdbStore());
  }

  /**
   * 获取 ConversationDao 实例
   */
  async getConversationDao(): Promise<ConversationDao> {
    return new ConversationDao(await this.getRdbStore());
  }

  /**
   * 获取 FriendshipUserDao 实例
   */
  async getFriendshipUserDao(): Promise<FriendshipUserDao> {
    return new FriendshipUserDao(await this.getRdbStore());
  }

  /**
   * 获取 PrivateMessageDao 实例
   */
  async getPrivateMessageDao(): Promise<PrivateMessageDao> {
    return new PrivateMessageDao(await this.getRdbStore());
  }
}
