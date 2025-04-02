鸿蒙HDC命令.md

- 基本格式 
	hdc -t <conectKey> <command>

- 显示设备(connectkey)
	hdc list targets

- 安装应用 
	hdc -t 127.0.0.1:5555 app install entry-default-signed.hap
	hdc install app entry-default-signed.hap
	hdc install entry-default-signed.hap

- 安装带动态库的应用
	- hdc shell mkdir data/local/tmp/temp
	- hdc shell rm -rf data/local/tmp/temp/*
	- `for %%i in (*.hsp) do hdc file send .%%i data/local/tmp/temp`
	- `for %%i in (*.hap) do hdc file send .%%i data/local/tmp/temp`
	- hdc shell bm install -p data/local/tmp/temp

- 卸载应用
	hdc app uninstall com.darcy.harmonys
	hdc uninstall com.darcy.harmonys

- 杀掉hdc进程
	hdc kill -r

- 重启hdc进程
	hdc start -r

- 查询设备UDID
	hdc shell bm get --udid

- 重启手机
	hdc target boot

- 查看系统版本
	hdc shell param get const.ohos.apiversion

- CPU架构
	$ hdc shell param get const.product.cpu.abilist  

- 分辨率
	hdc shell hidumper -s RenderService -a screen

- 获取应用列表(bundleName)
	hdc shell bm dump -a

- 获取当前页面Ability名称
	hdc shell aa dump -l 
	
- 启动指定应用的Ability
	hdc shell aa start -a {abilityName} -b {bundleName} 
	hdc shell aa start -a EntryAbility -b com.darcy.harmonys

- 结束应用
	hdc shell aa force-stop com.darcy.harmonys

- 获取应用版本
	hdc shell bm dump -n com.darcy.harmonys

- 获取应用详情(权限 版本号 abilities)
	hdc shell bm dump -n com.darcy.harmonys
	
- 清除应用缓存
	hdc shell bm clean -n com.darcy.harmonys -c

- 清除应用数据
	hdc shell bm clean -n com.darcy.harmonys -d

- 发送文件到手机
	hdc file send D:\迅雷下载\Download\a.png /data/local/tmp/a.png

- 从手机拉取文件
	hdc file recv /data/local/tmp/a.png D:\迅雷下载\Download\aa.png

- 截图
	hdc shell uitest screenCap -p /data/local/tmp/1.png
	hdc shell snapshot_display -f /data/local/tmp/2.jpeg

- 录屏(???)
	
- 获取页面布局
	hdc shell uitest dumpLayout -p /data/local/tmp/layout_1.json

- 导出日志
	hdc file recv data/log/hilog/ D:\迅雷下载\Download\

- 导出crash日志
	hdc file recv data/log/faultlog/faultlogger/ D:\迅雷下载\Download\
