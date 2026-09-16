/*
 * UUIDUtil 单元测试
 * 测试 UUID 生成及各类前缀 ID 生成
 */
import { describe, it, expect } from '@ohos/hypium';
import { UUIDUtil } from '../../Index';

export default function uuidUtilTest() {
  describe('UUIDUtilTest', () => {
    it('generateRandomUUID_notEmpty', 0, () => {
      let result = UUIDUtil.generateRandomUUID();
      expect(result.length > 0).assertTrue();
    });

    it('generateRandomUUID_noHyphens', 0, () => {
      let result = UUIDUtil.generateRandomUUID();
      expect(result.indexOf('-')).assertEqual(-1);
    });

    it('generateRandomUUID_length32', 0, () => {
      let result = UUIDUtil.generateRandomUUID();
      expect(result.length).assertEqual(32);
    });

    it('generateRandomUUID_hexOnly', 0, () => {
      let result = UUIDUtil.generateRandomUUID();
      expect(/^[0-9a-f]{32}$/.test(result)).assertTrue();
    });

    it('generateRandomUUID_uniqueness', 0, () => {
      let a = UUIDUtil.generateRandomUUID();
      let b = UUIDUtil.generateRandomUUID();
      expect(a !== b).assertTrue();
    });

    it('generateIdentityKeyId_hasPrefix', 0, () => {
      let result = UUIDUtil.generateIdentityKeyId();
      expect(result.startsWith('identity_key_')).assertTrue();
    });

    it('generateIdentityKeyId_hasUuid', 0, () => {
      let result = UUIDUtil.generateIdentityKeyId();
      let uuidPart = result.substring('identity_key_'.length);
      expect(uuidPart.length).assertEqual(32);
      expect(/^[0-9a-f]{32}$/.test(uuidPart)).assertTrue();
    });

    it('generateSignedPreKeyId_hasPrefix', 0, () => {
      let result = UUIDUtil.generateSignedPreKeyId();
      expect(result.startsWith('signed_pre_key_')).assertTrue();
    });

    it('generateSignedPreKeyId_hasUuid', 0, () => {
      let result = UUIDUtil.generateSignedPreKeyId();
      let uuidPart = result.substring('signed_pre_key_'.length);
      expect(uuidPart.length).assertEqual(32);
      expect(/^[0-9a-f]{32}$/.test(uuidPart)).assertTrue();
    });

    it('generateOneTimePreKeyId_hasPrefix', 0, () => {
      let result = UUIDUtil.generateOneTimePreKeyId();
      expect(result.startsWith('one_time_pre_key_')).assertTrue();
    });

    it('generateOneTimePreKeyId_hasUuid', 0, () => {
      let result = UUIDUtil.generateOneTimePreKeyId();
      let uuidPart = result.substring('one_time_pre_key_'.length);
      expect(uuidPart.length).assertEqual(32);
      expect(/^[0-9a-f]{32}$/.test(uuidPart)).assertTrue();
    });

    it('generateMessageId_hasPrefix', 0, () => {
      let result = UUIDUtil.generateMessageId();
      expect(result.startsWith('msg_')).assertTrue();
    });

    it('generateMessageId_hasUuid', 0, () => {
      let result = UUIDUtil.generateMessageId();
      let uuidPart = result.substring('msg_'.length);
      expect(uuidPart.length).assertEqual(32);
      expect(/^[0-9a-f]{32}$/.test(uuidPart)).assertTrue();
    });

    it('generateIdentityKeyId_uniqueness', 0, () => {
      let a = UUIDUtil.generateIdentityKeyId();
      let b = UUIDUtil.generateIdentityKeyId();
      expect(a !== b).assertTrue();
    });

    it('generateMessageId_uniqueness', 0, () => {
      let a = UUIDUtil.generateMessageId();
      let b = UUIDUtil.generateMessageId();
      expect(a !== b).assertTrue();
    });
  });
}
