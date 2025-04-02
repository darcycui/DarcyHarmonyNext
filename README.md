# 鸿蒙Next Api示例集合
## 目录
* [0. ArkTs学习笔记](/HarmonyNext/ArkTS学习笔记.md)
* [1. 项目结构](/HarmonyNext/项目结构.md)
* [2. UIAbility及其状态管理](/HarmonyNext/UIAbility.md)
* [3. 组件及其状态管理](/HarmonyNext/组件.md)
* [4. MVVM管理状态](/HarmonyNext/MVVM管理状态.md)
* [5. 组件样式和复用](/HarmonyNext/组件复用Custom.md)
* [6. 异步任务](/HarmonyNext/单线程异步任务.md)
* [7. 多线程](/HarmonyNext/多线程.md)
* [8. 数据持久化](/HarmonyNext/数据持久化.md)
* [9. 统一数据管理框架 UDMF](/HarmonyNext/统一数据管理框架.md)
* [10. ExtentionAbility](/HarmonyNext/ExtentionAbility.md)
* [11. 静态库HAR](/HarmonyNext/静态库HAR.md)
* [12. 动态库HSP](/HarmonyNext/动态库HSP.md)
* [13. 发布静态库HAR到OpenHarmony三方仓库](/HarmonyNext/发布静态库HAR到OpenHarmony三方仓库.md)
* [14. 常用hdc命令](/HarmonyNext/鸿蒙HDC命令.md)
* [14. 进程通信]
* [15. 文件操作]
* [16. NApi调用C、C++]

## 企业微信自定义状态管理
* [企业微信自定义状态管理(代码实现)](entry/src/main/ets/pages/entry/custom/styles/modifier/weixingroup/WeiXinGroupAttributeUpdaterPage.ets)
- 实现思路：系统的动态代理有性能问题 需要优化，所以基于自定义状态管理的性能优化
* 框架层
  * 1.通过Updater获取到Attribute的实例instance
  * 2.将instance实例传递给Data类
  * 3.Data类代理instance 修改Data的值同时 instance实例也会修改(触发UI刷新)
* 客户端
  * 4.使用@Watch 监听Data类的属性变化 在回调函数中更新UI
  * 5.在aboutToAppear() aboutToReuse()中绑定Updater和Data
* darcyRefactor: 这里有坑
* 6.注意：目前状态管理要求组件和Data一一对应 否则状态错乱
* [参考链接:在流沙上筑城：企微鸿蒙开发演进](https://mp.weixin.qq.com/s/vdH7hbznyJSluwwa0sLIHQ)
