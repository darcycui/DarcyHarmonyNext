import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { HexUtil, ArrayUtil } from 'static_library_common'
import { TransformCryptoUtil } from 'library_crypto'


export default function decryptImplTest() {
  describe('decryptImpl', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    it('test_decrypt', 0, () => {
      const cipherData =
        '7d1b921f364e10595bcf9c154eaba9ff561a86112897fa857f646d09afde8cc3550becfbc6bf54415606f5e53a20bac84b9a947c8d64119cc25b4568f3ede73f7e7d50b9b37bd3f3052803690dfab1e891544196236abad6c01e90e4a7d209dd291f75b03439877752a7a90d04d93fe3cd87f994dc0fb0e5ef4893b18c354d42530c57ef4c2e4584d268829e61980316ef486b902d0f6f51e808c20b6f57785e5c52f24a406ce4d88bab9bd12e1f8b6450f48b623faa4129bc3aca970301a8a6616a6a07af4e6717ef3a50f9c441867ff27749725ae3e8e81662c8d9084a436c58c57187313d9e5255cf206d946f4024a074110ca7bd0c7891e80a5c1be5137545ab0a9541341651ce9f518e075cdf8ff6268db88cc8b2f8e8c297d89dc3a83ed95b899c15e0d685b91f67d32022a3fecf332367c2e32742b386fc49339ef7d8249c1f3132678bdc316bcc217286d32e2c5fdf2e6ef03a7eb19a5a8f18a535636e216452fe96e95da712d15f1a620b55600f0bdb6f5b9ee0501134d8711b25360d9750027122a0501108ef48fdb3b572e8400a3e5ab06b86f6422284e6196c6dc5e6d190ec355419c8f43ded4ec1269adcfc814c34a22150225de2e0eb74c2eb68ae5a93e9146f67ff2cc5e1455a6e7bf4c59a65646ebf78d90dfa66c59aefeaa8720d9497832163ba272f0748551e401f412f3510014e76f9c1317f214f7b90e72bb58ad984bf8a09675da6630264e2a981ae0a17f82ac13b35192d6476c69d4a84713098edd30e06d7bc1b6aea300c085c4697393fef38f94623805d1fd524a19c58e8b900337832b15877ce9f904adffd0d67004e702310b9adf08749ede9ee4d567790ac0a282b57a174e769dda3031e0a207938b33ab75f41bd7499eca44bffb42ac41752267a2d75004a7b49e53d72cbd25cc5147a7c096391c6cfc473c4b14d72ac859ea4e71db3b325f3a862b80be32dbd9d20a180e8d0132739d34d27c3b5b0332aae38b8a138021557508c76394040ad93ffc9092d68cb0a44f502ca472171d08f5436609ead6e9073220e5ad290d46343933e7b111819260e9e00356201683f206903a3e5c14832ac2889606cfa8d711a7c3219bca50bf74efefdfd42bde7859f020fac7584a55de53c19ccb3cdccee9fd91ec931b8a275da896d0e22a65ee1a05e2c434efb9090c32b6afea8cb4ee5f147d34c244cb8ba2c65a7c06dc376cdf9004c3358bdf3d8d5c0ae80afab7ffb0a7069579907e8de3178f0886a405dca0b8e5d670946b44caad9f61976a76f16387a820189a3b0ca56ae479597a90ce6dae083c6b86acf3bf0eb3903ee138066cace3a8237909fb87c3a187af1362b6f451140ba63baf2d8367fb3f1ad99277e4118fdee7c793065bc98a55d84082e80bf6ec795bd72b608d4cfd3990825906046193208cddbbacef380054961532f3ec2bbc1e140d3126bc19779c32fd4f6a055d1bfcc4c1c39d7453e9a00cdf00a49518deace604e08c4f1fb8fe585246ef05c4825f7d73bb9f0d3a354ccb79fd12eef43b9e8ac8725835b673c191d19982a05aab24990ee9c1449c9aaa292960d3fb90b39e340846fffe4e9a4b9c7edc4d2a955672998a28137c5b1e55e62f02a5d5e7ce54889c14b4063b1872077212c419454fa4be0e8739f3cb79fc9562e696c1cd71eeaf9f4672ea44e5dc23fa929a1b6a7a4d8467be2bb68418d3f816a5bf6aeb6e128255f1bb29e3f164afc025531c0dc919bc55551ebeac8e8878468bc49eab1f597ec388ac77486707381f990fd1ca8c45afa39be82c9e4cf436374efb9c6ec298878469f590dca12ea44fe0ce666993c0bb038cc8e88fc7fd4f632356967cda635b17cd630444c60496085a29602295291b4fd9db438f378b6053986f7392985940046578b65892237d3f017c16ab75d1d74dee1b33ddec61d453ceb4883a350c4eba29e04632e8f566a4267fd27e801c06d58e6cbb639a2f2cb67dd2bad1b8f19c8c87f62603003cced89894774'
      const cipherBytes = HexUtil.hexToBytes(cipherData)
      const plainBytes = TransformCryptoUtil.decryptSync(
        cipherBytes,
        new Uint8Array(),
        new Uint8Array()
      )
      let rspContext = ''
      if (plainBytes.length > 0) {
        rspContext = ArrayUtil.bytesToString(plainBytes)
      }
      console.warn(`<==Decrypted Body: ${rspContext}`);
    });
  });
}