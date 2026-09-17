import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { HexUtil, ArrayUtil } from 'static_library_common'
import { TransportCipherUtil } from 'library_crypto'


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
        '7faf2c52d6b27737925cd7a3efdbd8e6c40c41e6b7c2e03349b929886217669661d79b262f72fe4c5b37243f6e1b5ca2b2c5732b8540690d9a9e0c2ceb49cfa638cfc19af374471e6dd9127d302556e6ebeeb356b6b336f97321e07c90d6845dfd9ffadeea3e2413767459dab3c85c830ab7c95ad19bd6ee6979b7697ace1ec759731a90f5913dd7e4e4f4603e90f620d807813ce2f5752bc8e20ea8ac78b6764a6f69c46af8efae5e9aaf2fa58af84f8773275c53a072de7f2aeb03182877375120fcdd1a077dbfa41686050b67363f0a2f88bf4122e88a5d1a7077a4d3e4dc1431c8b7222bd926f47dc81413d8ba31092e3e07bcb23d6a79737693fbe16aa3fb341516cc019ad03967de42e2743bc02bc599b1fc7913ec59c219330a0613ed95c5d08aced246fa65003ee6366f64ccea7f58ff4a734f6a7b4afda0e8401691fa652acfd272cbcb83a47e225360e9080bf055d704625ff17bf89baeff7e25ea35fc1132e16fc81ca061667a2f9d07c81eb6399d40dee8b59aab3bd993331e478508af08cdf1caa51f0fa22cfbff9e694d73e2788913a102b249be3e0665787a84e4cc44e29db8c79623191768babea8ad1f52d5fd535ac03e1d59d35511867feb82dd1a32551376630e3cf549ae36568ff1fdc56cd3c3bde224bef44039be473b65fbda4117a1fc01e325fb13f73fe4455dfc7c0d00b0d01187e55fc85a7b4d1f6ccaebffb8ebc3e6e617108aefb37942023cea0c72b41c85263fbef2a52b9b73429f0a7546ce31a1515342dd0009c7603574065744d0f87b439c2cc207b2607762239cb779442a3db979e4586f04e0d6a6db45b80b6a9274e87f368c1976a509cc9e32c89d2c8159aaff392a15955cfc842556fbb8173f851b875331e4da0b4da59e526155e58558292f08b8a5a0bcf6983d6fbb036f530636e7f349ed0e824fa6f0fa87b38ddebb38f42c5b19d59451185527bee5924e8495c37216eeb7f25d8f71400e230b8a72585889ddd08cfe755a15656edf49a4961aac8b4bc35a494a7b0679b3f244423d3358c9f12921e0f8174aa761f4ff7ff67b46fd25b4f244834b6ba11f751463859a4967ed3ba3633fce0f131143ef9bedb11cfe5f0f390b0a0f863441e95609edb2d06f20cc24dbe07452be3a2ab1820392927cb4bebc506e24161b643b17b9312072e264d60df3386c4c44a919f11131481a9164b17fa99642535c4ef694a18f77d8a9afc372e5ad1049510dfd0a9ce65f9944898eea6fc30e701e13b0d0ead756c8eec17fd387c1adf9299ce238b077ae43d38d88c13aec7cc42f3cc30d7928d3c2867364333d94ef8834a22719e4fe1f7cb133c123628167b9d67bd5afc2f3f9b57d0d750e0e773dfe930656657def8c9b7ffe82bd4bae48298e73597f21925c499970d8fe9fa9470f18efabe1968aa0cbb4fb16589ddc931c2e22aa1798f4c08d77be2027dfb10c242a01979f614ec1735e937cb38bbffd733e83d167e4c95a23722b5a01485d17a7f6e52c6bd620861f3a83f5ce63727b24646194f441b38d9fc05744c9b75d5159128d5492c70a9584f48988195594649adf672714eaaca724db02b956d52b9c6e4751c704b9d5211031e2dba5531a6a62a58585bcdb6c2400a6b7f2fba008c5c81500e21fab804cdd56fa10e3196739f1202facbfff115f82e9d21f5a321dce69a2285ee784aee7bf6e724eb065cd5cae4fc4787fb3815a2e4f8a27ccfbee015960aece86545c5f126373ea908931c86a137c2e387a5a2361ac5de1ffedf8e4eb765516cd2e51cc863b4695f83e051727d4adb0387c6cb13bd8baa5375420ced807ab37e4f9d8c6a267fff077edd1c143fe66ca01ac139b9f4a2dc059ccc3943bde14668258d791919646e71a253fd4cbc95af106d1656dbdf682c08696495db65befe5ef3da621e33300d3fde2d27898ac1cae69226d730ffea17ee6809c3ddd814bafa91cb6737334a96850c9d23ec429cd51524ae3732a8c02e54d7b595324f58b1eafa86e02e67b0efc0cb4e011f8b03891acf453defaf744d9f22c8fb50c90388192214a2184244cbbab9f003e4775562da7aa58881c308f2dc5373999cb8aaf915ab59e85fe9a8733e9fb0c76b8e4e2579688ca8bf42c15c2337ad577013f5bda34ba351c0048ab4b566843fccaebb5179c6cd87f18602afc283f34801dfa1937bb7185d371bcea11d1b1840a74646f2c20ffcb0f2d82c3a86f9739499eba875793008254f32359816a3208a5dcf853a1491b0271e7d8dd68d1a73de7045f17cd2335426462b2d8ed7c1a4c6b44800d4a28ac08042ec28b2a74a3a3a745f449b8c5c0f9c70566e9a82895c3b19f5b763232416c65e79a986f85115c868ef1bff28680545e2e4f693d3239743ac5d3e0ee16c1b774f1f3f7159bdb00784ae75bee8fce30589e548a243767fac173cbf6a436d78fcc788a0a2eaee9676f119ba8cc3e62c2daa0bb5116e02fe8429935df4511cca5d8db2860414bef924d43bd3458e4de747ea8918367df28433f89d1794ead4708d437113e6fef2ce2396ac62d13e687212dafcec18e8f084c5d0f9641f55831abc55eea367a0839e4c08991c0dbe29212b67548d865be986d696abfc5f63e94b193f9974a8d4e8c7fa26cfa8c6429f3491cf4a039c8704f8bbd3640ca3651b4c645d41c8639c97a209886c61c580734bc8fee6081b2b292e4eb485664683c7e82bcf1f7d4d8319f25a83725c0b1291e36'
      console.log('cipherData:', cipherData)
      const cipherBytes = HexUtil.hexToBytes(cipherData)
      const plainBytes = TransportCipherUtil.decryptSync(
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