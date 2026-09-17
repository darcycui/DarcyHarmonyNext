/*
 * static_library_common 单元测试统一注册入口
 * 仅保留无系统 API 依赖的纯计算测试（HexUtil）
 * ArrayUtil / Base64Util / HashUtil 已迁移至 src/ohosTest/
 */
import arrayUtilTest from './ArrayUtil.test';
import base64UtilTest from './Base64Util.test';
import hashUtilTest from './HashUtil.test';
import hexUtilTest from './HexUtil.test';
import uuidUtilTest from './UUIDUtil.test';
import localUnitTest from './LocalUnit.test';

export default function testsuite() {
  arrayUtilTest()
  base64UtilTest()
  hashUtilTest()
  hexUtilTest();
  uuidUtilTest();
  localUnitTest()
}
