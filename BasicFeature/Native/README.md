# Native应用示例
## 介绍
本示例展示[ArkUI-X] Native C++模版创建的工程，增加了Native中调用ArkTS/TS/JS传入的方法的样例和Native中调用libuv第三方库进行简单事件轮询的样例，可通过点击事件改变Text组件展示的内容。

## 效果预览

* Android平台展示效果

  <table>
  <tr>
      <td>
          <center>
              <img src="./screenshots/devices/android_main.jpg">
          </center>
      </td>
      <td>
          <center>
              <img src="./screenshots/devices/android_state.jpg">
          </center>
      </td>
  </tr>
  </table> 

* iOS平台展示效果
  
  <table>
  <tr>
      <td>
          <center>
              <img src="./screenshots/devices/ios_main.jpg">
          </center>
      </td>
      <td>
          <center>
              <img src="./screenshots/devices/ios_state.jpg">
          </center>
      </td>
  </tr>
  </table> 
  
* 鸿蒙平台展示效果
  
  <table>
  <tr>
      <td>
          <center>
              <img src="./screenshots/devices/oh_main.jpg">
          </center>
      </td>
      <td>
          <center>
              <img src="./screenshots/devices/oh_state.jpg">
          </center>
      </td>
  </tr>
  </table> 

### 使用说明

1. 打开应用，首页显示三个Text文本和一个Button按钮。

2. 点击文字部分，Text内容发生改变，点击按钮，NativeUvLoop result文本变为NativeUvLoop successful。

## 工程目录

```
Native
  ├── AppScope                    // App信息配置文件
  ├── entry/src/main
  │   ├── cpp
  │   │   ├── CMakeLists.txt
  │   │   ├── hello.cpp           // 引入uv.h和native_api.h第三方库，自定义方法
  |   │   └── types
  │   |       └── libentry        // so库，将hello.cpp中的方法封装在一个库内
  │   ├── ets
  │   │   ├── entryability        // 应用入口
  │   │   └── pages               // 应用页面
  │   └── resources               // 放置颜色、文字等资源
```

## 具体实现

+ 首先完成so库的实现
  - 新建[hello.cpp](entry/src/main/cpp/hello.cpp)文件，导入需要的第三方库，并编写在页面中需要用到的方法。
  - 在libentry目录下的[index.d.ts](entry/src/main/cpp/types/libentry/index.d.ts)文件中，将编写的方法提取。
  - 在[oh-package.json5](entry/src/main/cpp/types/libentry/oh-package.json5)文件中，配置该so库的名字、版本以及目标文件。

+ 然后完成应用页面的实现
  - 新建[Index.ets](entry/src/main/ets/pages/Index.ets)文件，导入so库中封装好的接口。
  - 新增Text文本组件，并为其添加.onClick()事件，当检测到点击时，调用接口中的方法。

## 相关权限

不涉及。

## 依赖

不涉及。

## 约束与限制

1. 本示例支持在Android\iOS\鸿蒙系统上运行。

2. 本示例已适配API version 12版本ArkUI-X SDK及以上，版本号：2.0.0.27。

3. 本示例需要使用DevEco Studio NEXT Developer Beta1 (Build Version: 5.0.3.403, built on June 20, 2024)及以上版本才可编译运行。

##### 针对CMakeLists.txt的检查说明：

- 代码路径：.arkui-x/android/app/src/main/cpp/CMakeLists.txt

1. 本示例需要配置“ARKUIX_SDK_HOME”的环境变量，用于CMakeLists.txt文件读取ArkUI-X SDK的文件位置。

2. CMakeLists.txt文件中的include路径需要检查对应API下的路径是否存在，例如下面路径，需要有API 12的ArkUI-X SDK存在：

```shell
set(NATIVE_INCLUDE_PATH "$ENV{ARKUIX_SDK_HOME}/12/arkui-x/engine/lib/include/")
```

## 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo /Native > .git/info/sparse-checkout
git remote add origin https://gitcode.com/arkui-x/samples.git
git pull origin master
```

