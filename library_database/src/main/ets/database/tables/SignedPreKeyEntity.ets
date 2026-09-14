/**
 * 已签名预密钥（SignedPreKey）实体类
 *
 * 对应数据库表名：signed_pre_key
 * 字段映射：
 *   - id             : 主键，自增（Long 类型）
 *   - keyId          : 密钥唯一标识（String）
 *   - identityKeyId  : 关联的身份密钥 ID（String）
 *   - userId         : 所属用户 ID（Long）
 *   - privateKey     : 私钥内容（String）
 *   - publicKey      : 公钥内容（String）
 *   - signature      : 签名（String）
 */
export class SignedPreKeyEntity {
  /**
   * 主键，自增
   */
  id: number = 0;

  /**
   * 密钥唯一标识
   */
  keyId: string = '';

  /**
   * 关联的身份密钥 ID
   */
  identityKeyId: string = '';

  /**
   * 所属用户 ID
   */
  userId: number = 0;

  /**
   * 私钥内容
   */
  privateKey: string = '';

  /**
   * 公钥内容
   */
  publicKey: string = '';

  /**
   * 签名
   */
  signature: string = '';

  constructor(
    id?: number,
    keyId?: string,
    identityKeyId?: string,
    userId?: number,
    privateKey?: string,
    publicKey?: string,
    signature?: string,
  ) {
    if (id !== undefined) {
      this.id = id;
    }
    if (keyId !== undefined) {
      this.keyId = keyId;
    }
    if (identityKeyId !== undefined) {
      this.identityKeyId = identityKeyId;
    }
    if (userId !== undefined) {
      this.userId = userId;
    }
    if (privateKey !== undefined) {
      this.privateKey = privateKey;
    }
    if (publicKey !== undefined) {
      this.publicKey = publicKey;
    }
    if (signature !== undefined) {
      this.signature = signature;
    }
  }
}
