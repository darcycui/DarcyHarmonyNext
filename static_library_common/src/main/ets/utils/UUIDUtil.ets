import { util } from '@kit.ArkTS';

const IDENTITY_KEY_PREFIX = 'identity_key_';
const SIGNED_PRE_KEY_PREFIX = 'signed_pre_key_';
const ONE_TIME_PRE_KEY_PREFIX = 'one_time_pre_key_';
const MESSAGE_ID_PREFIX = 'msg_';

export class UUIDUtil {
  /**
   * 生成随机 UUID（32位，无连字符）
   * @returns 小写十六进制 UUID 字符串
   */
  static generateRandomUUID(): string {
    return util.generateRandomUUID().replace(/-/g, '');
  }

  /**
   * 生成 IdentityKey ID
   * @returns 格式：identity_key_{uuid}
   */
  static generateIdentityKeyId(): string {
    return `${IDENTITY_KEY_PREFIX}${UUIDUtil.generateRandomUUID()}`;
  }

  /**
   * 生成 SignedPreKey ID
   * @returns 格式：signed_pre_key_{uuid}
   */
  static generateSignedPreKeyId(): string {
    return `${SIGNED_PRE_KEY_PREFIX}${UUIDUtil.generateRandomUUID()}`;
  }

  /**
   * 生成 OneTimePreKey ID
   * @returns 格式：one_time_pre_key_{uuid}
   */
  static generateOneTimePreKeyId(): string {
    return `${ONE_TIME_PRE_KEY_PREFIX}${UUIDUtil.generateRandomUUID()}`;
  }

  /**
   * 生成消息 ID
   * @returns 格式：msg_{uuid}
   */
  static generateMessageId(): string {
    return `${MESSAGE_ID_PREFIX}${UUIDUtil.generateRandomUUID()}`;
  }
}
