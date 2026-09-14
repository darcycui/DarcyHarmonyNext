/**
 * 会话记录（SessionRecord）实体类
 *
 * 对应数据库表名：session_record
 * 字段映射：
 *   - id                        : 主键，自增（Long 类型）
 *   - localUserId               : 本地用户 ID（Long）
 *   - remoteUserId              : 远程用户 ID（Long）
 *   - remoteIdentityKey         : 远程身份密钥（String）
 *   - remoteDHKey               : 远程 DH 密钥（String）
 *   - localEphemeralPrivateKey  : 本地临时私钥（String）
 *   - localEphemeralPublicKey   : 本地临时公钥（String）
 *   - rootKey                   : 根密钥（String）
 *   - sendingChainKey           : 发送链密钥（String）
 *   - receivingChainKey         : 接收链密钥（String）
 *   - receivingChainIndex       : 接收链索引（Long）
 *   - N                         : 发送链消息序号（Long）
 *   - PN                        : 前一个发送链长度（Long）
 *   - createdTime               : 创建时间（String）
 *   - updatedTime               : 更新时间（String）
 */
export class SessionRecordEntity {
  /**
   * 主键，自增
   */
  id: number = 0;

  /**
   * 本地用户 ID
   */
  localUserId: number = 0;

  /**
   * 远程用户 ID
   */
  remoteUserId: number = 0;

  /**
   * 远程身份密钥
   */
  remoteIdentityKey: string = '';

  /**
   * 远程 DH 密钥
   */
  remoteDHKey: string = '';

  /**
   * 本地临时私钥
   */
  localEphemeralPrivateKey: string = '';

  /**
   * 本地临时公钥
   */
  localEphemeralPublicKey: string = '';

  /**
   * 根密钥
   */
  rootKey: string = '';

  /**
   * 发送链密钥
   */
  sendingChainKey: string = '';

  /**
   * 接收链密钥
   */
  receivingChainKey: string = '';

  /**
   * 接收链索引
   */
  receivingChainIndex: number = 0;

  /**
   * 发送链消息序号
   */
  N: number = 0;

  /**
   * 前一个发送链长度
   */
  PN: number = 0;

  /**
   * 创建时间
   */
  createdTime: string = '';

  /**
   * 更新时间
   */
  updatedTime: string = '';

  constructor(
    id?: number,
    localUserId?: number,
    remoteUserId?: number,
    remoteIdentityKey?: string,
    remoteDHKey?: string,
    localEphemeralPrivateKey?: string,
    localEphemeralPublicKey?: string,
    rootKey?: string,
    sendingChainKey?: string,
    receivingChainKey?: string,
    receivingChainIndex?: number,
    N?: number,
    PN?: number,
    createdTime?: string,
    updatedTime?: string,
  ) {
    if (id !== undefined) {
      this.id = id;
    }
    if (localUserId !== undefined) {
      this.localUserId = localUserId;
    }
    if (remoteUserId !== undefined) {
      this.remoteUserId = remoteUserId;
    }
    if (remoteIdentityKey !== undefined) {
      this.remoteIdentityKey = remoteIdentityKey;
    }
    if (remoteDHKey !== undefined) {
      this.remoteDHKey = remoteDHKey;
    }
    if (localEphemeralPrivateKey !== undefined) {
      this.localEphemeralPrivateKey = localEphemeralPrivateKey;
    }
    if (localEphemeralPublicKey !== undefined) {
      this.localEphemeralPublicKey = localEphemeralPublicKey;
    }
    if (rootKey !== undefined) {
      this.rootKey = rootKey;
    }
    if (sendingChainKey !== undefined) {
      this.sendingChainKey = sendingChainKey;
    }
    if (receivingChainKey !== undefined) {
      this.receivingChainKey = receivingChainKey;
    }
    if (receivingChainIndex !== undefined) {
      this.receivingChainIndex = receivingChainIndex;
    }
    if (N !== undefined) {
      this.N = N;
    }
    if (PN !== undefined) {
      this.PN = PN;
    }
    if (createdTime !== undefined) {
      this.createdTime = createdTime;
    }
    if (updatedTime !== undefined) {
      this.updatedTime = updatedTime;
    }
  }
}
