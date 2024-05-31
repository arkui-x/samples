# Native应用示例
## 简介
本示例通过[ArkUI-X] Native C++模版创建的一个工程,增加了Native中调用ArkTS/TS/JS传入的方法的样例和Native中调用libuv三方库进行简单事件轮询的样例,可通过点击事件改变Text组件展示内容。如下：

* Android平台展示效果如下图：

  ![](./screenshots/devices/android.jpg)

* iOS平台展示效果如下图：
  
  ![](./screenshots/devices/ios.jpg)

* OpenHarmomy平台展示效果如下图：
  
  ![](./screenshots/devices/ohos.jpg)

## 相关概念

不涉及

## 相关权限

不涉及。

## 使用说明

1.打开应用，首页显示三个Text文本和一个Button按钮。

2.点击文字部分，Text内容发生改变，点击按钮，NativeUvLoop result文本变为NativeUvLoop successful。

## 约束与限制

1.本示例支持在Android\iOS\OpenHarmony平台上运行。

2.本示例需要使用DevEco Studio 4.0 Release及以上版本才可编译运行。