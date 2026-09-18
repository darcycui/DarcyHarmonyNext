/**
 * SaveAliceSessionRecordUseCase - 保存 Alice 端会话记录
 *
 * 职责：
 *  - Alice 完成 X3DH 密钥协商后，保存初始会话记录
 *  - 分割 x3DHKey 为根密钥和接收链密钥
 *
 * 架构流向：
 *   ViewModel → SaveAliceSessionRecordUseCase → SessionRecordDao + EncryptUtil
 */
import { BaseUseCase } from 'static_library_common';
import { Log } from 'static_library_common';
import { HexUtil } from 'static_library_common';
import { DarcyIMDatabase, SessionRecordEntity } from 'library_database';
import { EncryptUtil } from 'library_crypto';

/**
 * 保存 Alice 会话记录入参
 */
export interface SaveAliceSessionRecordParams {
  /** Alice 用户 ID */
  aliceUserId: number;
  /** Bob 用户 ID */
  bobUserId: number;
  /** X3DH 密钥（hex 字符串，128 字符 = 64 字节） */
  aliceX3DHKey: string;
  /** Alice 临时私钥（hex 字符串） */
  aliceEphemeralPrivateKey: string;
  /** Alice 临时公钥（hex 字符串） */
  aliceEphemeralPublicKey: string;
  /** Bob 签名预公钥（hex 字符串） */
  bobSignedPreKey: string;
  /** Bob 身份公钥（hex 字符串） */
  bobIdentityKey: string;
}

/**
 * 保存 Alice 端会话记录
 *
 * 返回 boolean：是否成功
 */
export class SaveAliceSessionRecordUseCase extends BaseUseCase<SaveAliceSessionRecordParams, boolean> {

  async execute(params: SaveAliceSessionRecordParams): Promise<boolean> {
    const sessionRecordDao = await DarcyIMDatabase.getInstance().getSessionRecordDao();
    try {
      const localUserId = params.aliceUserId;
      const remoteUserId = params.bobUserId;
      const x3DHKeyStr = params.aliceX3DHKey;
      const aliceEphemeralPrivateKey = params.aliceEphemeralPrivateKey;
      const aliceEphemeralPublicKey = params.aliceEphemeralPublicKey;
      const bobSignedPreKey = params.bobSignedPreKey;
      const bobIdentityKey = params.bobIdentityKey;

      // 校验参数
      if (!localUserId) throw new Error('aliceUserId 不能为空');
      if (!remoteUserId) throw new Error('bobUserId 不能为空');
      if (!x3DHKeyStr) throw new Error('x3DHKey 不能为空');
      if (!aliceEphemeralPrivateKey) throw new Error('aliceEphemeralPrivateKey 不能为空');
      if (!aliceEphemeralPublicKey) throw new Error('aliceEphemeralPublicKey 不能为空');
      if (!bobSignedPreKey) throw new Error('bobSignedPreKey 不能为空');
      if (!bobIdentityKey) throw new Error('bobIdentityKey 不能为空');

      // 分割 x3DHKey: [根密钥(32B), 接收链密钥(32B)]
      const pairAlice = EncryptUtil.splitArray64(HexUtil.hexToBytes(x3DHKeyStr), 32);
      const K1 = pairAlice[0]; // 根密钥
      const K2 = pairAlice[1]; // 接收链密钥

      // 删除旧记录
      const existing = await sessionRecordDao.getByUserPair(localUserId, remoteUserId);
      if (existing) {
        await sessionRecordDao.deleteById(existing.id);
      }

      // 插入新会话记录
      await sessionRecordDao.insert(
        new SessionRecordEntity(
          undefined,
          localUserId,
          remoteUserId,
          bobIdentityKey,
          bobSignedPreKey, // 第一个 DH 密钥使用 Bob 的 SignedPreKey
          aliceEphemeralPrivateKey,
          aliceEphemeralPublicKey,
          HexUtil.bytesToHex(K1),
          '', // Alice 发送链密钥初始为空
          HexUtil.bytesToHex(K2),
          0,
          0,
          0,
          Date.now().toString(),
          Date.now().toString(),
        ),
      );

      Log.log(`保存 Alice 会话记录成功: local=$localUserId, remote=$remoteUserId`);
      return true;
    } catch (error) {
      Log.error(`SaveAliceSessionRecordUseCase 异常: ${JSON.stringify(error)}`);
      return false;
    }
  }
}
