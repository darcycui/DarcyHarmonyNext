cd C:\Android\Sdk\emulator
查看模拟器列表
emulator -list-avds

启动模拟器 可以写system分区
emulator -avd Android12  -writable-system

重新加载分区
adb root
adb remount


adb shell setenforce 0 
adb root
adb disable-verity
adb reboot
adb root
adb remount
原文链接:https://blog.csdn.net/weixin_44714168/article/details/104491261


关闭Selinux
adb shell setenforce 0 //关闭(设置成permissive 模式 
adb shell setenforce 1 //开启(设置成enforce 模式
注意此方法重启后失效

查询当前权限状态
adb shell getenforce
                        
原文链接：https://blog.csdn.net/weixin_31767183/article/details/83306569