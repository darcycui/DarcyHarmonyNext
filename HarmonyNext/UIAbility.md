# UIAbility
## 1. 是什么
- UI窗口,用于用户交互
- 系统调度的最小单元

## 2. 特性
- 支持跨端迁移 多端协同
- 支持多设备 多窗口
- 每个UIAbility对应任务栈里的一个任务


## 3. 怎么用
- 在module.json5配置文件 abilitied中配置
  - name 名称
  - srcEntry 入口文件
  - lable 标题
  - icon 图标
  - startWindowIcon 启动图标
  - startWindowBackground 启动背景颜色
  - launchType 启动模式

## 4. 生命周期
Abilitiy生命周期
- onCreate 创建Ability实例
- onForeground 前台
- onBackground 后台
- onDestroy 销毁Ability实例
  
![UIAbility生命周期](/image/UIAbility生命周期.png)

windowStage状态
- onWindowStageCreate 创建窗口
- onWindowStageWillDestroy 即将销毁窗口
- onWindowStageDestroy 销毁窗口
  
windowStage事件
- Shown 可见
- Active 获得焦点
- InActive 失去焦点
- Hidden 不可见
  
显示
- onCreate -> onWindowStageCreate -> onForground -> Shown -> Active
  
隐藏
- InActive -> Hidden -> onBackground -> onWindowStageWillDestroy -> onWindowStageDestroy -> onDestroy

![UIAbility生命周期_关联WindowStage状态](/image/UIAbility生命周期_关联WindowStage状态.png)

- TODO 存疑: 模拟器运行结果与文档描述不一致
![UIAbility生命周期模拟器运行结果](/image/UIAbility生命周期模拟器运行结果.png)

onNewIntent
- 启动模式为singletone时,会调用onNewIntent

## 5. 启动模式
有哪些
  - multiton/standard 标准模式
  - singletone 单例模式(默认)
  - specified 指定模式

怎么用
  - 在module.json5配置文件 abilitied中配置 launchType
  - specified模式 需要配置Module的AbilityStage(onAccepWant方法)

## 6. 常用操作
- 设置启动页面 onWindowStageCreate -> loadContent()
- 上下文Context是UIAbilitityContext类型
    - 在Ability中通过 this.context获取
    - 在UI组件中通过getContext(this) as common.UIAbilityContext 获取
- 吐司toast 使用 promptAction.showToast(message)


## 7. Ability与UI组件通信(同步数据)
使用总线 EventHub
- Ability注册监听 
  this.context.eventHub.on('eventName',callback)

- UI组件发送事件 
  getContext(this) as common.UIAbilityContext.eventHub.emit('eventName',data)
  
## 应用状态管理
- LocalStorage 
  - 页面级存储UI状态 用于UIAbility内不同Page
  - @LocalStorageProp
    - 私有 组件内访问
    - 参数key string类型
    - 支持基本类型和class类型 不支持any
    - 单向同步 LocalStorage-->组件
    - 必须在组件内初始化
    - 不支持从父组件初始化
    - 可传递给子组件
    - 是一种状态变量 变量改变会刷新UI
  - @LocalStorageLink
    - 私有 组件内访问
    - 参数key string类型
    - 支持基本数据类型和class类型 不支持any
    - 双向同步 LocalStorage<==>组件
    - 必须在组件内初始化
    - 不支持从父组件初始化
    - 可以传递给子组件
    - 是一种状态变量 变量改变会刷新UI
- AppStorage 
  - 单例的LocalStorage 系统在应用启动时创建
  - 应用内跨Alibity共享数据
  - 只能在主线程内共享
  - @StorageProp
    - 私有 组件内访问
    - 参数key string类型
    - 支持基本数据类型和class类型 不支持any类型
    - 单向同步 AppStorage-->组件
    - 必须在组件内初始化
    - 不支持从父组件初始化
    - 可以传递给子组件
    - 是一种状态便来那个 变量改变会刷新UI
  - @StorageLink
    - 私有 组件内访问
    - 参数key string类型
    - 支持基本数据类型和class类型
    - 双向同步 AppStorage<==>组件
    - 必须在组件内初始化
    - 不支持从父组件初始化
    - 可以传递给子组件
    - 是一种状态变量 变量改变会刷新UI

- PersistentStorage 
  - 持久化存储UI状态 支持应用重启后恢复 
  - 依赖AppStorage,关联AppStorage的属性
  - 双向同步 PersistentStorage<==>AppStorage
  - 支持基本数据类型 number string boolean enum
  - 支持可以被JSON.stringfy()对象
  - 支持可以被JSON.parse()对象
  - 不支持class嵌套class
  - 不支持class数组
  - 支持Map Set Date
  - 支持联合类型 undefined null
  - 主线程 同步存储
  - 写入对象 要求2K一下
  - 和UI实例关联 在Ability loadContent()的回调及以后 才可以访问
  - 在组件中使用前要现在Ability中通过PersistentStorage.persisProp()存储
  - 组件内始终通过AppStorage(@StorageProp @StorageLink)访问持久属性

- Environment 
  - 设备参数 只读 
  - 都是基本数据类型
  - 单向同步 Enviroment-->AppStorage
  - 组件内使用通过AppStorage(@StoragePop)使用
  - Environment需要关联UIContent 否则无法获取到值 在Ability onWindowStateCreate()+runScopeTask使用
  - 支持获取 
    - accessibilityEnabled
    - colorMode 深色模式 ColorMode.LIGHT ColorMode.DARK
    - fonstScale
    - fontWeightScale
    - layoutDirection
    - languageCode zh/cn

