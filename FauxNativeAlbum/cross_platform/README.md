# 仿相册应用示例

## 介绍
本示例通过 ace 创建的跨平台项目，混合开发实现相册的基本功能，可在iOS、Android中运行。

注：<br>
cross_platform 目录下的工程支持跨平台<br>
harmony_album 目录下的工程支持OpenHarmony 

主要实现功能：<br>
1、Android/iOS使用原生接口的方式获取本地图片视频的功能<br>
2、OpenHarmony使用ArkTs语法的方式获取本地图片视频功能<br>
3、本地图片根据来源分类展示<br>
4、根据时间显示最近3天、7天、一个月以及全部图片<br>
5、图片详情查看<br>
6、视频文件播放功能

## 效果预览
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
|-------------------------------------------------------------------------|----------------------------------------------------------|--------------------------------------------------------------------|
| <img src=screenshots/apk_1.png width=300 height=640 />                  | <img src=screenshots/ios_1.png width=300 height=640 />   | <img src=screenshots/oh_1.png width=300 height=640 />              |
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
| <img src=screenshots/apk_2.png width=300 height=640 />                  | <img src=screenshots/ios_2.png width=300 height=640 />   | <img src=screenshots/oh_2.png width=300 height=640 />              |
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
| <img src=screenshots/apk_3.png width=300 height=640 />                  | <img src=screenshots/ios_3.png width=300 height=640 />   | <img src=screenshots/oh_3.png width=300 height=640 />              |
### 使用说明
1、进入相册首页后，有两个Tab：图库、相册。其中图库tab可以根据时间来进行分类：全部、3天、7天、一个月；相册tab可以分为：图片、截屏、视频。<br>
2、图库分为全部、3天、7天、一个月，仅展示对应时间段内的图片。<br>
3、 图片和视频可点击查看详情。<br>
4、 相册分为图片和截屏，有视频文件的话还有视频分类。<br>
5、 点击视频文件，实现播放功能。<br>
6、 问题与解决方案<br>
问题：在开发板中遇到获取不到相册的情况？<br>
解决方案：<br>
打开openHarmony中的OpenHarmony\Sdk\12\toolchains\lib，<br>
打开UnsgnedReleasedProfileTemplate.json，将apl的值修改成system_basic，<br>
将app-feature的值修改成hos_system_app<br>
## 工程目录
```
entry/src/main/ets
|---bean
|   |---MyDataSource.ets
|---common
|   |---constants
|   |   |---Constants.ets
|   |---utils
|   |   |---util.js.ets
|---entryability
|   |---EntryAbility.ets
|---pages
|   |---components
|   |   |---TopNavigation.ets              // 导航栏组件
|   |---AlbumTabPage.ets                   // 相册排序页面
|   |---DetailListPage.ets                 // 图片列表页面
|   |---DetailPage.ets                     // 图片详情页
|   |---Index.ets                          // 仿相册首页
|   |---ListPage.ets                       // 图片分类页面
|   |---PhotoRedirect.ets                  // 最近图片页面
|   |---VideoDetailPage.ets                // 视频详情页面
|   |---XcAlbumPage.ets                    // 最近图片排序页面
|---view
|   |---PhotoItem.ets                      // 照片显示组件
|   |---VideoItem.ets                      // 视频显示组件
```
## 具体实现
* 首页封装在Index，源码参考:[Index.ets](harmony_album/entry/src/main/ets/pages/Index.ets)
    * 在首页中通过filterDataByTime()函数，分别获取最近3天、7天、30天、全部的图片和视频。然后在AlbumTabPage页面中解析展示，通过点击近3天、7天、30天、全部的tab来分别显示最近图片。
    * 在首页中通过checkIsScreenshot()函数来区分图片和截屏，通过checkIsVideo()函数来区分视频文件。区分后在首页的分类页面中设置入口。
* 点击图片后携带图片数据跳转到展示图片页面[DetailPage.ets](harmony_album/entry/src/main/ets/pages/DetailPage.ets)，以查看图片。
* 点击视频后携带视频数据跳转到播放视频页面[VideoDetailPage.ets](harmony_album/entry/src/main/ets/pages/VideoDetailPage.ets)，以播放视频。

## 相关权限
[ohos.permission.READ_MEDIA](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionread_media)
本项目使用媒体读取权限。

## 依赖
不涉及 

## 约束与限制

1.本示例仅支持标准Android/iOS/鸿蒙系统上运行。

2.本示例已适配API version 12版本的ArkUI-X SDK，版本号：2.0.0.27及以上。

3.本示例需要使用DevEco Studio 5.0 Beta1 (Build Version: 5.0.3.403, built on June 21, 2024)及以上版本才可编译运行。


 
 
 