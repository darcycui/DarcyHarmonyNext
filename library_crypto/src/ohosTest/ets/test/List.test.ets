// ============================================================
// library_crypto 仪器化测试入口（聚合器）
// 说明：HAR 无法独立运行仪器化测试（无 HAP 可安装），
// 本套件由宿主 HAP（entry）的 src/ohosTest/ets/test/List.test.ets 导入并执行。
// ============================================================
import testCryptoUtil from './CryptoUtil.test';
import testDHExchangeUtil from './DHExchangeUtil.test';

export default function testsuite() {
  testCryptoUtil();
  testDHExchangeUtil();
}