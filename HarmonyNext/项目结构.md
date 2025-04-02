# Harmony学习笔记
## 1. 项目结构
应用配置: AppScope/app.json5 
- bundleName   应用包名
- versionName  应用版本名
- versionCode  应用版本号
- label 应用名称
- icon  应用图标
- vendor 企业名称

模块配置: Module_name/src/main/moudle.json5
- name 模块名
- type 模块类型 entry主模块/feature动态模块(用户可以选择性安装)
- deviceTypes 支持的设备
- pages 页面UI(ArkUI struct) Module_name/src/main/resources/profile/main_pages.json
- abilities 页面 launchType启动模式
- extensionAbilities 特殊交互(备份/分享/输入法等)
- requestPermissions 申请权限


代码: Module_name/src/main/ets

资源: 
AppScope/resources
Module_name/src/mian/resources

三方库: oh_package.json5

编译配置: build-profile.json5
- signingConfigs 签名信息
- compatibleSdkVersion 指定Harmony版本
- buildModeSet 编译类型 debug/release
- modules 应用的所有module

编译脚本: hvigotfile.json5

混淆: Module_name/src/obfuscation-rules.txt

## 1.1 HAP HAR HSP
- entry模块
  - 应用主模块 入口
  - 只有一个

- feature动态模块
  - 编译产物为.hap
  - 可以有多个
  - 跳转使用want

- .har静态依赖库

- .hsp动态依赖库

## 1.2 资源分类
- overlay机制 
  - 一种资源替换机制,渠道包不重新打包,改变界面风格

## 2. 学习ArkTS语言
- JS虚拟机垃圾回收
- async await 异步操作（Promise或者回调方法）

## 3. UI范式
- ArkUI都是由组件构成的


## 4.状态管理机制
- 组件状态管理


## 5.渲染控制


## 6.


 