/*
 * ArrayUtil 仪器化测试（需真机/模拟器运行）
 * buffer / util.TextDecoder 是系统 API，本地单测中可能为桩实现
 */
import { describe, it, expect } from '@ohos/hypium';
import { ArrayUtil } from '../../../main/ets/utils/ArrayUtil';

export default function arrayUtilTest() {
  describe('ArrayUtilTest', () => {
    it('isEmpty_empty_array', 0, () => {
      let result = ArrayUtil.isEmpty([]);
      expect(result).assertTrue();
    });

    it('isEmpty_non_empty_array', 0, () => {
      let input: Array<object>[] = [[]];
      let result = ArrayUtil.isEmpty(input);
      expect(result).assertFalse();
    });

    it('stringToBytes_ascii', 0, () => {
      let result = ArrayUtil.stringToBytes('Hello');
      expect(result.length).assertEqual(5);
      expect(result[0]).assertEqual(72);
      expect(result[1]).assertEqual(101);
      expect(result[2]).assertEqual(108);
      expect(result[3]).assertEqual(108);
      expect(result[4]).assertEqual(111);
    });

    it('stringToBytes_chinese', 0, () => {
      let result = ArrayUtil.stringToBytes('你好');
      expect(result.length).assertEqual(6);
    });

    it('stringToBytes_empty', 0, () => {
      let result = ArrayUtil.stringToBytes('');
      expect(result.length).assertEqual(0);
    });

    it('bytesToString_normal', 0, () => {
      let input = new Uint8Array([72, 101, 108, 108, 111]);
      let result = ArrayUtil.bytesToString(input);
      expect(result).assertEqual('Hello');
    });

    it('bytesToString_chinese', 0, () => {
      let input = ArrayUtil.stringToBytes('你好');
      let result = ArrayUtil.bytesToString(input);
      expect(result).assertEqual('你好');
    });

    it('bytesToString_empty', 0, () => {
      let result = ArrayUtil.bytesToString(new Uint8Array());
      expect(result).assertEqual('');
    });

    it('stringToBytes_bytesToString_roundtrip', 0, () => {
      let original = 'Hello HarmonyOS! 你好，鸿蒙！';
      let bytes = ArrayUtil.stringToBytes(original);
      let restored = ArrayUtil.bytesToString(bytes);
      expect(restored).assertEqual(original);
    });

    it('bytesToString2_normal', 0, () => {
      let input = new Uint8Array([72, 101, 108, 108, 111]);
      let result = ArrayUtil.bytesToString2(input);
      expect(result).assertEqual('Hello');
    });

    it('bytesToString2_chinese', 0, () => {
      let input = ArrayUtil.stringToBytes('鸿蒙Next');
      let result = ArrayUtil.bytesToString2(input);
      expect(result).assertEqual('鸿蒙Next');
    });

    it('bytesToString2_empty', 0, () => {
      let result = ArrayUtil.bytesToString2(new Uint8Array());
      expect(result).assertEqual('');
    });
  });
}
