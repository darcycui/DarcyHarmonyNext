/**
 * ServerDHExchangeUseCase - 服务端 DH 密钥交换业务用例
 *
 * 职责：
 *  - 编排 DH 密钥交换的完整业务流程
 *  - 生成 X25519 密钥对 → 发起 DH 交换请求 → 协商共享密钥 → 存储到 DHSecretManager
 *  - 在注册成功或登录成功后触发调用
 *
 * 架构流向：
 *   ViewModel → ServerDHExchangeUseCase → ServerDHExchangeRepository → httpHelper.doPost
 *
 * 使用示例：
 * ```typescript
 * const useCase = new ServerDHExchangeUseCase(repository);
 * await useCase.execute({ userId: 123 });
 * ```
 */
import { BaseUseCase, HexUtil } from 'static_library_common';
import { DHExchangeUtil } from 'library_crypto';
import {
  DHExchangeRequestDTO,
  DHExchangeResponse,
  Base64Util,
  DHSecretManager
} from 'library_network';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { ServerDHExchangeRepository } from '../repository/ServerDHExchangeRepository';

/**
 * 服务端 DH 密钥交换用例入参
 */
export interface ServerDHExchangeParams {
  /** 用户 ID（来自注册或登录响应） */
  userId: number;
}

/**
 * 执行服务端 DH 密钥交换用例
 * 入参：ServerDHExchangeParams
 * 出参：void（共享密钥已通过 DHSecretManager 存储）
 */
export class ServerDHExchangeUseCase extends BaseUseCase<ServerDHExchangeParams, void> {
  private repository: ServerDHExchangeRepository;

  constructor(repository: ServerDHExchangeRepository) {
    super();
    this.repository = repository;
  }

  async execute(params: ServerDHExchangeParams): Promise<void> {
    // 1. 校验：userId 必须有效
    if (!params.userId || params.userId <= 0) {
      throw new Error('无效的用户 ID');
    }

    // 2. 生成 X25519 密钥对
    const keyPair: cryptoFramework.KeyPair | null = await DHExchangeUtil.generateKeyPair();
    if (keyPair == null) {
      throw new Error('生成 DH 密钥对失败');
    }

    // 3. 提取公钥字节并编码为 Base64
    const pubKeyBytes: Uint8Array = DHExchangeUtil.getKeyBytes(keyPair.pubKey);
    if (pubKeyBytes.length === 0) {
      throw new Error('获取公钥字节失败');
    }
    const publicKeyBase64: string = Base64Util.base64Encode(pubKeyBytes);

    // 4. 调用服务端 DH 交换接口
    const response: DHExchangeResponse = await this.repository.doExchange(
      params.userId,
      publicKeyBase64
    );

    // 5. 校验响应中的服务端公钥
    if (!response.publicKey) {
      throw new Error('服务端返回的公钥为空');
    }

    // 6. 解码服务端公钥（Hex → Uint8Array → PubKey）
    const serverPubKeyBytes: Uint8Array = HexUtil.hexToBytes(response.publicKey);
    const serverPubKey: cryptoFramework.PubKey | null = DHExchangeUtil.createPubKey(serverPubKeyBytes);
    if (serverPubKey == null) {
      throw new Error('还原服务端公钥失败');
    }

    // 7. 协商共享密钥
    const sharedSecret: Uint8Array | null = await DHExchangeUtil.agreeSharedSecret(
      keyPair.priKey,
      serverPubKey
    );
    if (sharedSecret == null || sharedSecret.length === 0) {
      throw new Error('DH 密钥协商失败');
    }

    // 8. 将共享密钥编码为 hexStr 并存储到 DHSecretManager
    const sharedSecretBase64: string = HexUtil.bytesToHex(sharedSecret);
    await DHSecretManager.setDHSecret(sharedSecretBase64);
  }
}
