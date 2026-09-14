// ============================================================
// library_login 导出声明
// 鸿蒙Next静态库(HAR) - 登录注册模块
// ============================================================

// ---------- HTTP Utils ----------
export { Urls } from './src/main/ets/http/Urls'

// ---------- DH Key Exchange ----------
export { ServerDHExchangeRepository } from './src/main/ets/dh/repository/ServerDHExchangeRepository'
export { ServerDHExchangeUseCase } from './src/main/ets/dh/usecase/ServerDHExchangeUseCase'

// ---------- Key Generation UseCases ----------
export { GenerateIdentityKeyUseCase, GenerateIdentityKeyParams } from './src/main/ets/x3dh/usecase/GenerateIdentityKeyUseCase'
export { GenerateSignedPreKeyUseCase, GenerateSignedPreKeyParams } from './src/main/ets/x3dh/usecase/GenerateSignedPreKeyUseCase'
export { GenerateOneTimePreKeyUseCase, GenerateOneTimePreKeyParams } from './src/main/ets/x3dh/usecase/GenerateOneTimePreKeyUseCase'

// ---------- X3DH Keys Pull ----------
export { X3DHKeysRepository } from './src/main/ets/x3dh/repository/X3DHKeysRepository'
export { PullX3DHKeysUseCase, PullX3DHKeysParams } from './src/main/ets/x3dh/usecase/PullX3DHKeysUseCase'

// ---------- X3DH Keys Push ----------
export { X3DHPushKeysRepository } from './src/main/ets/x3dh/repository/X3DHPushKeysRepository'
export { PushX3DHKeysUseCase, PushX3DHKeysParams } from './src/main/ets/x3dh/usecase/PushX3DHKeysUseCase'

// ---------- Login ----------
export { default as LoginState } from './src/main/ets/pages/login/state/LoginState'
export { LoginIntent, DoLoginIntent, UpdateUserNameIntent, UpdatePasswordIntent } from './src/main/ets/pages/login/intent/LoginIntent'
export { default as LoginReducer } from './src/main/ets/pages/login/reducer/LoginReducer'
export { LoginRepository } from './src/main/ets/pages/login/repository/LoginRepository'
export { LoginUseCase } from './src/main/ets/pages/login/usecase/LoginUseCase'
export { default as LoginViewModelV2 } from './src/main/ets/pages/login/viewmodel/LoginViewModelV2'

// ---------- Register ----------
export { default as RegisterState } from './src/main/ets/pages/register/state/RegisterState'
export { RegisterIntent, DoRegisterIntent, UpdateRegisterUserNameIntent, UpdateRegisterPasswordIntent, UpdatePhoneIntent, UpdateNicknameIntent, UpdateEmailIntent } from './src/main/ets/pages/register/intent/RegisterIntent'
export { default as RegisterReducer } from './src/main/ets/pages/register/reducer/RegisterReducer'
export { RegisterRepository } from './src/main/ets/pages/register/repository/RegisterRepository'
export { RegisterUseCase } from './src/main/ets/pages/register/usecase/RegisterUseCase'
export { default as RegisterViewModelV2 } from './src/main/ets/pages/register/viewmodel/RegisterViewModelV2'

// ---------- Utils ----------
export { AppInfo } from './src/main/ets/utils/AppInfo'

// ---------- Memory ----------
export { DHSecretManager } from './src/main/ets/storage/memory/DHSecretManager'
export { UserManager } from './src/main/ets/storage/memory/UserManager'
