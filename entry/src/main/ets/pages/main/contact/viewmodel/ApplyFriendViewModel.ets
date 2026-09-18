/**
 * ContactViewModel - 联系人页面 ViewModel
 *
 * 展示 V2 版本的 MVVM 架构：@ObservedV2 + @Trace + MVI dispatch
 *
 * 架构流向：
 *   View (@ComponentV2)
 *     → ViewModel (@ObservedV2) 持有 @Trace state: ContactState
 *     → ViewModel 方法委托 Reducer 修改 state
 *     → Reducer 原地修改 @Trace 属性触发 UI 重渲染
 */
import { BaseViewModel, Log, ScreenPhase, HexUtil } from 'static_library_common';
import { UserResponse, ApplyFriendResponse } from 'library_network';
import ApplyFriendState from '../state/ApplyFriendState';
import ApplyFriendReducer from '../reducer/ApplyFriendReducer';
import { SearchUserUseCase, SearchUserParams } from '../usecase/SearchUserUseCase';
import { ApplyFriendUseCase, ApplyFriendParams } from '../usecase/ApplyFriendUseCase';
import { QueryFriendRequestsFromMeUseCase, QueryFriendRequestsFromMeParams } from '../usecase/QueryFriendRequestsFromMeUseCase';
import { ContactRepository } from '../repository/ContactRepository';
import {
  ContactIntent, SearchUserIntent, ApplyFriendIntent,
  QuerySentFriendRequestsIntent, ToggleViewModeIntent
} from '../intent/ApplyFriendIntent';
import { PullX3DHKeysUseCase, PullX3DHKeysParams } from '../../../../x3dh/usecase/PullX3DHKeysUseCase';
import { CalculateAliceX3DHKeyUseCase, CalculateAliceX3DHKeyParams } from '../../../../x3dh/usecase/CalculateAliceX3DHKeyUseCase';
import { SaveAliceSessionRecordUseCase, SaveAliceSessionRecordParams } from '../../../../x3dh/usecase/SaveAliceSessionRecordUseCase';
import { PushAliceHelloUseCase, PushAliceHelloParams } from '../../../../x3dh/usecase/PushAliceHelloUseCase';
import { X3DHPullKeysRepository } from '../../../../x3dh/repository/X3DHPullKeysRepository';
import { AliceHelloRepository } from '../../../../x3dh/repository/AliceHelloRepository';
import { DarcyIMDatabase } from 'library_database';
import { ECCExchangeUtil } from 'library_crypto';
import { UserManager } from 'library_login';

@ObservedV2
export default class ApplyFriendViewModel extends BaseViewModel {
  // ─── 页面统一状态对象（@Trace 实现细粒度刷新） ────────

  /** 统一状态 */
  @Trace state: ApplyFriendState = new ApplyFriendState();

  // ─── 依赖注入 ──
  private repository: ContactRepository = new ContactRepository();
  private searchUserUseCase: SearchUserUseCase = new SearchUserUseCase(this.repository);
  private applyFriendUseCase: ApplyFriendUseCase = new ApplyFriendUseCase(this.repository);
  private querySentFriendRequestsUseCase: QueryFriendRequestsFromMeUseCase = new QueryFriendRequestsFromMeUseCase(this.repository);
  private pullX3DHKeysUseCase: PullX3DHKeysUseCase = new PullX3DHKeysUseCase(new X3DHPullKeysRepository());
  private calculateAliceX3DHKeyUseCase: CalculateAliceX3DHKeyUseCase = new CalculateAliceX3DHKeyUseCase();
  private saveAliceSessionRecordUseCase: SaveAliceSessionRecordUseCase = new SaveAliceSessionRecordUseCase();
  private pushAliceHelloUseCase: PushAliceHelloUseCase = new PushAliceHelloUseCase(new AliceHelloRepository());
  private identityKeyDao = DarcyIMDatabase.getInstance().getIdentityKeyDao();

  // ─── Reducer（负责状态修改） ──────────────────────
  private reducer: ApplyFriendReducer = new ApplyFriendReducer();

  // ─── MVI dispatch 模式（统一入口） ────────────
  /**
   * 重写基类 dispatch 方法
   * 使用 instanceof 根据 intent 类型分发到对应处理方法
   *
   * @param intent - 意图
   */
  async dispatch(intent: ContactIntent): Promise<void> {
    if (intent instanceof SearchUserIntent) {
      await this.searchUser(intent.phone);
    } else if (intent instanceof ApplyFriendIntent) {
      await this.applyFriend(intent.fromUserId, intent.toUserId);
    } else if (intent instanceof QuerySentFriendRequestsIntent) {
      await this.querySentFriendRequests();
    } else if (intent instanceof ToggleViewModeIntent) {
      this.toggleViewMode();
    } else {
      Log.warn(`[ContactViewModel] 未处理的 Intent: ${intent}`);
    }
  }

  // ─── 业务方法 ────────────────────────────────────

  /**
   * 根据手机号搜索用户
   *
   * @param phone - 手机号
   */
  async searchUser(phone: string): Promise<void> {
    await this.safeLoad(this.state.screenState, async () => {
      const params: SearchUserParams = { phone };
      const result: UserResponse = await this.searchUserUseCase.execute(params);
      Log.info(`[ContactViewModel] 搜索用户成功: ${result.username}`);
      this.reducer.setSearchResults(this.state, [result]);
    });
  }

  /**
   * 申请添加好友
   *
   * 流程：拉取 Bob X3DH 密钥 → 计算 Alice X3DH 密钥 → 保存 session record → 推送 Alice Hello → 申请好友
   *
   * @param fromUserId - 发起者用户 ID
   * @param toUserId - 目标用户 ID
   */
  async applyFriend(fromUserId: number, toUserId: number): Promise<void> {
    await this.safeLoad(this.state.screenState, async () => {
      // 1. 拉取 Bob 的 X3DH 密钥
      Log.info(`[ApplyFriendViewModel] 1. 拉取 Bob 的 X3DH 密钥: alice=${fromUserId}, bob=${toUserId}`);
      const pullParams: PullX3DHKeysParams = { aliceUserId: fromUserId, bobUserId: toUserId };
      const bobKeys = await this.pullX3DHKeysUseCase.execute(pullParams);
      Log.info(`[ApplyFriendViewModel] 拉取 BobKeys 成功: identityKey=${bobKeys.identityKey}`);

      // 2. 计算 Alice X3DH 密钥
      Log.info(`[ApplyFriendViewModel] 2. 计算 Alice X3DH 密钥`);
      const calculateParams: CalculateAliceX3DHKeyParams = {
        aliceUserId: fromUserId,
        bobUserId: toUserId,
        bobKeys: JSON.stringify(bobKeys)
      };
      const calculateResult = await this.calculateAliceX3DHKeyUseCase.execute(calculateParams);
      const x3DHKey = calculateResult.x3DHKey;
      const aliceEphemeralKey = calculateResult.aliceEphemeralKey;
      if (!x3DHKey || !aliceEphemeralKey) {
        throw new Error('计算 AliceX3DHKey 失败');
      }
      Log.info(`[ApplyFriendViewModel] 计算 AliceX3DHKey 成功`);

      // 3. 保存 session record 到数据库
      Log.info(`[ApplyFriendViewModel] 3. 保存 session record 到数据库`);
      const saveParams: SaveAliceSessionRecordParams = {
        aliceUserId: fromUserId,
        bobUserId: toUserId,
        aliceX3DHKey: HexUtil.bytesToHex(x3DHKey),
        aliceEphemeralPrivateKey: HexUtil.bytesToHex(ECCExchangeUtil.getKeyBytes(aliceEphemeralKey.priKey)),
        aliceEphemeralPublicKey: HexUtil.bytesToHex(ECCExchangeUtil.getKeyBytes(aliceEphemeralKey.pubKey)),
        bobSignedPreKey: bobKeys.signedPreKey,
        bobIdentityKey: bobKeys.identityKey,
      };
      const saveResult = await this.saveAliceSessionRecordUseCase.execute(saveParams);
      if (!saveResult) {
        throw new Error('保存 sessionRecord 到数据库失败');
      }
      Log.info(`[ApplyFriendViewModel] 保存 sessionRecord 成功`);

      // 4. 获取 Alice 身份公钥
      Log.info(`[ApplyFriendViewModel] 4. 获取 Alice 身份公钥`);
      const identityKeys = await this.identityKeyDao.getByUserId(fromUserId);
      if (!identityKeys || identityKeys.length === 0) {
        throw new Error('Alice 身份密钥不存在');
      }
      const aliceIdentityPublicKey = identityKeys[0].publicKey;

      // 5. 推送 Alice Hello
      Log.info(`[ApplyFriendViewModel] 5. 推送 Alice Hello`);
      const pushParams: PushAliceHelloParams = {
        aliceUserId: fromUserId,
        bobUserId: toUserId,
        aliceIdentityKey: aliceIdentityPublicKey,
        aliceEphemeralKey: HexUtil.bytesToHex(ECCExchangeUtil.getKeyBytes(aliceEphemeralKey.pubKey)),
        bobOneTimePreKeyId: bobKeys.oneTimePreKeyId,
      };
      await this.pushAliceHelloUseCase.execute(pushParams);
      Log.info(`[ApplyFriendViewModel] 推送 Alice Hello 成功`);

      // 6. 申请好友
      Log.info(`[ApplyFriendViewModel] 6. 申请好友`);
      const params: ApplyFriendParams = { fromUserId, toUserId };
      const result: ApplyFriendResponse = await this.applyFriendUseCase.execute(params);
      Log.info(`[ContactViewModel] 申请好友成功: status=${result.status}`);
      this.state.screenState.phase = ScreenPhase.SUCCESS;
    });
  }

  /**
   * 更新搜索手机号
   *
   * @param value - 新手机号
   */
  updateSearchPhone(value: string): void {
    this.reducer.updateSearchPhone(this.state, value);
  }

  /**
   * 查询我发出的好友请求列表
   */
  async querySentFriendRequests(): Promise<void> {
    await this.safeLoad(this.state.screenState, async () => {
      const currentUserId = await UserManager.getUserID();
      Log.info(`[ApplyFriendViewModel] 查询我发出的好友请求: fromUserId=${currentUserId}`);
      const params: QueryFriendRequestsFromMeParams = { fromUserId: currentUserId };
      const result: ApplyFriendResponse[] = await this.querySentFriendRequestsUseCase.execute(params);
      Log.info(`[ApplyFriendViewModel] 查询我发出的好友请求成功: ${result.length} 条`);
      this.reducer.setSentFriendRequests(this.state, result);
      this.reducer.setShowSentRequests(this.state, true);
    });
  }

  /**
   * 切换视图模式（搜索用户 ↔ 已发送的好友请求）
   */
  toggleViewMode(): void {
    this.reducer.toggleViewMode(this.state);
  }

  /**
   * 重置错误状态
   */
  clearError(): void {
    this.state.screenState.reset();
  }

  /**
   * 重置 ViewModel 到初始状态
   */
  reset(): void {
    this.reducer.clearFields(this.state);
    this.state.screenState.reset();
    this.resetInitialized();
  }
}
