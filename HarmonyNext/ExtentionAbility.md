# ExtentionAbility
## 1. 是什么
UI窗口,用于特殊交互(卡片/输入法/分享/备份/嵌入等)

## 2. 特点
- 不能由应用启动(系统启动)
- 调用方不用关心其生命周期(系统维护)
- 可以使用,可以自定义已有类型,不可以拓展新类型
- 与UIAbility不在同一个进程,运行在独立进程A
- 应用内的同一种ExtentionAbility运行在同一个独立进程 (ServiceExtensionAbility、DataShareExtensionAbility除外)
- 应用内不同的ExtentionAbility运行在不同的独立进程

## 3. 包括
- FormExtentionAbility 服务卡片
- WorkShedualerExtentionAbility 后台工作调度
- InputExtentionAbility 输入法
- BackupExtentionAbility 备份
- DriverExtentionAbility 驱动
- ShareExtentionAbility 分享
- EmbedExtentionAbility 嵌入

## 4. 开发嵌入ExtentionAbility并使用

### 4.1 提供方

### 4.2 调用方


## 5. 


## 6. 

