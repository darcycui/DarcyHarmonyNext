/*
 * HashUtil 单元测试
 * 测试 SHA256 哈希计算（同步和异步方法）
 */
import { describe, it, expect } from '@ohos/hypium';
import { HashUtil, ArrayUtil } from '../../Index';

export default function hashUtilTest() {
  describe('HashUtilTest', () => {
    it('sha256FromBytes_known_input', 0, async (done: () => void) => {
      let input = ArrayUtil.stringToBytes('Hello');
      console.log('Input:', input);
      let result = await HashUtil.sha256FromBytes(input);
      console.log('Result:', result);
      // Known SHA256('Hello') hex value
      let expected = '185f8db32271fe25f561a6fc938b2e264306ec304eda518007d1764826381969';
      expect(result).assertEqual(expected);
      done();
    });

    it('sha256FromBytes_empty_input', 0, async (done: () => void) => {
      let input = new Uint8Array();
      console.log('Input:', input);
      let result = await HashUtil.sha256FromBytes(input);
      console.log('Result:', result);
      // Known SHA256('') hex value
      let expected = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
      expect(result).assertEqual(expected);
      done();
    });

    it('sha256FromBytes_chinese_input', 0, async (done: () => void) => {
      let input = ArrayUtil.stringToBytes('鸿蒙');
      let result = await HashUtil.sha256FromBytes(input);
      // Result should be a 64-char hex string
      expect(result.length).assertEqual(64);
      // Non-empty result
      expect(result.length).assertLarger(0);
      done();
    });

    it('sha256FromBytesSync_known_input', 0, () => {
      let input = ArrayUtil.stringToBytes('Hello');
      let result = HashUtil.sha256FromBytesSync(input);
      let expected = '185f8db32271fe25f561a6fc938b2e264306ec304eda518007d1764826381969';
      expect(result).assertEqual(expected);
    });

    it('sha256FromBytesSync_empty_input', 0, () => {
      let input = new Uint8Array();
      let result = HashUtil.sha256FromBytesSync(input);
      let expected = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
      expect(result).assertEqual(expected);
    });

    it('sha256FromBytes_sha256FromBytesSync_consistency', 0, async (done: () => void) => {
      let input = ArrayUtil.stringToBytes('HarmonyOS Next 鸿蒙系统');
      let asyncResult = await HashUtil.sha256FromBytes(input);
      let syncResult = HashUtil.sha256FromBytesSync(input);
      expect(asyncResult).assertEqual(syncResult);
      done();
    });
  });
}
