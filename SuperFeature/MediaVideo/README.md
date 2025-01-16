# 视频播放应用示例
## 介绍

使用Xcomponent组件及@ohos.multimedia.media 实现播放视频功能。

XComponent控件常用于视频流的显示和游戏画面的绘制，可以配合 ‘@ohos.multimedia.media’相关接口，最终将视频显示到XComponent控件上。

## 效果预览

**应用初始界面**

| Android平台                                                  | iOS平台                                                      | 鸿蒙平台                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src=screenshots/devices/Android1.png width="300" height="650"/> | <img src=screenshots/devices/IOS1.png width="330" height="680"/> | <img src=screenshots/devices/OH1.png width="340" height="650"/> |

**视频播放完毕**

| Android平台                                                  | iOS平台                                                      | 鸿蒙平台                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src=screenshots/devices/Android2.png width="300" height="650" /> | <img src=screenshots/devices/IOS2.png width="330" height="680" /> | <img src=screenshots/devices/OH2.png width="340" height="650"/> |

### 使用说明

应用界面中展示了XComponent相关控件的使用，配合 ‘@ohos.multimedia.media’相关接口实现在XComponent控件上播放视频。可以通过Button控制视频的创建及播放。

1.打开app，首页面显示标题文本、一个Xcomponent控件和四个Button。

2.点击Button “视频源创建”。

3.点击Button “视频源准备”。

4.点击Button “播放”。

5.点击Button “停止并释放资源”。

## 工程目录

```
entry/src/main/ets
|---entryability
|---pages
|   |---index.ets                          // 首页
```


## 具体实现

* media相关接口文档参考[ @ohos.multimedia.media (媒体服务)](https://gitee.com/arkui-x/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-media.md) 
* 资源管理相关接口文档参考[ @ohos.resourceManager (资源管理))](https://gitee.com/arkui-x/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-resource-manager.md) 
* 功能实现
    * 应用启动时，app界面初始化，Xcomponent组件绘制成功时初始化surfaceId。
    * 步骤”视频源创建“：
      1. 使用接口 media.createAVPlayer获取AVPlayer对象。
      2. 视频资源[test.mp4](entry/src/main/resources/rawfile/test.mp4)，使用接口resourceManager.getRawFd获取视频资源信息并提供给AVPlayer对象
    * 步骤”视频源准备”：
      1. AVPlayer属性surfaceId设置surfaceId（数据来源于Xcomponent组件）
      2. 使用接口media.prepare处理视频
    * 步骤”播放“：使用接口media.play播放视频
    * 步骤“停止并释放资源”：使用接口media.release释放AVPlayer对象
* 基本的页面展示封装在Index，源码参考:[Index.ets](entry/src/main/ets/pages/Index.ets)
    * 展示基本的UI界面：Text、Button、Xcomponent组件的基本构造实现
    * 通过按钮的点击事件控制ohos.multimedia.media接口的使用
    * Xcomponent组件负责承载视频的播放

## 相关权限

不涉及。

## 依赖

不涉及。

## 约束与限制

1.本示例仅支持标准Android/iOS/鸿蒙系统上运行。

2.本示例已适配API version 12版本的ArkUI-X SDK，版本号：2.0.0.39及以上，需要配套API version 12版本的OpenHarmony SDK，版本号：5.0.0.36及以上。

3.本示例需要使用DevEco Studio 5.0 Beta1 (Build Version: 5.0.3.403, built on June 21, 2024)及以上版本才可编译运行。

## 下载
如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo /MediaVideo > .git/info/sparse-checkout
git remote add origin https://gitee.com/arkui-x/samples.git
git pull origin master
```