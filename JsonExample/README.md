# 反序列化JSON应用示例
## 简介
本示例通过[ArkUI-X] Entry Ability模版创建的一个工程,实现使用不同的第三方库反序列化json字符串，可通过点击Button按钮反序列化JSON字符串展示内容。效果图如下：

* Android平台展示效果
  ![](./screenshots/devices/android_main.png) ![](./screenshots/devices/android_deserialize.png)

* iOS平台展示效果
  ![](./screenshots/devices/ios_main.png) ![](./screenshots/devices/ios_deserialize.png)

* OpenHarmony平台展示效果
  ![](./screenshots/devices/oh_main.png) ![](./screenshots/devices/oh_deserialize.png)

## 相关概念

不涉及

## 相关权限

不涉及

## 使用说明

1、打开应用，首页面展示可以使用的反序列化工具单选按钮：GSON库、原生JS；以及需要反序列化的内容选择按钮：自定义数据、查看示例。

2、选择反序列化工具后，点击示例数据或自定义数据

- 点击查看示例

	使用序列化按钮，可以将JSON字符串格式化后的内容展示在页面上，以便于梳理数据结构，不同页签可以点击或者通过滑动进行切换。

	使用反序列化按钮，可以将JSON字符串反序列化厚的结果意义展示在页面上。

- 点击自定义数据

	在文本框中输入标准格式的JSON字符串，点击序列化按钮，可以将JSON字符串序列化后的内容展示在页面上。

	点击反序列化按钮，可以将JSON字符串反序列化厚的结果展示在页面上。

	输入错误格式的JSON字符串是会有相关提示。



## 约束与限制

1、本示例支持在Android\iOS\OpenHarmony平台上运行。

2、本示例需要使用DevEco Studio 4.0 Beta2及以上版本才可编译运行。