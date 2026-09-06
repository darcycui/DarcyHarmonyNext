# 1.介绍
一个静态库,包含静态库最小集合,支持导出自定义组件,页面,类,函数

## 0.初始化(V1.0.1支持)
- 使用Log和HiLog打印日志支持配置开关,只在debug状态下打印,默认为false,
- 通过以下配置修改

```typescript
// 建议在在EntryAbility的onCreate()中初始化
export default class LoginAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    ...
    InitCommon.init(BuildProfile.DEBUG)
    ...
  }
```
初始化以后可以通过如下方式使用Log和HiLog
```typescript
Log.info('har static library common log')
```

## 1.使用静态库自定义组件

```typescript
...
build(){
  ...
  // 直接在build中使用静态库组件
  StaticMainPage()
  ...
}
...
```
## 2.跳转静态库页面

```typescript
    Button($r("app.string.StaticLibraryCommonName"))
    .margin({ bottom: 10 })
    .onClick(() => {
      // 跳转到静态库页面
      startNamedPage("pages/static/common/StaticInnerPage", { 'keyHello': 'Hello World' });
    })
  
    export function startNamedPage(url: string, params: Record<string, string>) {
      router.pushNamedRoute({
        name: url,
        params: params
      }).then(() => {
        console.log("Succeed to start page: " + url);
      }).catch((err: Error) => {
        console.error("Failed to start page: " + url);
      });
    }
```
## 3.调用静态库接口

```typescript
      // 调用static库中的接口
      Button("StaticLibraryCommonFunc1")
        .onClick(() => {
          // 调用static库中的Log.info
          Log.info('har static library common func')
        })
```
## 4.调用静态库函数

```typescript
      // 调用static库中的函数
      Button("StaticLibraryCommonFunc2")
        .onClick(() => {
          // 调用static库中的func函数 func2函数
          let info = func() + ' ' + func2()
          console.info(`call static library common func: info=${info}`)
        })
```
## 5.使用静态库资源

```typescript
      // 引用static库中的string
      Button($r("app.string.StaticLibraryCommonName"))
      ...
      // 引用static库中的图片
      Image($r("app.media.static_icon"))
      ...
```
## 6.使用Log打印console日志
- info
- debug
- warn
- error
- log

```typescript
 ...
 Log.info(`explicit start ability succeed`);
 ...
```
## 7.使用 HiLog 打印 hilog 日志
- info
- debug
- warn
- error
- fatal

```typescript
onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    ...
    HiLog.info('Ability onCreate');
    ...
    }
```
## 8.使用 ToastHelper 打印 promptAction
```typescript
ToastHelper.showToast('This is a toast')
```

## 9.使用 RouterHelper 跳转 page
```typescript
// 跳转当前module page
RouterHelper.startPage('pages/entry/XXXPage', { 'keyHello': 'Hello World' })
  
// 跳转其他module page
RouterHelper.startNamedPage('pages/static/common/StaticInnerPage', { 'keyHello': 'Hello World' })
```

## 10.使用 AbilityHelper 跳转 Ability
```typescript
AbilityHelper.startAbility(context, "OtherAbility", {"name": "张三", "id": 100})
```

# 2.引用方式
ohpm install static_library_common

# 3.依赖
无

# 4.运行环境
- HarmonyOS NEXT Developer Beta3 SDK, based on OpenHarmony SDK Ohos_sdk_public 5.0.0.36 (API Version 12 Beta3)
- DevEco Studio NEXT Developer Beta3
