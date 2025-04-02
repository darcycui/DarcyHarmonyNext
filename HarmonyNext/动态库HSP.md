# 发布hsp到OpenHarmony三方仓库
# 1.动态共享包 包含代码,资源和配置,C++库
- 不可以独立运行,与宿主HAP同进程,同生命周期
- 不可以独立发布,跟随宿主HAP发布(版本号与HAP一致)

- 应用内HSP:内置包名,只能用于一个应用
- 集成态HSP:不内置包名,可用于多个应用(一般是内部应用)

# 2.特点
- 不包含UIAbility
- 不包含ExtentionAbility
- 不可以独立运行
- 可以依赖其他HAR或HSP,不支持依赖传递
- 可以包含pages页面,可以配置pages页面


# 3.创建动态库
New--Module--New Static Library


# 4.切换为release模式
![](/image/编译模式切换成release模式.png)


# 5.导出
- 通过根目录下Index.ets导出
- 导出组件
- 导出类
- 导出方法
- 导出native方法

# 6.访问资源
通过ResourceManger类管理导出的资源(图片,字符串)

# 7.通过命名路由跳转pages
```javascript
@Entry({ routeName: "pages/shared/context/SharedInnerPage" })
@Component
export struct SharedInnerPage {
    ...
}
```

# 8.跳转pages的其他方法

# 9.

