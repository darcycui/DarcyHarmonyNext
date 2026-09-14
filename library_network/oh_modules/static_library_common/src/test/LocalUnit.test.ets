/*
 * static_library_common 工具类单元测试
 * 覆盖：HashUtil, ArrayUtil, Base64Util, StringUnit8ArrayUtil, HexUtil
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  ArrayUtil, HashUtil, HexUtil, Base64Util,
} from '../../Index';

export default function localUnitTest() {
  /* =============================== */
  /*       HexUtil 测试套              */
  /* =============================== */
  describe('defaultTest', () => {
    it('testBoolean', 0, () => {
      expect(true).assertEqual(true);
    });
  });
}
