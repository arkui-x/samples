# 仿相册应用示例

## 介绍
本示例通过 ace 创建的跨平台项目，混合开发实现相册的基本功能，可在iOS、Android、OpenHarmony中运行。


主要实现功能：<br>
1、使用ArkTs接口拉起手机原生图库，选择对应的图片，视频<br>
2、展示从原生选择的图片，视频<br>
3、图片详情查看<br>
4、视频文件播放功能

## 效果预览
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
|-------------------------------------------------------------------------|----------------------------------------------------------|--------------------------------------------------------------------|
| <img src=screenshots/apk_1.png width=300 height=640 />                  | <img src=screenshots/ios_1.png width=300 height=640 />   | <img src=screenshots/oh_1.png width=300 height=640 />              |
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
| <img src=screenshots/apk_2.png width=300 height=640 />                  | <img src=screenshots/ios_2.png width=300 height=640 />   | <img src=screenshots/oh_2.png width=300 height=640 />              |
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
| <img src=screenshots/apk_3.png width=300 height=640 />                  | <img src=screenshots/ios_3.png width=300 height=640 />   | <img src=screenshots/oh_3.png width=300 height=640 />              |
### 使用说明
1、进入首页后，有三个按钮，挑选图片，挑选视频，挑选所有媒体资源。点击后，可以调起手机原生图库，选择对应类型的文件<br>
2、选择文件完成后，返回首页，展示从原生选择的图片，视频<br>
3、 图片和视频可点击查看详情。<br>
4、 视频文件显示播放按钮，点击实现播放功能。<br>
```
entry/src/main/ets
|---bean
|   |---MyDataSource.ets
|---common
|   |---Constants.ets
|---entryability
|   |---EntryAbility.ets
|---pages
|   |---DetailPage.ets                     // 详情页
|   |---Index.ets                          // 仿相册首页
```
## 具体实现
* 首页封装在Index，源码参考:[Index.ets](harmony_album/entry/src/main/ets/pages/Index.ets)
    * 在首页中通过photoAccessHelper.PhotoViewPicker的select方法，拉起手机原生图库，选择对应的文件。
* 点击图片或视频后携带数据跳转到展示详情页面[DetailPage.ets](harmony_album/entry/src/main/ets/pages/DetailPage.ets)，以查看图片，播放视频。

## 相关权限
[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionread_media)
本项目使用媒体读取权限。

## 依赖
不涉及 

## 约束与限制

1.本示例仅支持标准Android/iOS/鸿蒙系统上运行。

2.本示例已适配API version 13版本的ArkUI-X SDK，版本号：5.0.1.110。

3.本示例需要使用DevEco Studio 5.0 Beta1 (Build Version: 5.0.3.403, built on June 21, 2024)及以上版本才可编译运行。


 
 
 