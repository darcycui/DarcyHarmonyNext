/**
 * SaveBobSessionRecordUseCase - 保存 Bob 端会话记录
 *
 * 职责：
 *  - Bob 完成 X3DH 密钥协商后，保存初始会话记录
 *  - 分割 x3DHKey 为根密钥和发送链密钥
 *
 * 架构流向：
 *   ViewModel → SaveBobSessionRecordUseCase → SessionRecordDao + IdentityKeyDao + SignedPreKeyDao + EncryptUtil
 */
import { BaseUseCase } from 'static_library_common';
import { Log } from 'static_library_common';
import { HexUtil } from 'static_library_common';
import { DarcyIMDatabase, SessionRecordEntity } from 'library_database';
import { EncryptUtil } from 'library_crypto';

/**
 * 保存 Bob 会话记录入参
 */
export interface SaveBobSessionRecordParams {
  /** Bob 用户 ID（本地用户） */
  localUserId: number;
  /** Alice 用户 ID（远程用户） */
  remoteUserId: number;
  /** X3DH 密钥（hex 字符串，128 字符 = 64 字节） */
  bobX3DHKey: string;
  /** Alice 身份公钥（hex 字符串） */
  aliceIdentityKey: string;
  /** Alice 临时公钥（hex 字符串） */
  aliceEphemeralKey: string;
}

/**
 * 保存 Bob 端会话记录
 *
 * 返回 boolean：是否成功
 */
export class SaveBobSessionRecordUseCase extends BaseUseCase<SaveBobSessionRecordParams, boolean> {
  private identityKeyDao = DarcyIMDatabase.getInstance().getIdentityKeyDao();
  private signedPreKeyDao = DarcyIMDatabase.getInstance().getSignedPreKeyDao();
  private sessionRecordDao = DarcyIMDatabase.getInstance().getSessionRecordDao();

  async execute(params: SaveBobSessionRecordParams): Promise<boolean> {
    try {
      const localUserId = params.localUserId;
      const remoteUserId = params.remoteUserId;
      const x3DHKeyStr = params.bobX3DHKey;
      const aliceIdentityKey = params.aliceIdentityKey;
      const aliceEphemeralKey = params.aliceEphemeralKey;

      // 校验参数
      if (!localUserId) throw new Error('localUserId 不能为空');
      if (!remoteUserId) throw new Error('remoteUserId 不能为空');
      if (!x3DHKeyStr) throw new Error('x3DHKey 不能为空');
      if (!aliceIdentityKey) throw new Error('aliceIdentityKey 不能为空');
      if (!aliceEphemeralKey) throw new Error('aliceEphemeralKey 不能为空');

      // 获取 Bob 本地密钥
      const identityKeys = await this.identityKeyDao.getByUserId(localUserId);
      if (identityKeys.length === 0) {
        throw new Error('bobIdentityKey 不存在');
      }

      const signedPreKeys = await this.signedPreKeyDao.getByUserId(localUserId);
      if (signedPreKeys.length === 0) {
        throw new Error('bobSignedPreKey 不存在');
      }
      const bobSignedPreKey = signedPreKeys[0];

      // 分割 x3DHKey: [根密钥(32B), 发送链密钥(32B)]
      const pairBob = EncryptUtil.splitArray64(HexUtil.hexToBytes(x3DHKeyStr), 32);
      const K1 = pairBob[0]; // 根密钥
      const K2 = pairBob[1]; // 发送链密钥

      // 删除旧记录
      const existing = await this.sessionRecordDao.getByUserPair(localUserId, remoteUserId);
      if (existing) {
        await this.sessionRecordDao.deleteById(existing.id);
      }

      // 插入新会话记录
      await this.sessionRecordDao.insert(
        new SessionRecordEntity(
          undefined,
          localUserId,
          remoteUserId,
          aliceIdentityKey,
          aliceEphemeralKey,
          bobSignedPreKey.privateKey,
          bobSignedPreKey.publicKey,
          HexUtil.bytesToHex(K1),
          HexUtil.bytesToHex(K2),
          '', // Bob 接收链密钥初始为空
          0,
          0,
          0,
          Date.now().toString(),
          Date.now().toString(),
        ),
      );

      Log.log(`保存 Bob 会话记录成功: local=$localUserId, remote=$remoteUserId`);
      return true;
    } catch (error) {
      Log.error(`SaveBobSessionRecordUseCase 异常: ${JSON.stringify(error)}`);
      return false;
    }
  }
}
