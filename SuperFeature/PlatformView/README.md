# PlatformView 平台视图应用示例

## 介绍

本示例使用 PlatformView 功能（原生组件嵌入 ArkUI 界面中）在 ArkUI 界面中使用原生 Mapview , WebView 和 VideoView。

## 效果预览

| Android 平台                                                 |                                                              |                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 主页面展示效果                                               | PlatformView MapView 展示效果                                | PlatformView Webview 展示效果                                | PlatformView Videoview 展示效果                              |
| <img src="./screenshots/android_main.jpg" width =" " alt="android_main" /> | <img src="./screenshots/android_mapview.jpg" alt="android_mapview" /> | <img src="./screenshots/android_webview.jpg" alt="android_webview" /> | <img src="./screenshots/android_videoview.jpg" alt="android_videoview" /> |
| **iOS 平台**                                                 |                                                              |                                                              |                                                              |
| 主页面展示效果                                               | PlatformView MapView 展示效果                                | PlatformView Webview 展示效果                                | PlatformView Videoview 展示效果                              |
| <img src="./screenshots/ios_main.png" alt="ios_main" />      | <img src="./screenshots/ios_mapview.png" alt="ios_mapview" /> | <img src="./screenshots/ios_webview.png" alt="ios_webview" /> | <img src="./screenshots/ios_videoview.png" alt="ios_videoview" /> |
| **harmonyOS 平台**                                                 |                                                              |                                                              |                                                              |
| 主页面展示效果                                               | PlatformView MapView 展示效果                                | PlatformView Webview 展示效果                                | PlatformView Videoview 展示效果                              |
| <img src="./screenshots/harmonyOS_main.jpg" alt="harmonyOS_main" />      | <img src="./screenshots/harmonyOS_mapview.jpg" alt="harmonyOS_mapview" /> | <img src="./screenshots/harmonyOS_webview.jpg" alt="harmonyOS_webview" /> | <img src="./screenshots/harmonyOS_videoview.jpg" alt="harmonyOS_videoview" /> |


### 使用说明

1.打开 app，主页面显示 MapView, WebView 和VideoView对应按钮。

2.点击按钮进入对应界面，加载原生的 MapView , WebView 和VideoView 功能。

## 工程目录

```
.arkui-x
|---android/app/src/main/java/com/example/platformview
|   |---EntryEntryAbilityActivity.java	   			// Android侧注册PlatformViewFactory类
|   |---MyPlatformViewFactory.java					// Android侧PlatformViewFactory接口实现
|   |---MyMapView.java								// Android侧IPlatformView接口实现，加载原生MapView
|   |---MyWebView.java								// Android侧IPlatformView接口实现，加载原生WebView
|   |---MyVideoView.java							// Android侧IPlatformView接口实现，加载原生VideoView
|---/ios/app
|   |---EntryEntryAbilityActivity.m	         		// iOS侧注册PlatformViewFactory类
|   |---MyPlatformViewFactory.h						// iOS侧PlatformViewFactory接口实现
|   |---MyPlatformViewFactory.m						// iOS侧PlatformViewFactory接口实现
|   |---MyMapView.h									// iOS侧IPlatformView接口实现，加载原生MapView
|   |---MyMapView.m									// iOS侧IPlatformView接口实现，加载原生MapView
|   |---MyWebView.h									// iOS侧IPlatformView接口实现，加载原生WebView
|   |---MyWebView.m									// iOS侧IPlatformView接口实现，加载原生WebView
|   |---MyVideoView.h								// iOS侧IPlatformView接口实现，加载原生ViedoView
|   |---MyVideoView.m								// iOS侧IPlatformView接口实现，加载原生ViedoView
entry/src/main/ets
|---entryability
|---pages
|   |---Constants.ets                               // 鸿蒙高德地图常量定义
|   |---harmonyOSPage.ets                           // 鸿蒙系统地图实现
|   |---index.ets                                   // 主页面
|   |---MapShowController.ets                       // 鸿蒙高德地图实现
|   |---MapView.ets									// arkui-x ets侧PlatformView-MapView实现
|   |---WebView.ets									// arkui-x ets侧PlatformView-WebView实现
|   |---VideoView.ets								// arkui-x ets侧PlatformView-VideoView实现
```

## 具体实现

+ 针对Map、Web、Video三种场景分别实现跨平台适配，iOS和Android上通过PlatfromView组件适配,加载iOS和Android的map、web和video组件。harmonyOS使用harmonyOS的map、web和video组件，完整演示三端适配开发案例。
+ PlatformView的实现是ets 侧创建 PlatformView 实例，确保 ID 唯一，用于区分原生组件。
+ 平台侧实现 PlatformView 相关接口。
  + 新建一个实现 IPlatformView 接口的类，并实现 getView 、onDispose() 接口，同时完成原生组件的创建等相关操作。
  + 新建一个实现 PlatformViewFactory 接口的类，并实现 getPlatformView() 接口，根据 ID 创建 IPlatformView 对象。

+ 平台侧注册 PlatformViewFactory 类
  + Android 在继承 StageActivity 的类中，在其 onCreate 方法中创建 PlatformViewFactory 对象，并调用 registerPlatformViewFactory()方法注册。
  + iOS 在继承 ViewController 的类中，在其 viewDidLoad 方法中创建 PlatformViewFactory 对象，并调用 registerPlatformViewFactory()方法注册。
+ PlatformView 相关接口文档参考：[Android](https://gitcode.com/arkui-x/docs/blob/master/zh-cn/application-dev/reference/arkui-for-android/platformview-interface-android.md)，[iOS](https://gitcode.com/arkui-x/docs/blob/master/zh-cn/application-dev/reference/arkui-for-ios/platformview-interface-ios.md)
+ Platformview 平台视图开发指南参考：[Android](https://gitcode.com/arkui-x/docs/blob/master/zh-cn/application-dev/tutorial/how-to-use-platformview-on-android.md)，[iOS](https://gitcode.com/arkui-x/docs/blob/master/zh-cn/application-dev/tutorial/how-to-use-platformview-on-ios.md)

## 相关权限

需要网络权限。

## 约束与限制

1.本示例Web、Viedo、Map均支持 HarmonyOS/Android/iOS三端运行验证。

2.本示例已适配 API version 14以上版本的 ArkUI-X SDK，需要配套 API version 14以上版本的 OpenHarmony SDK。

3.本示例需要使用 API version 14以上版本的 DevEco Studio才可编译运行。

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo /SuperFeature/PlatformView > .git/info/sparse-checkout
git remote add origin https://gitcode.com/arkui-x/samples.git
git pull origin master
```

## FAQ

针对不支持跨平台的HMS API或者组件，参考[如何实现平台差异化(编译态、运行态)](https://gitcode.com/arkui-x/docs/blob/master/zh-cn/application-dev/tutorial/faq/Development-Stage/Dev-faq-9.md)。
