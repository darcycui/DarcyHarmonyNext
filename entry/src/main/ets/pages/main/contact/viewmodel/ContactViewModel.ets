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
import { BaseViewModel, Log, ScreenPhase } from 'static_library_common';
import { UserResponse, ApplyFriendResponse } from 'library_network';
import ContactState from '../state/ContactState';
import ContactReducer from '../reducer/ContactReducer';
import { SearchUserUseCase, SearchUserParams } from '../usecase/SearchUserUseCase';
import { ApplyFriendUseCase, ApplyFriendParams } from '../usecase/ApplyFriendUseCase';
import { ContactRepository } from '../repository/ContactRepository';
import {
  ContactIntent, SearchUserIntent, ApplyFriendIntent
} from '../intent/ContactIntent';

@ObservedV2
export default class ContactViewModel extends BaseViewModel {
  // ─── 页面统一状态对象（@Trace 实现细粒度刷新） ────────

  /** 统一状态 */
  @Trace state: ContactState = new ContactState();

  // ─── 依赖注入 ──
  private repository: ContactRepository = new ContactRepository();
  private searchUserUseCase: SearchUserUseCase = new SearchUserUseCase(this.repository);
  private applyFriendUseCase: ApplyFriendUseCase = new ApplyFriendUseCase(this.repository);

  // ─── Reducer（负责状态修改） ──────────────────────
  private reducer: ContactReducer = new ContactReducer();

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
   * @param fromUserId - 发起者用户 ID
   * @param toUserId - 目标用户 ID
   */
  async applyFriend(fromUserId: number, toUserId: number): Promise<void> {
    await this.safeLoad(this.state.screenState, async () => {
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
