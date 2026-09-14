import abilityTest from './Ability.test';
import hashUtilTest from './HashUtil.test';
import arrayUtilTest from './ArrayUtil.test';
import base64UtilTest from './Base64Util.test';

export default function testsuite() {
  abilityTest();
  hashUtilTest();
  arrayUtilTest();
  base64UtilTest();
}