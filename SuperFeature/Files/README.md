# 读写文件应用示例
## 介绍
本示例通过[ArkUI-X] Entry Ability模版创建的一个工程。
+ 读取本地txt/log/doc文件
+ 文件预览
+ 修改文件
+ 文件保存

## 效果预览
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
|-------------------------------------------------------------------------|----------------------------------------------------------|--------------------------------------------------------------------|
| <img src=screenshots/apk_1.png width=300 height=640 />                  | <img src=screenshots/ios_1.png width=300 height=640 />   | <img src=screenshots/oh_1.png width=300 height=640 />              |
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
| <img src=screenshots/apk_2.png width=300 height=640 />                  | <img src=screenshots/ios_2.png width=300 height=640 />   | <img src=screenshots/oh_2.png width=300 height=640 />              |
### 使用说明

1、打开应用，在中文环境下，首页会显示一个文件管理标题和一个文档按钮，如果英文环境下，首页会显示一个file_manager标题和一个document按钮。<br>
2、点击文档按钮，会自动读取应用本地txt/log/doc文件并显示，如果没有相关的文件，则会创建test文件。<br>
3、在文件项上左滑，会显示编辑按钮，左滑下一个文件项，会显示此文件项的编辑按钮且隐藏上一个文件项编辑按钮。<br>
4、点击编辑按钮，会显示文件的内容且可编辑。<br>
5、修改文件内容，点击确定按钮，会保存所修改的内容，点击返回按钮，不会保存修改内容。<br>
## 工程目录
```
entry/src/main/ets
|---entryability
|   |---EntryAbility.ts
|---file
|   |---pages
|   |   |---common
|   |   |   |---FileList.ets                      // 文件列表页面
|   |   |---document
|   |   |   |---DocumentFileList.ets              // 文档列表页面
|   |   |---utils
|   |   |   |---Utils.ets
|   |   |---FileManagerHome.ets                   // 文件管理首页
|---pages
|   |---EditFile.ets                              // 文件编辑页面
|   |---Index.ets                                 // 首页
```
## 具体实现
* 进入首页[Index.ets](entry/src/main/ets/pages/Index.ets)之后，显示文件列表页面[FileList.ets](entry/src/main/ets/file/pages/common/FileList.ets)。
* 在文件列表页面[FileList.ets](entry/src/main/ets/file/pages/common/FileList.ets)中的文件列表上设置swipeAction属性使文件列表可以滑动。通过itemEnd()函数监听当文件列表滑动到最后时，显示当前滑动的文件的编辑按钮，点击编辑按钮进入编辑页面。
* 在文件编辑页面[EditFile.ets](entry/src/main/ets/pages/EditFile.ets)中，通过TextArea组件来编辑文本。如果用户编辑完成，点击右上角完成按钮后会调用writeSync()函数保存文件到设备中。

## 相关概念

不涉及

## 相关权限

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
echo /Files > .git/info/sparse-checkout
git remote add origin https://gitcode.com/arkui-x/samples.git
git pull origin master
```