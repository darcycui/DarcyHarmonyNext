import abilityTest from './Ability.test';
// library_crypto（HAR）的仪器化测试套件：HAR 无法独立运行仪器化测试，故由宿主 HAP（entry）聚合执行
import testCryptoUtil from 'library_crypto/src/ohosTest/ets/test/CryptoUtil.test';
import testDHExchangeUtil from 'library_crypto/src/ohosTest/ets/test/DHExchangeUtil.test';

export default function testsuite() {
  abilityTest();
  testCryptoUtil();
  testDHExchangeUtil();
}