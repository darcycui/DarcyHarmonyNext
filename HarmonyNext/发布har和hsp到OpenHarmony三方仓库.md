# 发布har到OpenHarmony三方仓库
# 1.库模块中（与src文件夹同一级目录下），添加如下文件
- README.md
- CHANGELOH.md
- LICENSE

# 2.重新编译库模块，生成*.har文件
Build--make Module 'xxx'
在xxxlibrary/build/outputs/xxx/目录下得到.har文件

# 3.生成公、私钥(需要输入密码)
ssh-keygen -m PEM -t RSA -b 4096 -f ~/.ssh_ohpm

# 4.添加公钥
- https://ohpm.openharmony.cn/#/cn/personalCenter/sshKeys
- 登录OpenHarmony三方库中心仓官网，
- 单击主页右上角的个人中心， 
- 新增OHPM公钥，将公钥文件（mykey.pub）的内容粘贴到公钥输入框中

# 5.将对应私钥文件路径配置到 .ohpmrc 文件中
ohpm config set key_path C:\Users\lenovo\.ssh_ohpm\mykey

# 6.将发布码并配置到 .ohpmrc 文件中
- 登录OpenHarmony三方库中心仓官网，
- 单击主页右上角的个人中心，
- 复制发布码 
ohpm config set publish_id 1ZRQ542D4A

# 7.命令发布HAR
ohpm publish D:\Harmony\HAR-HSP\static_library_common.har





