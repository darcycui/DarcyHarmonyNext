# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> 仓库根目录另有 `AGENTS.md`（更详细的模块清单、N-API、签名与构建配置说明）。两文件同源，本文件聚焦“大图景 + 干活路径”；细节以 `AGENTS.md` 为准，改动注意同步。

## 项目定位

鸿蒙 Next API 示例集合（`com.darcy.harmonys`），用于演示 HarmonyOS Next 的各种 API 与开发模式（状态管理 V1/V2、Promise/异步、线程、文件/数据持久化、HTTP、HAR/HSP、N-API、自定义状态管理框架等）。工程纯本地 DevEco Studio 构建，无 CI。目标/兼容 SDK：5.0.5（API 17）。绝大多数页面文件与注释均为中文。

## 常用命令（在项目根目录，hvigor 构建）

- 构建主应用 HAP：`hvigorw assembleHap --mode module -p product=default -p buildMode=debug`
- 构建 HAR/HSP 库：`hvigorw assembleHar --mode module -p product=default -p buildMode=debug`
- 清理：`hvigorw clean`
- 工程未提交 `hvigorw` 包装脚本，日常在 DevEco Studio 中点击 Run 构建/安装到模拟器或真机调试。

## 模块结构与依赖

- `entry/`：主 HAP，全部演示页面的所在地，110+ 页面。
- `login/`：独立特性 HAP（登录演示，不参与 entry 主界面）。
- `static_library_common/`：公共静态库 HAR（所有模块的底座）。`Index.ets` 是其 barrel 导出（Log/HiLog/RouterHelper/NavigationHelper/AbilityHelper/ToastHelper/InitCommon/BasicDataSource/静态演示组件等）。`InitCommon.init()` 需在各 AbilityStage/Ability 的 `onCreate` 调用一次。
- `shared_library_context/`：HSP 动态库（共享上下文，`packageType: InterfaceHar`）。
- `library_chat/` `library_camera/` `library_contact/`：HAR，各自导出一张可内嵌的首页（ChatEntryPage 等，被 entry 的 Tabs 引用）。
- `library_napi/`：HAR + C++ 原生（`src/main/cpp/`，CMake 编 `library_napi.so`），TS 包装在 `ets/napi/`，演示 N-API 与 C/C++ 调用。
- `library_network/`：HAR，网络封装（HTTP/证书锁定/WebSocket/DTO），entry 与 login 均依赖。
- `library_crypto/`：HAR，加解密工具（`CryptoUtil` AES-256-GCM、`DHExchangeUtil` X25519），从 entry `utils/` 迁入，barrel 导出在 `Index.ets`。
- `HarmonyNext/`：ArkTS/状态管理/多线程/持久化等学习笔记（markdown），改代码前先查对应笔记。

依赖方向：`entry → static_library_common, shared_library_context, library_*`；`login → static_library_common, library_network`；各 `library_* → static_library_common`。模块间引用用 `import { X } from '模块名'` 或显式深路径。

## 关键入口与页面骨架

- `EntryAbility.ets` 继承 `entry/src/main/ets/base/BaseUIAbility.ets`（抽象基类：模板化的 lifecycle 日志、WindowStage 事件；子类须实现 `getInitPageName()` 与 `getLocalStorage()`）。
- `EntryAbilityStage.ets` 在 `onCreate` 调 `InitCommon.init()`。
- 主界面 `entry/src/main/ets/pages/Index.ets`：`Navigation` 包裹 `Tabs`，3 个 Tab = `ChatEntryPage`(library_chat) / `ContractPage`(library_contact) / `StartPage`(演示菜单)。根 Navigation 栈通过 `@Provide('appPathStack') pathStack` 下发给跨模块页面。
- 演示菜单 `entry/src/main/ets/pages/StartPage.ets`：遍历 `pageNameArray: ItemBean[]`（`ItemBean = {pageName 常量, string 资源}`）渲染按钮。
- 页面名常量统一放 `entry/src/main/ets/pages/PageName.ets`（`PAGE_XXX = "pages/..."`），字符串文案在 `entry/src/main/resources/base/element/string.json`。

## 两套路由机制并存（新增页面最容易踩的坑）

同一工程内同时存在两套跳转，新页面要按目标页面形态选择：

1. **旧 Router**：目标为 `@Entry` 页面，通过 `RouterHelper.startPage(context, url, params)` → `router.pushUrl`。此类页面必须登记在 `entry/src/main/resources/base/profile/main_pages.json` 的 `src` 里。当前 StartPage 菜单中绝大多数按钮走这条路。
2. **新 Navigation / NavPathStack 命名路由**：目标为 NavDestination 形态页面，通过 `NavigationHelper.startPage(pathStack, PAGE_XXX, params)` → `pushDestination`。Navigation 跨模块共享同一 `@Provide('appPathStack')` / `@Consume('appPathStack')`。`name → 组件` 的映射声明在 `router_map.json`（`buildFunction: "NavigationBuilder"`）。HAR/HSP（跨模块）页面与 statusv2 系列子页面走这条。

`NavigationHelper` / `RouterHelper` 均封装于 `static_library_common`。

## 新增一个演示页面的标准流程

1. 在 `entry/src/main/ets/pages/<分类目录>/` 下新建页面，沿用目录内同类的写法（组件化 + `NavigationBuilder`/`@Entry` 视目标路由而定）；页面生命周期方法（`aboutToAppear`/`onPageShow`/`onPageHide`/`onBackPress`/`aboutToDisappear` 等）内必须打日志。
2. 在 `PageName.ets` 加 `PAGE_XXX = "pages/..."` 常量。
3. 按跳转方式登记路由：Router 目标加入 `main_pages.json`；Navigation 命名路由目标加入 `router_map.json`。
4. 在 `string.json` 加菜单标题资源，在 `StartPage.ets` 的 `pageNameArray` 末尾追加一个 `new ItemBean(PAGE_XXX, $r('app.string.XXX'))`。
5. 需要 UI 展示的大块示例（status/freeze/render_control/statusv2 等）采用“聚合入口页 + 子页”结构：入口页加入菜单，子页从入口页内再跳转。

## 约定与注意事项

- 一切日志用 `static_library_common` 的 `Log` / `HiLog`；`Log` 默认进应用侧，`HiLog` 进系统侧，排查可用 hdc。
- 注释用中文；`TODO`/`FIXME` 标注待办。资源文案集中在 `string.json`，页面用 `$r('app.string.xxx')` 引用，少写死字符串。
- 状态管理同时覆盖 V1（`@State/@Prop/@Link/@Provide/@Consume/@Observed/@Watch/LocalStorage/AppStorage/PersistentStorage`）与 V2（`@ObservedV2/@Trace/@Local/@Param/@Once/@Event/@Provider/@Consumer/@Monitor/@Computed`），新示例优先参照同系列现有页面。
- 每个库模块必须保留 `Index.ets` barrel 导出。
- 企业微信自定义状态管理框架（`pages/entry/custom/styles/modifier/weixingroup/`）有已知坑：组件与 Data 必须一一对应，否则状态错乱（见 README）。
- N-API C++ 改动留意 `.clangd`/`.clang-tidy` 静态分析；so 依赖 `libace_napi.z.so`、`libace_ndk.z.so`。

## 测试

- 框架：`@ohos/hypium` 1.0.18 + `@ohos/hamock` 1.0.0（根 `oh-package.json5` devDependencies）。
- 单元测试在 `src/test/`、仪器化测试在 `src/ohosTest/`（`entry/build-profile.json5` 的 targets 含 `ohosTest`）。`entry/src/test/` 覆盖 Promise/AsyncWait/ThreadPool/Worker/LocalUnit 等，`LocalUnit.test.ets` 汇总 suite。
- 测试在 DevEco Studio 内运行；未发现 CLI 单测入口。

## 提醒

- 签名配置在根 `build-profile.json5`，指向本地 `.p12`/`.p7b`/`.cer` 绝对路径，他人需自换。
- 无 `.github`，无 CI/流水线。
