# ArkUI-X项目跨平台应用示例

## 简介
【示例贡献温馨提示】感谢您关注ArkUI-X项目，如果您希望提交代码样例/示例/Demo，请提交到[Samples仓](https://gitee.com/arkui-x/samples)。再次感谢您的关注！

### 内容简介
为帮助开发者快速熟悉ArkUI-X项目所提供的API和应用开发流程，我们提供了一系列的应用示例，即Sample。每一个应用示例都是一个独立的跨平台应用工程项目，开发者可以使用代码编辑器和[CLI](https://gitee.com/arkui-x/cli)命令行开发工具浏览代码、编译工程、安装和运行应用示例来了解ArkUI跨平台应用开发流程。

### 示例列表

- 基础示例
  - ['HelloWorld'：HelloWorld（API8）](HelloWorld)
- 精品应用
  - ['Shopping'：购物示例应用（API8）](Shopping)
  - ['HealthyDiet'：健康饮食示例应用（API8）](HealthyDiet)

## 目录
Samples仓下所展示的组件能力

```
samples
|---HelloWorld          # HelloWorld
|---Shopping            # 精品应用购物
|---HealthyDiet         # 精品应用健康饮食
```

## 约束

示例贡献需满足CLI命令行应用构建工具要求的工程结构，应用示例编译需遵守各平台应用工程编译打包要求，比如签名等。

## 使用方法

1.  通过[Repo命令](https://gitee.com/arkui-x/manifest/blob/master/README.md)下载ArkUI-X项目所有仓或单独下载Samples仓。
2.  首先进入到跨平台应用示例目录下，比如：HelloWorld目录，然后执行[CLI](https://gitee.com/arkui-x/cli)命令构建跨平台应用。
3.  安装运行后，即可在不同平台设备上查看应用示例运行效果。

## 注意事项
1.  三个例子里的ios/frameworks文件夹下需要手动添加4.0.8.1的SDK文件才可ios编译成功：[下载地址](http://download.ci.openharmony.cn/version/Master_Version/ArkUI-X/20230607052316/arkui_x_darwin_sdk.tar.gz )。
2.  编译安卓apk包时，如出现白屏情况，需将三个例子里的android/app/libs文件夹下需要手动添加4.0.8.1的SDK文件即可解决：[下载地址](http://download.ci.openharmony.cn/version/Master_Version/ArkUI-X/20230607_022130/version-Master_Version-ArkUI-X-20230607_022130-arkui_x_windows_linux_sdk.tar.gz )。
3.  本示例需要使用DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.500, built on April 28, 2023)及以上版本才可编译运行。
4.  本示例已适配ArkUI-X-sdk 的IDE集成SDK，版本号：4.0.8.1。
5.  本示例需要在第二步的基础上下载ohpm相关依赖包，[下载步骤](https://gitee.com/arkui-x/docs/blob/master/zh-cn/application-dev/quick-start/start-with-ace-tools.md#%E5%AE%89%E8%A3%85ohpm%E5%91%BD%E4%BB%A4 )。  
 
## Changlog

应用修改记录：[Changlog](Changelog)

## Releasenote

应用发布版本分支说明：[releasenote](releasenote)

## 相关仓<a name="section17988202503118"></a>

1. [Samples](https://gitee.com/arkui-x/samples) 
2. [CLI](https://gitee.com/arkui-x/cli)