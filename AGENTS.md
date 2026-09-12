# AGENTS.md - DarcyHarmonyNext 项目指南

> 鸿蒙 Next API 示例集合（bundleName: `com.darcy.harmonys`，versionName 1.0.3），演示 HarmonyOS Next 的各种 API 与开发模式。纯本地 DevEco Studio 构建，无 CI/CD。绝大多数页面文件与注释均为中文。姊妹文件 `CLAUDE.md` 聚焦"大图景 + 干活路径"，细节以本文件为准，改动注意同步。

## 1. 技术栈和框架

| 分类 | 技术 |
|---|---|
| 平台 | HarmonyOS NEXT，Stage 模型，compatible/target SDK 5.0.5 (API 17)，编译 SDK 6.1.1 (24) |
| 语言 | ArkTS（TypeScript 子集）+ ArkUI 声明式 UI；C++（N-API 原生层） |
| 构建 | hvigor（appTasks 插件，入口 `hvigorfile.ts`），hvigor 6.24.4 / 工具链 6.1.1.125 |
| 包管理 | ohpm（模块间用 `file:../xxx` 源码依赖） |
| IDE | DevEco Studio（工程未提交 `hvigorw` 包装脚本，日常在 IDE 中 Run 构建/安装调试） |
| 状态管理 | V1：`@State/@Prop/@Link/@Provide/@Consume/@Observed/@ObjectLink/@Watch/LocalStorage/AppStorage/PersistentStorage`；V2：`@ObservedV2/@Trace/@Local/@Param/@Once/@Event/@Provider/@Consumer/@Monitor/@Computed` |
| 架构模式 | MVVM（基类在 `static_library_common`，见 §3） |
| 原生集成 | N-API（`library_napi`，CMake 编译 C++ 为 .so） |
| 测试 | `@ohos/hypium` 1.0.18 + `@ohos/hamock` 1.0.0 |
| C++ 静态分析 | `.clang-tidy` / `.clangd`（检查项见 §5） |

## 2. 目录结构与各目录职责

```
DarcyHarmonyNext/
├── AppScope/              # 应用级配置（app.json5：bundleName/版本/图标/应用名）
├── entry/                 # 主 HAP（入口，110+ 演示页面）
├── library_login/         # HAR（登录注册模块，MVVM V2，提供 Login/Register 页面与 DH 密钥交换）
├── static_library_common/ # HAR 静态库（公共底座：工具类、MVVM 基类、BaseUIAbility）
├── shared_library_context/# HSP 动态库（共享上下文/资源，packageType: InterfaceHar）
├── library_chat/          # HAR（聊天功能，Tab 1）
├── library_contact/       # HAR（联系人功能，Tab 2）
├── library_camera/        # HAR（相机功能，SaveButton 安全控件拍照）
├── library_napi/          # HAR（N-API C++ 原生调用）
├── library_network/       # HAR（网络库：HTTP/HTTPS 证书锁定/WebSocket/心跳/DTO 模型）
├── library_crypto/        # HAR（加解密：CryptoUtil AES-256-GCM、DHExchangeUtil X25519 密钥交换）
├── HarmonyNext/           # 学习笔记文档（16 篇 markdown，改代码前先查对应笔记）
├── image/                 # 图片素材（README 用）
├── hvigor/ hvigorfile.ts  # hvigor 构建配置
├── oh_modules/            # ohpm 安装目录（自动生成）
├── build-profile.json5    # 根构建配置：签名、product、模块列表
├── oh-package.json5       # 根依赖（devDeps: hypium/hamock）
└── .pi/                   # pi 编码助手技能（skills）
```

### 依赖关系（禁止反向依赖，防止循环）

```
entry → static_library_common, shared_library_context, library_chat, library_camera,
        library_contact, library_napi, library_network, library_crypto, library_login
library_login → static_library_common, library_network, library_crypto
library_chat / library_camera / library_contact / library_napi / library_network / library_crypto → static_library_common
```

- 模块间引用用 `import { X } from '模块名'`（barrel 导出）或显式深路径 `'static_library_common/src/main/ets/utils/xxx'`。
- 新增依赖方式：目标模块 `oh-package.json5` 的 `dependencies` 加 `"模块名": "file:../模块目录"`，然后 ohpm install 或 IDE Sync。

## 3. 核心模块/文件及其作用

### 应用入口与生命周期

| 文件 | 作用 |
|---|---|
| `AppScope/app.json5` | 应用级配置（bundleName、versionCode 1000003、图标/名称） |
| `entry/src/main/ets/abilitystage/EntryAbilityStage.ets` | AbilityStage，继承 `BaseAbilityState`；在 `onStageCreate()` 中调 `InitCommon.init(context, isDebug)` 和 `HttpCertHelper.initSelfCert(context)` |
| `entry/src/main/ets/entryability/EntryAbility.ets` | 主 Ability，继承 `BaseUIAbility`；实现 `getInitPageName()`（返回 `PAGE_INDEX`）和 `getLocalStorage()`；演示 want 参数解析、eventHub、LocalStorage/AppStorage/PersistentStorage/Environment 用法 |
| `entry/src/main/ets/pages/Index.ets` | 主页面：`Navigation` 包裹 `Tabs`（3 个 Tab = ChatEntryPage / ContractPage / StartPage）。根 Navigation 栈用 `@Provide('appPathStack') pathStack` 跨模块下发 |
| `entry/src/main/ets/pages/StartPage.ets` | 演示菜单（35+ 入口），遍历 `pageNameArray: ItemEntity[]` 渲染按钮 |

### static_library_common（公共底座，barrel 文件 `Index.ets`）

- **日志**：`Log`（应用侧）/ `HiLog`（系统侧，hdc 可查）；`InitCommon.init()` 在 AbilityStage/Ability 的 `onCreate` 调用一次，设置全局 Context 与日志开关。
- **路由**：`RouterHelper`（旧 Router）、`NavigationHelper`（NavigationUtil 别名，新 Navigation）——两套并存，见 §6。
- **工具类**：`ToastUtil`、`AbilityUtil`、`Contexts`、`FileUtil`、`ArrayUtil`、`HashUtil`、`HexUtil`、`Base64Util`、`StringUnit8ArrayUtil`、`ErrorUtil`、`BasicDataSource`（LazyForEach 数据源基类）。
- **Ability 基类**：`BaseUIAbility`（抽象基类，模板化生命周期日志 + WindowStage 事件监听；子类须实现 `getInitPageName()`/`getLocalStorage()`）、`BaseAbilityState`（AbilityStage 基类，子类实现 `onStageCreate()`）。
- **MVVM 基类**（`base/mvvm/`）：`BaseViewModel`、`BaseIntent`、`BaseUseCase`（含 `BaseNoParamUseCase`）、`BaseRepository`、`BaseReducer`、`BaseState`；entry 的 TodoList MVVM 与 library_login 的 Login/Register MVVM V2 均基于此套基类。
- **演示组件**：`StaticMainPage`、`StaticInnerPage`（验证 HAR 组件跨模块引用）。

### library_network（网络库）

- `network/http/HttpHelper.ets`：`BASE_HTTP_URL`、`doGet`、`doPost` 封装。
- `network/http/ssl/HttpCertHelper.ets`：自签名证书初始化（`initSelfCert`）；`PubkeyPinHelper.ets`：证书公钥锁定。
- `network/websocket/WebSocket.ets` + `Heartbeat.ets`：WebSocket 连接与心跳。
- `network/parser/JsonParser.ets`：JSON 解析封装。
- `network/models/`：请求 DTO（Login/Register/Conversation/Friend/X3DH 等 20+）与响应实体（Pageable、Sort 等）；`models/MessageBean.ets` 为聊天消息模型。

### 其他库模块

- `library_chat`：`ChatEntryPage`（Tab 1 首页）、`ChatAbility`、`ChatDataSource`（LazyForEach）。
- `library_contact`：`ContractPage`（Tab 2 首页）。
- `library_camera`：`CameraHelper`、`CameraComponent`、`GlobalCameraContext`、`PermissionUtils`（拍照用 `SaveButton` 安全控件保存）。
- `library_napi`：TS 侧 `ets/napi/NApis.ets`（JS↔C++ 桥）、`LibNapiAbility`、`NApiPage`；C++ 侧 `src/main/cpp/`（`napi_init.cpp`、`NativeEntry.cpp`、`ArkUI*Node.h` 自定义 ArkUI 节点渲染）；`CMakeLists.txt` 编 `library_napi.so`。
- `shared_library_context`：HSP 示例，`SharedIndex`/`SharedInnerPage`/`ContextResourceManager`（跨模块资源获取）。
- `library_crypto`：加解密 HAR。`utils/CryptoUtil.ets`（AES-256-GCM 异步/同步加解密，输出 `[IV(12B)+密文+AuthTag(16B)]` 格式）、`utils/DHExchangeUtil.ets`（X25519 密钥对生成/编解码/DH 密钥协商）。
- `library_login`：登录注册 HAR（MVVM V2 架构）。barrel 导出 `LoginViewModelV2`/`RegisterViewModelV2`/`ServerDHExchangeRepository` 等；entry 的 `pages/login/` 和 `pages/register/` 通过 `import ... from 'library_login'` 引用。依赖 `library_network`（HTTP）和 `library_crypto`（DH 密钥交换）。

### entry 关键目录

- `pages/PageName.ets`：所有页面名常量 `PAGE_XXX = "pages/..."`（新增页面必加）。
- `pages/` 下分类：`entry/status/`（V1 状态管理）、`entry/statusv2/`（V2）、`entry/render_control/`（渲染控制）、`entry/freeze/`（组件冻结）、`entry/custom/`（自定义组件/Builder/样式/modifier）、`entry/thread/`（TaskPool/Worker）、`entry/http/`、`entry/file/`、`entry/sp/`（偏好/键值）、`entry/database/`（关系型数据库）、`background_task/`、`animate/`、`mvvm/`、`napi/`、`har_hsp/`、`want/` 等。
- `models/`：`ItemEntity`（StartPage 菜单项）等实体；`repository/TodoListRepository.ets`；`storage/`（`IdentityKeyDao` 等）；`utils/`（`AppInfoUtil`、`CryptoUtil`、`DHExchangeUtil`、`ResourceUtil`）；`workers/AddWorker.ets`（Worker 线程，登记在 entry build-profile `sourceOption.workers`）。
- `otherability/`：`HomeAbility`、`OtherAbility`、`LongTaskAbility`（backgroundModes: dataTransfer）、`LongTaskDetailAbility`；`extension_ability/`：`EntryWorkSchedulerExtensionAbility`（workScheduler）、`EntryBackupAbility`（backup）。HAR/HSP 中的 UIAbility 需在 entry 的 `module.json5` 中登记。

### 路由配置

- `entry/src/main/resources/base/profile/main_pages.json`：Router 路由的 `@Entry` 页面登记表（旧路由跳转目标必须在此）。
- `entry/src/main/resources/base/profile/router_map.json`：Navigation 命名路由映射（`buildFunction: "NavigationBuilder"`），HAR/HSP 跨模块页面与 statusv2 系列子页面在此。
- 各库模块的 `router_map.json` 只用于库内页面。

## 4. 构建、测试、lint 命令

工程未提交 `hvigorw` 包装脚本，日常构建/安装/调试在 DevEco Studio 中点击 Run 完成。CLI 构建需已安装 hvigor（DevEco 自带），在项目根目录执行：

```bash
# 构建主应用 HAP（entry）
hvigorw assembleHap --mode module -p product=default -p buildMode=debug

# 构建 HAR 静态库 / HSP 动态库
hvigorw assembleHar --mode module -p product=default -p buildMode=debug

# 清理
hvigorw clean

# 安装依赖
ohpm install
```

- **测试**：框架 hypium 1.0.18 + hamock 1.0.0（根 `oh-package.json5` devDependencies）。本地单元测试在 `src/test/`（entry 最全面：`LocalUnit.test.ets` 汇总 suite，覆盖 Promise/AsyncWait/ThreadPool/Worker 等），仪器化测试在 `src/ohosTest/`（`List.test.ets` 聚合 `Ability.test.ets`）。library_login 同结构。测试在 DevEco Studio 内运行（无 CLI 单测入口）；`entry/build-profile.json5` 的 targets 含 `ohosTest`。
  - **本地单测环境限制**：`cryptoFramework` 等系统 API 在本地单测（src/test）中是桩实现（密钥生成返回非空对象但 getEncoded/generateSecret/cipher.update 返回空），加解密类代码必须在模拟器/真机上用仪器化测试验证。
  - **HAR 无法独立跑仪器化测试**：HAR 模块的 `@ohosTest` 目标只是打包 test 版 HAR（无 HAP 可安装），HAR 代码的仪器化测试须经宿主 HAP（entry）执行。
  - **测试归库 + 宿主聚合模式**（library_crypto 采用）：测试源码放在被测库 `library_crypto/src/ohosTest/ets/test/`（CryptoUtil 16 例 + DHExchangeUtil 10 例），宿主 `entry/src/ohosTest/ets/test/List.test.ets` 通过 `import xxx from 'library_crypto/src/ohosTest/ets/test/Xxx.test'` 聚合执行。注意：库内测试文件自身不能 `import 'library_crypto'` 自引用（类型退化为 any，ArkTS 报 arkts-no-any-unknown），必须用相对路径 `../../../main/ets/...` 导入被测类。
  - **CLI 跑仪器化测试**（需模拟器/真机在线）：`hvigorw assembleHap -p module=entry@ohosTest` → hdc 依次安装 `shared_library_context-*.hsp`（HSP 依赖）→ `entry-default-signed.hap` → `entry-ohosTest-signed.hap` → `hdc shell aa test -b com.darcy.harmonys -m entry_test -s unittest OpenHarmonyTestRunner -w 120`。
- **C++ lint**：`.clang-tidy`/`.clangd` 对 `library_napi/src/main/cpp/` 启用静态分析（clangd 的 UnusedIncludes/UnusedFunctions 为 Strict/Check）。检查项：`misc-napi-module-name`、`misc-napi-macro-module-name`、`readability-system-capabilities`、`capi-version-validation`、`misc-unused-*`、`modernize-use-auto` 等。无 JS/TS lint（无 eslint/tslint 配置）。
- **签名**：构建依赖根 `build-profile.json5` 中的签名配置（见 §5）。

## 5. 关键依赖和配置

- **ohpm 依赖**：根 devDeps 仅 `@ohos/hypium 1.0.18`、`@ohos/hamock 1.0.0`；模块间全部为 `file:` 源码依赖（见 §2 依赖图）。`library_napi` 额外依赖本地 so 接口包 `"liblibrary_napi.so": "file:./src/main/cpp/types/library_napi"`。
- **N-API 原生依赖**：`CMakeLists.txt` 链接 `libace_napi.z.so` 和 `libace_ndk.z.so`；ABI 过滤 `arm64-v8a`、`x86_64`（entry 与 library_napi 的 `externalNativeOptions.abiFilters`）。
- **签名配置**（根 `build-profile.json5` → `signingConfigs.build`）：本地 `.p12` 密钥库 + debug `.p7b` profile + `.cer` 证书，路径为 `C:/Users/DarcyCH/Documents/KMPHarmony/keystore/` 绝对路径，算法 `SHA256withECDSA`，alias `darcy`。**其他开发者需替换为自己的签名配置**。
- **权限**（entry `module.json5`）：`ohos.permission.INTERNET`（always）、`ohos.permission.CAMERA`（inuse，EntryAbility）、`ohos.permission.KEEP_BACKGROUND_RUNNING`（inuse，LongTaskAbility）。受限权限 `READ_IMAGEVIDEO`/`WRITE_IMAGEVIDEO` 已注释（需华为官网单独申请）。
- **混淆**：`static_library_common` release 启用混淆（`obfuscation-rules.txt` + `consumer-rules.txt`）；entry release 启用（`obfuscation-rules.txt`）；library_napi release 关闭混淆但 strip 原生调试符号；其余库可选。
- **编译产物**：`static_library_common` 通过 module metadata `UseTsHar: true` 产出 TS 版 HAR。
- **product 配置**：唯一 product `default`（compatible/target 5.0.5(17)），buildMode 有 debug/release。`shared_library_context` 为 HSP（`packageType: InterfaceHar`），构建产物随 entry 一起打包进应用。
- **mock**：`entry/src/mock/`、`library_login/src/mock/`、`library_chat/src/mock/`、`library_napi/src/mock/` 提供 Preview 模拟数据（`mock-config.json5`）。

## 6. 开发流程和注意事项

### 两套路由机制并存（最容易踩的坑）

同一工程内两套跳转，新页面按目标页面形态选择：

1. **旧 Router**：目标为 `@Entry` 页面，`RouterHelper.startPage(context, url, params)` → `router.pushUrl`。此类页面**必须登记在 `main_pages.json`**。StartPage 菜单中绝大多数按钮走这条路。
2. **新 Navigation / NavPathStack 命名路由**：目标为 NavDestination 形态页面，`NavigationHelper.startPage(pathStack, PAGE_XXX, params)` → `pushDestination`。跨模块共享 `@Provide('appPathStack')` / `@Consume('appPathStack')`；`name → 组件` 映射声明在 `router_map.json`。HAR/HSP 跨模块页面与 statusv2 系列子页面走这条。

### 新增一个演示页面的标准流程

1. 在 `entry/src/main/ets/pages/<分类目录>/` 新建页面，沿用目录内同类写法；页面生命周期方法（`aboutToAppear`/`onPageShow`/`onPageHide`/`onBackPress`/`aboutToDisappear`/`onDidBuild` 等）内必须打日志。
2. 在 `PageName.ets` 加 `PAGE_XXX = "pages/..."` 常量。
3. 按跳转方式登记路由：Router 目标加 `main_pages.json`；Navigation 命名路由加 `router_map.json`。
4. 在 `string.json` 加菜单标题资源，在 `StartPage.ets` 的 `pageNameArray` 末尾追加 `new ItemEntity(PAGE_XXX, $r('app.string.XXX'))`。
5. 需要 UI 大块示例的系列（status/freeze/render_control/statusv2 等）采用"聚合入口页 + 子页"结构：入口页加入菜单，子页从入口页再跳转。

### 约定

- 日志一律用 `static_library_common` 的 `Log`（应用侧）/ `HiLog`（系统侧，hdc 排查）；`InitCommon.init()` 必须在 AbilityStage 或 Ability 的 `onCreate` 调用一次，否则 Context/日志未初始化。
- 注释用中文；`TODO`/`FIXME` 标注待办。资源文案集中在 `string.json`，页面用 `$r('app.string.xxx')` 引用，少写死字符串。
- 每个库模块必须保留 `Index.ets` barrel 导出。
- 状态管理示例：新示例优先参照同系列现有页面（V1 在 `pages/entry/status/`，V2 在 `pages/entry/statusv2/`）。
- 学习笔记在 `HarmonyNext/`（ArkTS、UIAbility、组件、MVVM、多线程、数据持久化、HAR/HSP、UDMF、ExtensionAbility、HDC 命令等），改相关代码前先查对应笔记。

### 已知坑

- 企业微信自定义状态管理框架（`pages/entry/custom/styles/modifier/weixingroup/`）：组件和 Data 必须一一对应，否则状态错乱（详见 README）。
- Camera 模块用 `SaveButton` 安全控件保存照片；受限媒体权限不可随意申请。
- `BaseUIAbility.onWindowStageDestroy` 中注销 `windowStage.off('windowStageEvent')` 会报 `state abnormally`，代码中已注释禁用。
- N-API 新增 .cpp 文件需同步登记到 `CMakeLists.txt` 的 `add_library`；ABI 必须含 `arm64-v8a`/`x86_64`（否则模拟器/真机安装报 `install parse native so failed`）。
