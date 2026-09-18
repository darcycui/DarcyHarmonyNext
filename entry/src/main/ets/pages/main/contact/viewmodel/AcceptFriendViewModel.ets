/**
 * AcceptFriendViewModel - 好友申请页面 ViewModel
 *
 * 展示 V2 版本的 MVVM 架构：@ObservedV2 + @Trace + MVI dispatch
 *
 * 架构流向：
 *   View (@ComponentV2)
 *     → ViewModel (@ObservedV2) 持有 @Trace state: AcceptFriendState
 *     → ViewModel 方法委托 Reducer 修改 state
 *     → Reducer 原地修改 @Trace 属性触发 UI 重渲染
 *
 * 同意好友流程（Bob 端 X3DH）：
 *   1. PullAliceHelloUseCase - 拉取 Alice Hello
 *   2. CalculateBobX3DHKeyUseCase - 计算 Bob X3DH 密钥
 *   3. SaveBobSessionRecordUseCase - 保存会话记录到数据库
 *   4. AcceptFriendRequestUseCase - 同意好友请求 HTTP
 */
import { BaseViewModel, Log, ScreenPhase, HexUtil } from 'static_library_common';
import { ApplyFriendResponse } from 'library_network';
import AcceptFriendState from '../state/AcceptFriendState';
import AcceptFriendReducer from '../reducer/AcceptFriendReducer';
import { QueryFriendRequestsToMeUseCase, QueryFriendRequestsParams } from '../usecase/QueryFriendRequestsToMeUseCase';
import { AcceptFriendRequestUseCase, AcceptFriendRequestParams } from '../usecase/AcceptFriendRequestUseCase';
import { ContactRepository } from '../repository/ContactRepository';
import {
  AcceptFriendBaseIntent, QueryFriendRequestsIntent, AcceptFriendIntent
} from '../intent/AcceptFriendIntent';
import { PullAliceHelloUseCase, PullAliceHelloParams } from '../../../../x3dh/usecase/PullAliceHelloUseCase';
import { CalculateBobX3DHKeyUseCase, CalculateBobX3DHKeyParams } from '../../../../x3dh/usecase/CalculateBobX3DHKeyUseCase';
import { SaveBobSessionRecordUseCase, SaveBobSessionRecordParams } from '../../../../x3dh/usecase/SaveBobSessionRecordUseCase';
import { AliceHelloRepository } from '../../../../x3dh/repository/AliceHelloRepository';
import { UserManager } from 'library_login';

@ObservedV2
export default class AcceptFriendViewModel extends BaseViewModel {
  // ─── 页面统一状态对象（@Trace 实现细粒度刷新） ────────

  /** 统一状态 */
  @Trace state: AcceptFriendState = new AcceptFriendState();

  // ─── 依赖注入 ──
  private repository: ContactRepository = new ContactRepository();
  private queryFriendRequestsUseCase: QueryFriendRequestsToMeUseCase = new QueryFriendRequestsToMeUseCase(this.repository);
  private acceptFriendRequestUseCase: AcceptFriendRequestUseCase = new AcceptFriendRequestUseCase(this.repository);
  private pullAliceHelloUseCase: PullAliceHelloUseCase = new PullAliceHelloUseCase(new AliceHelloRepository());
  private calculateBobX3DHKeyUseCase: CalculateBobX3DHKeyUseCase = new CalculateBobX3DHKeyUseCase();
  private saveBobSessionRecordUseCase: SaveBobSessionRecordUseCase = new SaveBobSessionRecordUseCase();

  // ─── Reducer（负责状态修改） ──────────────────────
  private reducer: AcceptFriendReducer = new AcceptFriendReducer();

  // ─── MVI dispatch 模式（统一入口） ────────────
  /**
   * 重写基类 dispatch 方法
   * 使用 instanceof 根据 intent 类型分发到对应处理方法
   *
   * @param intent - 意图
   */
  async dispatch(intent: AcceptFriendBaseIntent): Promise<void> {
    if (intent instanceof QueryFriendRequestsIntent) {
      await this.queryFriendRequests();
    } else if (intent instanceof AcceptFriendIntent) {
      await this.acceptFriend(intent.friendRequestId, intent.remoteUserId);
    } else {
      Log.warn(`[AcceptFriendViewModel] 未处理的 Intent: ${intent}`);
    }
  }

  // ─── 业务方法 ────────────────────────────────────

  /**
   * 页面初始化加载好友请求列表
   */
  protected async doLoad(): Promise<void> {
    await this.queryFriendRequests();
  }

  /**
   * 查询发给我的好友请求
   */
  async queryFriendRequests(): Promise<void> {
    await this.safeLoad(this.state.screenState, async () => {
      const currentUserId = await UserManager.getUserID();
      Log.info(`[AcceptFriendViewModel] 查询好友请求: toUserId=${currentUserId}`);
      const params: QueryFriendRequestsParams = { toUserId: currentUserId };
      const result: ApplyFriendResponse[] = await this.queryFriendRequestsUseCase.execute(params);
      Log.info(`[AcceptFriendViewModel] 查询好友请求成功: ${result.length} 条`);
      this.reducer.setFriendRequests(this.state, result);
      this.state.screenState.phase = ScreenPhase.SUCCESS;
    });
  }

  /**
   * 同意好友请求
   *
   * 流程：拉取 Alice Hello → 计算 Bob X3DH 密钥 → 保存 session record → 同意好友请求
   *
   * @param friendRequestId - 好友请求 ID
   * @param remoteUserId - 对方用户 ID（Alice）
   */
  async acceptFriend(friendRequestId: number, remoteUserId: number): Promise<void> {
    await this.safeLoad(this.state.screenState, async () => {
      const localUserId = await UserManager.getUserID();
      Log.info(`[AcceptFriendViewModel] 开始同意好友请求: friendRequestId=${friendRequestId}, alice=${remoteUserId}, bob=${localUserId}`);

      // 1. 拉取 Alice Hello
      Log.info(`[AcceptFriendViewModel] 1. 拉取 Alice Hello: alice=${remoteUserId}, bob=${localUserId}`);
      const pullParams: PullAliceHelloParams = { aliceUserId: remoteUserId, bobUserId: localUserId };
      const aliceHello = await this.pullAliceHelloUseCase.execute(pullParams);
      Log.info(`[AcceptFriendViewModel] 拉取 Alice Hello 成功: aliceIdentityKey=${aliceHello.aliceIdentityKey}`);

      // 2. 计算 Bob X3DH 密钥
      Log.info(`[AcceptFriendViewModel] 2. 计算 Bob X3DH 密钥`);
      const calculateParams: CalculateBobX3DHKeyParams = {
        bobUserId: localUserId,
        aliceIdentityKey: aliceHello.aliceIdentityKey,
        aliceEphemeralKey: aliceHello.aliceEphemeralKey,
        bobOneTimePreKeyId: aliceHello.bobOneTimePreKeyId,
      };
      const x3DHKey = await this.calculateBobX3DHKeyUseCase.execute(calculateParams);
      if (!x3DHKey || x3DHKey.length === 0) {
        throw new Error('计算 BobX3DHKey 失败');
      }
      Log.info(`[AcceptFriendViewModel] 计算 BobX3DHKey 成功`);

      // 3. 保存 session record 到数据库
      Log.info(`[AcceptFriendViewModel] 3. 保存 session record 到数据库`);
      const saveParams: SaveBobSessionRecordParams = {
        localUserId: localUserId,
        remoteUserId: remoteUserId,
        bobX3DHKey: HexUtil.bytesToHex(x3DHKey),
        aliceIdentityKey: aliceHello.aliceIdentityKey,
        aliceEphemeralKey: aliceHello.aliceEphemeralKey,
      };
      const saveResult = await this.saveBobSessionRecordUseCase.execute(saveParams);
      if (!saveResult) {
        throw new Error('保存 SessionRecord 到数据库失败');
      }
      Log.info(`[AcceptFriendViewModel] 保存 sessionRecord 成功`);

      // 4. 同意好友请求 HTTP
      Log.info(`[AcceptFriendViewModel] 4. 同意好友请求: friendRequestId=${friendRequestId}`);
      const acceptParams: AcceptFriendRequestParams = { friendRequestId };
      await this.acceptFriendRequestUseCase.execute(acceptParams);
      Log.info(`[AcceptFriendViewModel] 同意好友请求成功`);

      // 5. 刷新好友请求列表;
      await this.queryFriendRequests();
    });
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
