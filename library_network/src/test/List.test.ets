import decryptImplTest from './DecryptImplTest.test';
import localUnitTest from './LocalUnit.test';

export default function testsuite() {
  localUnitTest();
  decryptImplTest();
}