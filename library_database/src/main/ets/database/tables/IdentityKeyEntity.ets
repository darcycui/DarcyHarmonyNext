/**
 * 身份密钥（IdentityKey）实体类
 *
 * 对应数据库表名：identity_key
 * 字段映射：
 *   - id          : 主键，自增（Long 类型）
 *   - keyId       : 密钥唯一标识（String）
 *   - userId      : 所属用户 ID（Long）
 *   - privateKey  : 私钥内容（String）
 *   - publicKey   : 公钥内容（String）
 */
export class IdentityKeyEntity {
  /**
   * 主键，自增
   */
  id: number = 0;

  /**
   * 密钥唯一标识
   */
  keyId: string = '';

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

  constructor(id?: number, keyId?: string, userId?: number, privateKey?: string, publicKey?: string) {
    if (id !== undefined) {
      this.id = id;
    }
    if (keyId !== undefined) {
      this.keyId = keyId;
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
  }
}