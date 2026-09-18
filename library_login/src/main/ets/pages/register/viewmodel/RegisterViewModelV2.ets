/**
 * RegisterViewModelV2 - V2 版本的注册 ViewModel
 *
 * 采用 MVI 模式：通过 dispatch(intent) 统一入口
 *
 *  架构特性 
 *   ✅ 继承 BaseViewModel，获得统一的 loading/error 状态管理
 *   ✅ @ObservedV2 + @Trace → 支持细粒度属性追踪
 *   ✅ 通过 UseCase → Repository 分层，ViewModel 不再直接处理数据访问
 *   ✅ MVI dispatch 模式，便于复杂页面状态追踪
 *   ✅ 状态统一封装到 RegisterState，由 RegisterReducer 负责修改
 *
 *  View 层使用示例 
 * ```typescript
 * @Entry
 * @ComponentV2
 * struct RegisterPage {
 *   @Local viewModel: RegisterViewModelV2 = new RegisterViewModelV2();
 * }
 * ```
 *
 *  架构流向 
 *   View (@ComponentV2) → dispatch(intent) → @ObservedV2 ViewModel → UseCase → Repository
 *     → ViewModel 方法委托 Reducer 修改 state
 *     → Reducer 原地修改 @Trace 属性触发 UI 重渲染
 */
import { BaseViewModel, Log } from 'static_library_common';
import RegisterState from '../state/RegisterState';
import RegisterReducer from '../reducer/RegisterReducer';
import { DeleteUserParams, DeleteUserUseCase, RegisterParams, RegisterUseCase } from '../usecase/RegisterUseCase';
import { RegisterRepository } from '../repository/RegisterRepository';
import {
  DeleteUserIntent,
  DoRegisterIntent,
  RegisterIntent,
  UpdateEmailIntent,
  UpdateNicknameIntent,
  UpdatePhoneIntent,
  UpdateRegisterPasswordIntent,
  UpdateRegisterUserNameIntent
} from '../intent/RegisterIntent';
import { IdentityKeyEntity, OneTimePreKeyEntity, SignedPreKeyEntity } from 'library_database';
import { GenerateIdentityKeyUseCase } from '../../../x3dh/usecase/GenerateIdentityKeyUseCase';
import { GenerateSignedPreKeyUseCase } from '../../../x3dh/usecase/GenerateSignedPreKeyUseCase';
import { GenerateOneTimePreKeyUseCase } from '../../../x3dh/usecase/GenerateOneTimePreKeyUseCase';
import { PushX3DHKeysUseCase } from '../../../x3dh/usecase/PushX3DHKeysUseCase';
import { X3DHPushKeysRepository } from '../../../x3dh/repository/X3DHPushKeysRepository';
import ErrorUtil from 'static_library_common/src/main/ets/utils/ErrorUtil';
import { OneTimePreKeyInputDTO, TokenManager } from 'library_network';
import { ServerDHExchangeUseCase } from '../../../dh/usecase/ServerDHExchangeUseCase';
import { ServerDHExchangeRepository } from '../../../dh/repository/ServerDHExchangeRepository';
import { UserManager } from '../../../storage/memory/UserManager';
import { ServerDHSecretManager } from 'library_crypto';

@ObservedV2
export default class RegisterViewModelV2 extends BaseViewModel {
  //  页面统一状态对象（@Trace 实现细粒度刷新） 

  /** 统一状态：封装 userName + password + phone + nickname + email */
  @Trace state: RegisterState = new RegisterState();

  //  UseCase 
  private registerUseCase: RegisterUseCase = new RegisterUseCase(new RegisterRepository());
  /** 删除用户用例 */
  private deleteUserUseCase: DeleteUserUseCase = new DeleteUserUseCase(new RegisterRepository());
  /** DH 密钥交换用例 */
  private serverDHExchangeUseCase: ServerDHExchangeUseCase = new ServerDHExchangeUseCase(new ServerDHExchangeRepository());
  /** X3DH 身份密钥生成用例 */
  private generateIdentityKeyUseCase: GenerateIdentityKeyUseCase = new GenerateIdentityKeyUseCase();
  /** X3DH 预签名密钥生成用例 */
  private generateSignedPreKeyUseCase: GenerateSignedPreKeyUseCase = new GenerateSignedPreKeyUseCase();
  /** X3DH 一次性预密钥生成用例 */
  private generateOneTimePreKeyUseCase: GenerateOneTimePreKeyUseCase = new GenerateOneTimePreKeyUseCase();
  /** X3DH 密钥推送用例 */
  private pushX3DHKeysUseCase: PushX3DHKeysUseCase = new PushX3DHKeysUseCase(new X3DHPushKeysRepository());

  //  Reducer（负责状态修改） 
  private reducer: RegisterReducer = new RegisterReducer();

  //  MVI dispatch 模式（统一入口） 
  /**
   * 重写基类 dispatch 方法
   * 使用 instanceof 根据 intent 类型分发到对应处理方法
   *
   * @param intent - 意图
   */
  async dispatch(intent: RegisterIntent): Promise<void> {
    if (intent instanceof DoRegisterIntent) {
      await this.doRegister()
    } else if (intent instanceof DeleteUserIntent) {
      await this.doDeleteUser()
    } else if (intent instanceof UpdateRegisterUserNameIntent) {
      this.updateUserName(intent.value)
    } else if (intent instanceof UpdateRegisterPasswordIntent) {
      this.updatePassword(intent.value)
    } else if (intent instanceof UpdatePhoneIntent) {
      this.updatePhone(intent.value)
    } else if (intent instanceof UpdateNicknameIntent) {
      this.updateNickname(intent.value)
    } else if (intent instanceof UpdateEmailIntent) {
      this.updateEmail(intent.value)
    } else {
      Log.warn(`[RegisterViewModelV2] 未处理的 Intent: ${intent}`)
    }
  }

  //  业务方法 

  /**
   * 更新用户名
   * 委托 Reducer 修改 RegisterState
   */
  updateUserName(value: string): void {
    this.reducer.updateUserName(this.state, value);
  }

  /**
   * 更新密码
   * 委托 Reducer 修改 RegisterState
   */
  updatePassword(value: string): void {
    this.reducer.updatePassword(this.state, value);
  }

  /**
   * 更新手机号
   * 委托 Reducer 修改 RegisterState
   */
  updatePhone(value: string): void {
    this.reducer.updatePhone(this.state, value);
  }

  /**
   * 更新昵称
   * 委托 Reducer 修改 RegisterState
   */
  updateNickname(value: string): void {
    this.reducer.updateNickname(this.state, value);
  }

  /**
   * 更新邮箱
   * 委托 Reducer 修改 RegisterState
   */
  updateEmail(value: string): void {
    this.reducer.updateEmail(this.state, value);
  }

  /**
   * 执行注册
   * 使用 BaseViewModel.safeLoad 统一管理 loading/error 状态
   */
  async doRegister(): Promise<void> {
    await this.safeLoad(this.state.screenState, async (): Promise<void> => {
      const params: RegisterParams = {
        userName: this.state.userName,
        password: this.state.password,
        phone: this.state.phone,
        nickname: this.state.nickname,
        email: this.state.email
      };
      Log.log(`RegisterViewModelV2 doRegister: ${JSON.stringify(params)}`);
      const result = await this.registerUseCase.execute(params);
      if (result) {
        Log.info(`[RegisterViewModelV2] 注册成功: ${JSON.stringify(result)}`);
        await UserManager.setUser(result)
        await TokenManager.setToken(result.token)
        // 注册成功后，进行 DH 密钥交换
        await this.exchangeDHPublicKey(result.id);
      } else {
        Log.error(`[RegisterViewModelV2] 注册失败: ${JSON.stringify(result)}`);
      }
    });
  }

  /**
   * 执行删除用户
   * 使用 BaseViewModel.safeLoad 统一管理 loading/error 状态
   */
  async doDeleteUser(): Promise<void> {
    await this.safeLoad(this.state.screenState, async (): Promise<void> => {
      const user = await UserManager.getUser();
      const params: DeleteUserParams = {
        userId: user.id,
        userName: this.state.userName,
        phone: this.state.phone
      };
      Log.log(`RegisterViewModelV2 doDeleteUser: ${JSON.stringify(params)}`);
      const result = await this.deleteUserUseCase.execute(params);
      if (result) {
        Log.info(`[RegisterViewModelV2] 删除用户成功: ${JSON.stringify(result)}`);
        await UserManager.clearUser();
        await TokenManager.clearToken()
        await ServerDHSecretManager.clearDHSecret()
      } else {
        Log.error(`[RegisterViewModelV2] 删除用户失败: ${JSON.stringify(result)}`);
      }
    });
  }

  private async exchangeDHPublicKey(userId: number) {
    try {
      await this.serverDHExchangeUseCase.execute({ userId: userId });
      Log.info(`[LoginRepository] DH 密钥交换成功`);
      // DH 密钥交换成功后 初始化预密钥数据库并持久化
      await this.pushX3DHKeys(userId);
    } catch (dhError) {
      Log.error(`[LoginRepository] DH 密钥交换失败: ${dhError}`);
    }
  }

  private async pushX3DHKeys(userId: number) {
    try {
      const tripleCache = await this.generateX3DHKeys(userId);
      const identityKey = tripleCache[0];
      const signedPreKey = tripleCache[1];
      const oneTimePreKeyDTOList = tripleCache[2];
      await this.pushX3DHKeysUseCase.execute({
        userId: userId,
        identityKey: identityKey.publicKey,
        signedPreKey: signedPreKey.publicKey,
        oneTimePreKeys: oneTimePreKeyDTOList
      });
      Log.info(`[RegisterViewModelV2] 推送 X3DH 密钥成功`);
    } catch (err) {
      Log.error(`[RegisterViewModelV2] 预密钥持久化失败: ${err}`);
    }
  }

  //  X3DH密钥持久化
  /**
   * 在注册 & DH 交换完成后，初始化预密钥数据库并持久化预密钥数据
   *
   * @param userId 已注册用户的 ID
   */
  private async generateX3DHKeys(userId: number): Promise<[IdentityKeyEntity, SignedPreKeyEntity, OneTimePreKeyInputDTO[]]> {
    try {
      const identityKey = await this.generateIdentityKeyUseCase.execute({ userId: userId });
      const signedPreKey = await this.generateSignedPreKeyUseCase.execute({ userId: userId, identityKeyId: identityKey.keyId });
      const oneTimePreKeyList = await this.generateOneTimePreKeyUseCase.execute({ userId: userId });

      // 推送 X3DH 密钥到服务端
      const oneTimePreKeyDTOList: OneTimePreKeyInputDTO[] = oneTimePreKeyList.map((oneTimePreKey: OneTimePreKeyEntity) => new OneTimePreKeyInputDTO({
        id: oneTimePreKey.id,
        keyId: oneTimePreKey.keyId,
        userId: oneTimePreKey.userId,
        publicKey: oneTimePreKey.publicKey
      }));

      return [identityKey, signedPreKey, oneTimePreKeyDTOList];
    } catch (err) {
      Log.error(`[RegisterViewModelV2] X3DH 密钥持久化失败: ${ErrorUtil.getErrorMessage(err)}`);
      throw new Error(`[RegisterViewModelV2] X3DH 密钥持久化失败: ${JSON.stringify(err)}`)
    }
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
    this.state.screenState.reset();
    this.resetInitialized();
  }
}
