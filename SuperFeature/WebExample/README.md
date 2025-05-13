# Web组件Sample应用示例
## 介绍
本示例通过[ArkUI-X] Entry Ability模版创建的一个工程,提供具有网页显示能力的Web组件，@ohos.web.webview提供web能力，实现了一个Web Sample应用。

## 效果预览

|Android平台|iOS平台|鸿蒙平台|
|--------------------------------|--------------------------------|--------------------------------|
|<img src=screenshots/devices/android_main.png width=300 height=640 />|<img src=screenshots/devices/ios_main.png width=300 height=640 />|<img src=screenshots/devices/OH_main.png width=300 height=640 />|

**点击左侧Entries页签**

|Android平台|iOS平台|鸿蒙平台|
|--------------------------------|--------------------------------|--------------------------------|
|<img src=screenshots/devices/android_Entries.png width=300 height=640 />|<img src=screenshots/devices/ios_Entries.png width=300 height=640 />|<img src=screenshots/devices/OH_Entries.png width=300 height=640 />|

**点击左侧Set页签**

|Android平台|iOS平台|鸿蒙平台|
|--------------------------------|--------------------------------|--------------------------------|
|<img src=screenshots/devices/android_Set.png width=300 height=640 />|<img src=screenshots/devices/ios_Set.png width=300 height=640 />|<img src=screenshots/devices/OH_Set.png width=300 height=640 />|

### 使用说明

1、打开应用，首页左侧展示一个菜单栏，菜单栏支持收缩；右侧默认会展示Home标签页，即展示Home页的三个柱状图。<br>
2、点击左侧Entries页签，右侧展示出一个文本列表，文本列表可以进行上下、左右滑动。<br>
3、点击左侧Set页签，右侧展示了一个静态页面，里面有系统设置、账户设置、声音设置、更多设置。<br>

## 工程目录
```
entry/src/main/ets
|---entryability
|   |---EntryAbility.ets                   // Ability入口
|---pages
|   |---index.ets                          // 首页
```

## 具体实现

* 基本的页面展示封装在Index，源码参考:[Index.ets](entry/src/main/ets/pages/Index.ets)。首页中通过Web组件调用并显示html文件，达到在应用中使用网页的效果。
* 原生html文件[index.html](entry/src/main/resources/rawfile/index.html)中定义了三个模块，分别为图标模块、表格模块、设置模块，三个模块都封装在[index.html](entry/src/main/resources/rawfile/index.html)中。
* 在首页中通过调用Web组件，并在Web组件的构造函数中将src设置为index.html，通过这种方式可以在应用中调用网页。

## 相关权限

不涉及


## 依赖

不涉及


## 约束与限制

1.本示例仅支持标准Android/iOS/鸿蒙系统上运行。

2.本示例已适配API version 12版本的ArkUI-X SDK，版本号：2.0.0.27及以上。

3.本示例需要使用DevEco Studio 5.0 Beta1 (Build Version: 5.0.3.403, built on June 21, 2024)及以上版本才可编译运行。



## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo /WebExample > .git/info/sparse-checkout
git remote add origin https://gitcode.com/arkui-x/samples.git
git pull origin master
```

