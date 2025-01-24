# ArkUI-X项目跨平台应用示例

## 简介
【示例贡献温馨提示】感谢您关注ArkUI-X项目，如果您希望提交代码样例/示例/Demo，请提交到[Samples仓](https://gitcode.com/arkui-x/samples)。再次感谢您的关注！

### 内容简介
为帮助开发者快速熟悉ArkUI-X项目所提供的API和应用开发流程，我们提供了一系列的应用示例，即Sample。每一个应用示例都是一个独立的跨平台应用工程项目，开发者可以使用DevEco Studio和Ace Tools命令行开发工具浏览代码、编译工程、安装和运行应用示例来了解ArkUI跨平台应用开发流程。

### 示例列表

- 基础示例
  - ['HelloWorld'：HelloWorld（API12）](BasicFeature/HelloWorld)
  - ['Library'：Library（API12）](BasicFeature/Library)
  - ['Native'：Native（API12）](BasicFeature/Native)
  - ['MultiAbility'：MultiAbility（API12）](BasicFeature/MultiAbility)
  
- 功能演示
  - ['Animation'：Animation（API12）](SuperFeature/Animation)
  - ['Files'：Files（API12）](SuperFeature/Files)
  - ['FauxNativeAlbum'：FauxNativeAlbum（API12）](SuperFeature/FauxNativeAlbum)
  - ['InfiniteList'：InfiniteList（API12）](SuperFeature/InfiniteList)
  - ['JsonExample'：JsonExample（API12）](SuperFeature/JsonExample)
  - ['PlatformBridge'：PlatformBridge（API12）](SuperFeature/PlatformBridge)
  - ['Router'：Router（API12）](SuperFeature/Router)
  - ['WebExample'：WebExample（API12）](SuperFeature/WebExample)
  - ['MediaVideo'：MediaVideo（API12）](SuperFeature/MediaVideo)
  - ['PlatformNAPI'：PlatformNAPI（API12）](SuperFeature/PlatformNAPI)
  - ['XcomponentNative'：XcomponentNative（API12）](SuperFeature/XcomponentNative)
  - ['PlatformView'：PlatformView（API14）](SuperFeature/PlatformView)
  - ['WantParamsExample'：WantParamsExample（API16）](SuperFeature/WantParamsExample)

- 精品应用
  - ['Shopping'：购物示例应用（API12）](Solutions/Shopping)
  - ['HealthyDiet'：健康饮食示例应用（API12）](Solutions/HealthyDiet)
  - ['News'：新闻示例应用（API12）](Solutions/News)
- 跨平台改造参考应用
  - ['MultiShopping'：购物应用（API12）](CodeLab/MultiShopping)
  - ['OxHornCampus'：溪村小镇（API12）](CodeLab/OxHornCampus)
  - ['MusicHome'：音乐专辑（API12）](CodeLab/MusicHome)
  - ['HMOSWorld'：鸿蒙世界（API12）](CodeLab/HMOSWorld)

## 目录

Samples仓下所展示的组件能力

```
samples
|---BasicFeature        # 基础示例
  |---HelloWorld          # HelloWorld
  |---Library             # Library
  |---MultiAbility        # MultiAbility
  |---Native              # Native
|---SuperFeature        # 功能演示
  |---Animation           # 场景动画
  |---FauxNativeAlbum     # 相册能力
  |---Files               # 文件读写
  |---InfiniteList        # 无限列表
  |---JsonExample         # 反序列化json字符串
  |---MediaVideo          # 视频播放
  |---PlatformBridge      # 平台桥接
  |---PlatformNAPI        # ArkTs与Native交互能力
  |---Router              # Router页面跳转
  |---WantParamsExample   # WantParams使用
  |---WebExample          # Web组件
  |---XcomponentNative    # OpenGL绘制3D图形
  |---PlatformView        # 平台视图
|---Solutions           # 精品应用
  |---HealthyDiet    	  # 健康饮食
  |---News    	          # 新闻
  |---Shopping    	      # 购物
|---CodeLab             # 跨平台改造参考应用
  |---HMOSWorld           # 鸿蒙世界
  |---MultiShopping    	  # 购物应用
  |---MusicHome           # 音乐专辑
  |---OxHornCampus        # 溪村小镇
```

## 约束

示例贡献需满足跨平台应用构建要求的工程结构，应用示例可通过DevEco Studio和ACE Tools工具编译和运行。

## 使用方法

1.  通过[Repo命令](https://gitcode.com/arkui-x/manifest/blob/master/README.md)下载ArkUI-X项目所有仓或单独下载Samples仓。
2.  利用DevEco Studio打开应用工程，通过Build APP(s)构建，或在应用工程目录下通过ACE Tools命令行工具构建应用。
3.  安装运行后，即可在不同平台设备上查看应用示例运行效果。

## 注意事项

1.  本示例支持在Android\iOS\HarmonyOS NEXT平台上运行。
2.  本示例需要使用DevEco Studio 5.0.0 Release及以上版本或者ArkUI-X SDK 5.0.0 Release及以上版本的Ace Tools命令行工具才可编译运行。


## 相关仓

[Samples](https://gitcode.com/arkui-x/samples)

[CLI](https://gitcode.com/arkui-x/cli)