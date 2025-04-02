# 静态库HAR.md

## 1.静态共享包  可以包含ts代码,资源和配置文件,C++库

## 2.特点
- 不包含UIAbility
- 不包含ExtensionAbility
- 可以包含pages页面,通过"命名路由"跳转(不支持配置pages页面)
- 不可以独立运行
- 不可以引用AppScope中的资源
- 可以依赖其他HAR包,不支持"依赖传递"
- 作为二方库/三方库发布,独立发布,版本号随意

## 3.创建静态库
New--Module--Static Library

## 4.导出
- 通过Index.ets文件配置
- 组件导出
- 类导出
- 方法导出
- pages不需要导出(通过"命名路由"跳转)
- 导出native方法

```javascript
// library/Index.ets
export { Log } from './src/main/ts/test';
export { func } from './src/main/ts/test';
export { func2 } from './src/main/ts/test';
```

## 5.开启混淆
build-profile.json5文件,设置ruleOptions为开启状态(enable:true)
```javascript
{
  "apiType": "stageMode",
  "buildOption": {
  },
  "buildOptionSet": [
    {
      "name": "release",
      "arkOptions": {
        "obfuscation": {
          "ruleOptions": {
            "enable": true,
            "files": [
              "./obfuscation-rules.txt"
            ]
          },
          "consumerFiles": [
            "./consumer-rules.txt"
          ]
        }
      }
    },
  ]
}
```

## 6.生成TS文件
module.json5文件,设置"metadata"字段下的"name"设置为“UseTsHar”
```javascript
{
  "module": {
    "name": "TsClosedHar",
    "type": "har",
    "deviceTypes": [
      "default",
      "tablet",
      "2in1"
    ],
    "metadata": [
      {
        "name": "UseTsHar",
        "value": "true"
      }
    ]
  }
}
```
注意: 
- 在HAR中使用Sendable时，开启该配置。
- 在依赖TS HAR时，禁止引用TS HAR中的ArkUI组件

## 7.编译
- 选中library
- Build--Make Module XXX
- 产物目录:build/outputs/default/XXX.har

# 8.使用har
## 1.源码依赖
- oh-package.json5中设置 源码所在folder
```javascript
"dependencies": {
	// "folder" key不能重复 一般取库名
  "folder": "file:../static_library_common" // oh-package.json5所在目录为起点的相对路径
}
```
- 执行安装命令
ohpm install

## 2.har依赖
- oh-package.json5中设置
```javascript
"dependencies": {
  // "package" key不能重复 一般取库名
  "package": "file:path/to/package.har" // oh-package.json5所在目录为起点的相对路径
}                                       
```
- 执行安装命令
ohpm install

## 3.hsp依赖
- oh-package.json5中设置
```javascript
"dependencies": {
  // "package" key不能重复 一般取库名
  "package": "file:path/to/package.tgz" // oh-package.json5所在目录为起点的相对路径
}                                       
```
- 执行安装命令
ohpm install

## 4.远程依赖
- 安装私有仓库(可选)
ohpm config set registry your_registry1,your_registry2
- oh-package.json5中设置
```javascript
"dependencies": {
  "@ohos/lottie": "^2.0.0" //注意版本号前面的^
}
```
- 执行安装命令
ohpm install