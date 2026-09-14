/*
 * static_library_common 单元测试统一注册入口
 * 仅保留无系统 API 依赖的纯计算测试（HexUtil）
 * ArrayUtil / Base64Util / HashUtil 已迁移至 src/ohosTest/
 */
import hexUtilTest from './HexUtil.test';

export default function testsuite() {
  hexUtilTest();
}
