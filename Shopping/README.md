# 购物应用示例
## 简介
本示例是通过CLI命令行直接生成的模板跨平台工程，然后根据购物场景构建页面组件、布局和逻辑。效果图如下：

* Android平台展示效果
![](./screenshots/devices/android_main.jpg)

* iOS平台展示效果
![](./screenshots/devices/ios_main.png)

* OpenHarmomy平台展示效果
![](./screenshots/devices/oh_main.png)
## 相关概念

不涉及

## 相关权限

不涉及。

## 注意事项
1.  本示例里的ios/frameworks文件夹下需要手动添加4.0.8.1的SDK文件才可ios编译成功：[下载地址](http://download.ci.openharmony.cn/version/Master_Version/ArkUI-X/20230607052316/arkui_x_darwin_sdk.tar.gz )。
2.  编译安卓apk包时，如出现白屏情况，需将三个例子里的android/app/libs文件夹下需要手动添加4.0.8.1的SDK文件即可解决：[下载地址](http://download.ci.openharmony.cn/version/Master_Version/ArkUI-X/20230607_022130/version-Master_Version-ArkUI-X-20230607_022130-arkui_x_windows_linux_sdk.tar.gz )。
3.  本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.500, built on April 28, 2023)及以上版本才可编译运行。
4.  本示例已适配ArkUI-X-sdk 的IDE集成SDK，版本号：4.0.8.1。
5.  本示例需要在第二步的基础上下载ohpm相关依赖包，[下载步骤](https://gitee.com/arkui-x/docs/blob/master/zh-cn/application-dev/quick-start/start-with-ace-tools.md#%E5%AE%89%E8%A3%85ohpm%E5%91%BD%E4%BB%A4 )。

## 使用说明

1.打开应用，首页面显示购物场景的首页。

2.点击首页中不同的物品和菜单栏，可进入相应的页面。

## 约束与限制

1.本示例支持在Android\iOS\OpenHarmony平台上运行。

2.本示例需要使用CLI命令行才可编译运行。