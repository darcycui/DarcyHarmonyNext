# AGENTS.md - DarcyHarmonyNext 项目指南

## 项目概述

鸿蒙Next API示例集合（`com.darcy.harmonys`），演示HarmonyOS Next的各种API和开发模式。目标SDK：5.0.5 (API 17)。使用DevEco Studio开发。

## 构建命令

- **hvigorw**（等同于`./hvigorw`）是构建工具，需在项目根目录执行
- 构建应用：`hvigorw assembleHap --mode module -p product=default -p buildMode=debug`
- 构建库：`hvigorw assembleHar --mode module -p product=default -p buildMode=debug`
- 清理：`hvigorw clean`
- 无CI/CD配置，纯本地DevEco Studio构建

## 模块结构

```
DarcyHarmonyNext/
├── entry/              # 主HAP模块（入口，110+演示页面）
├── login/              # 特性HAP模块（独立登录演示）
├── static_library_common/  # HAR静态库（公共工具：Log, Router, Toast等）
├── shared_library_context/ # HSP动态库（共享上下文/资源）
├── library_chat/       # HAR（聊天功能）
├── library_camera/     # HAR（相机功能）
├── library_contact/    # HAR（联系人功能）
├── library_napi/       # HAR（N-API C++原生调用）
└── HarmonyNext/        # 学习笔记文档
```

### 依赖关系

```
entry → static_library_common, shared_library_context, library_chat, library_camera, library_contact, library_napi
login → static_library_common
library_chat, library_camera, library_contact, library_napi → static_library_common
```

## 关键入口文件

- **主Ability**: `entry/src/main/ets/entryability/EntryAbility.ets`（继承`BaseUIAbility`）
- **AbilityStage**: `entry/src/main/ets/abilitystage/EntryAbilityStage.ets`（调用`InitCommon.init()`初始化公共库）
- **主页面**: `entry/src/main/ets/pages/Index.ets`（Navigation + Tabs布局，3个Tab）
- **演示菜单**: `entry/src/main/ets/pages/StartPage.ets`（35+演示入口）
- **BaseUIAbility**: `entry/src/main/ets/base/BaseUIAbility.ets`（抽象基类，子类需实现`getInitPageName()`和`getLocalStorage()`）
- **公共库导出**: `static_library_common/Index.ets`（所有公共API的barrel导出）

## 路由系统

项目同时使用两种路由方式：
- **Router**（旧）: `RouterHelper.startPage()` → `router.pushUrl()`
- **Navigation**（新）: `NavigationHelper.startPage()` → `NavPathStack`
- 跨模块通信使用`@Provide('appPathStack')` / `@Consume('appPathStack')`
- `entry/src/main/resources/base/profile/router_map.json`定义14个命名路由

## 代码约定

- 所有日志使用`static_library_common`中的`Log`和`HiLog`
- 每个库模块必须有`Index.ets`作为barrel导出文件
- 页面生命周期方法必须包含日志（`onPageShow`, `onPageHide`, `onBackPress`, `aboutToAppear`等）
- 文件组织：`src/main/ets/`（源码）、`src/main/resources/`（资源）、`src/test/`（单元测试）、`src/ohosTest/`（仪器化测试）
- 注释使用中文，TODO/FIXME标记待办事项

## 状态管理

覆盖V1和V2两套状态管理API：
- **V1**: @State, @Prop, @Link, @Provide/@Consume, @Observed/@ObjectLink, @Watch, LocalStorage, AppStorage, PersistentStorage
- **V2**: @ObservedV2, @Trace, @Local, @Param, @Once, @Event, @Provider/@Consume, @Monitor, @Computed

## N-API原生集成（library_napi）

- C++代码在`library_napi/src/main/cpp/`
- TypeScript包装在`library_napi/src/main/ets/napi/NApis.ets`
- CMakeLists.txt构建`library_napi.so`
- 依赖`libace_napi.z.so`和`libace_ndk.z.so`

## 测试

- 框架：`@ohos/hypium` v1.0.18 + `@ohos/hamock` v1.0.0
- 本地单元测试：`src/test/LocalUnit.test.ets`
- 仪器化测试：`src/ohosTest/Ability.test.ets`
- entry模块测试最全面（Promise, AsyncWait, ThreadPool, Worker等）

## 构建配置

- 构建工具：hvigor 6.24.4，工具链6.1.1.125
- 编译SDK版本：6.1.1 (24)
- 签名配置在`build-profile.json5`中（本地.p12密钥库）
- `static_library_common` release模式启用混淆，其他库可选
- `.clang-tidy`和`.clangd`配置了N-API C++代码的静态分析规则

## 注意事项

- 签名密钥路径为本地路径，其他开发者需替换为自己的签名配置
- `InitCommon.init()`必须在AbilityStage或Ability的`onCreate`中调用一次
- Camera模块使用`SaveButton`安全控件模式保存照片
- 企业微信自定义状态管理框架有已知限制：组件和Data必须一一对应，否则状态错乱
