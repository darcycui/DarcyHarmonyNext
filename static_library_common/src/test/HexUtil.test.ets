/*
 * HexUtil 单元测试
 */
import { describe, it, expect } from '@ohos/hypium';
import { HexUtil } from '../../Index';

export default function hexUtilTest() {
  describe('HexUtilTest', () => {
    it('bytesToHex_normal', 0, () => {
      let input = new Uint8Array([0x1a, 0x2b, 0x3c, 0x4d]);
      let result = HexUtil.bytesToHex(input);
      expect(result).assertEqual('1a2b3c4d');
    });

    it('bytesToHex_all_zero', 0, () => {
      let input = new Uint8Array([0x00, 0x00, 0x00]);
      let result = HexUtil.bytesToHex(input);
      expect(result).assertEqual('000000');
    });

    it('bytesToHex_all_ff', 0, () => {
      let input = new Uint8Array([0xff, 0xff]);
      let result = HexUtil.bytesToHex(input);
      expect(result).assertEqual('ffff');
    });

    it('bytesToHex_empty', 0, () => {
      let input = new Uint8Array();
      let result = HexUtil.bytesToHex(input);
      expect(result).assertEqual('');
    });

    it('bytesToHex_single_byte', 0, () => {
      let input = new Uint8Array([0x0a]);
      let result = HexUtil.bytesToHex(input);
      expect(result).assertEqual('0a');
    });

    it('hexToBytes_normal', 0, () => {
      let result = HexUtil.hexToBytes('1a2b3c4d');
      expect(result[0]).assertEqual(0x1a);
      expect(result[1]).assertEqual(0x2b);
      expect(result[2]).assertEqual(0x3c);
      expect(result[3]).assertEqual(0x4d);
      expect(result.length).assertEqual(4);
    });

    it('hexToBytes_uppercase', 0, () => {
      let result = HexUtil.hexToBytes('1A2B3C4D');
      expect(result[0]).assertEqual(0x1a);
      expect(result[1]).assertEqual(0x2b);
      expect(result[2]).assertEqual(0x3c);
      expect(result[3]).assertEqual(0x4d);
    });

    it('hexToBytes_empty_string', 0, () => {
      let result = HexUtil.hexToBytes('');
      expect(result.length).assertEqual(0);
    });

    it('hexToBytes_zero_values', 0, () => {
      let result = HexUtil.hexToBytes('0000');
      expect(result[0]).assertEqual(0x00);
      expect(result[1]).assertEqual(0x00);
    });

    it('bytesToHex_hexToBytes_roundtrip', 0, () => {
      let original = new Uint8Array([0x12, 0x34, 0x56, 0x78, 0x9a, 0xbc, 0xde, 0xf0]);
      let hex = HexUtil.bytesToHex(original);
      let restored = HexUtil.hexToBytes(hex);
      expect(restored.length).assertEqual(original.length);
      for (let i = 0; i < original.length; i++) {
        expect(restored[i]).assertEqual(original[i]);
      }
    });

    it('hexToBytes_bytesToHex_roundtrip', 0, () => {
      let hexStr = 'deadbeef01234567';
      let bytes = HexUtil.hexToBytes(hexStr);
      let restoredHex = HexUtil.bytesToHex(bytes);
      expect(restoredHex).assertEqual(hexStr);
    });
  });
}
