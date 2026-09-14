import abilityTest from './Ability.test';
// library_crypto（HAR）的仪器化测试套件：HAR 无法独立运行仪器化测试，故由宿主 HAP（entry）聚合执行
import testCryptoUtil from 'library_crypto/src/ohosTest/ets/test/CryptoUtil.test';
import testDHExchangeUtil from 'library_crypto/src/ohosTest/ets/test/DHExchangeUtil.test';
// static_library_common 的仪器化测试：系统 API 在本地单测中是桩实现
import hashUtilTest from 'static_library_common/src/ohosTest/ets/test/HashUtil.test';
import arrayUtilTest from 'static_library_common/src/ohosTest/ets/test/ArrayUtil.test';
import base64UtilTest from 'static_library_common/src/ohosTest/ets/test/Base64Util.test';

export default function testsuite() {
  abilityTest();
  testCryptoUtil();
  testDHExchangeUtil();
  hashUtilTest();
  arrayUtilTest();
  base64UtilTest();
}