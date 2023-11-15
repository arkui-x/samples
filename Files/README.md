# 读写文件应用示例
## 简介
本示例通过[ArkUI-X] Entry Ability模版创建的一个工程。

实现的功能如下：
+ 读取本地txt/log/doc文件；
+ 文件预览；
+ 修改文件；
+ 文件保存；

效果图如下：

* Android平台展示效果
  ![](./screenshots/devices/android_index.png)
  ![](./screenshots/devices/android_fileList.png)
  ![](./screenshots/devices/android_edit.png)
  ![](./screenshots/devices/android_editPage.png)
  ![](./screenshots/devices/android_fileList.png)

* iOS平台展示效果
  ![](./screenshots/devices/ios_index.png)
  ![](./screenshots/devices/ios_fileList.png)
  ![](./screenshots/devices/ios_edit.png)
  ![](./screenshots/devices/ios_editPage.png)
  ![](./screenshots/devices/ios_fileList.png)


* OpenHarmomy平台展示效果
  ![](./screenshots/devices/openHarmomy_index.png)
  ![](./screenshots/devices/openHarmomy_fileList.png)
  ![](./screenshots/devices/openHarmomy_edit.png)
  ![](./screenshots/devices/openHarmomy_editPage.png)
  ![](./screenshots/devices/openHarmomy_fileList.png)

## 相关概念

不涉及

## 相关权限

不涉及。

## 使用说明

1.打开应用，在中文环境下，首页会显示一个文件管理标题和一个文档按钮，如果英文环境下，首页会显示一个file_manager标题和一个document按钮。

2.点击文档按钮，会自动读取应用本地txt/log/doc文件并显示，如果没有相关的文件，则会创建test文件。

3.在文件项上左滑，会显示编辑按钮，左滑下一个文件项，会显示此文件项的编辑按钮且隐藏上一个文件项编辑按钮。

4.点击编辑按钮，会显示文件的内容且可编辑。

5.修改文件内容，点击确定按钮，会保存所修改的内容。

## 约束与限制

1.本示例支持在Android\iOS\OpenHarmony平台上运行。

2.本示例需要使用DevEco Studio 4.0 Release及以上版本才可编译运行。