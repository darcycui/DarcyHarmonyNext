/*
 * Base64Util 单元测试
 */
import { describe, it, expect } from '@ohos/hypium';
import { Base64Util, ArrayUtil } from '../../Index';

export default function base64UtilTest() {
  describe('Base64UtilTest', () => {
    it('base64Encode_hello', 0, () => {
      let input = new Uint8Array([72, 101, 108, 108, 111]); // 'Hello'
      let result = Base64Util.base64Encode(input);
      // 'Hello' Base64 encoded is 'SGVsbG8='
      expect(result).assertEqual('SGVsbG8=');
    });

    it('base64Encode_empty', 0, () => {
      let result = Base64Util.base64Encode(new Uint8Array());
      expect(result).assertEqual('');
    });

    it('base64DecodeToString_hello', 0, () => {
      let result = Base64Util.base64DecodeToString('SGVsbG8=');
      expect(result).assertEqual('Hello');
    });

    it('base64DecodeToUint8Array_hello', 0, () => {
      let result = Base64Util.base64DecodeToUint8Array('SGVsbG8=');
      expect(result.length).assertEqual(5);
      expect(result[0]).assertEqual(72);  // 'H'
      expect(result[1]).assertEqual(101); // 'e'
    });

    it('base64Encode_base64DecodeToString_roundtrip', 0, () => {
      let original = 'HarmonyOS Next 鸿蒙系统';
      let bytes = ArrayUtil.stringToBytes(original);
      let encoded = Base64Util.base64Encode(bytes);
      let decoded = Base64Util.base64DecodeToString(encoded);
      expect(decoded).assertEqual(original);
    });

    it('base64DecodeToString_empty', 0, () => {
      let result = Base64Util.base64DecodeToString('');
      expect(result).assertEqual('');
    });
  });
}
