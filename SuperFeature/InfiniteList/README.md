# InfiniteList应用示例
## 介绍
本示例通过[ArkUI-X] Entry Ability模版创建的一个工程,可通过推拽列表来进行滑动位置。布局中包含三种①颜色资源、②文本索引、③价格标签，三种属性封装在MyDataSource类里，该MyDataSource类继承自BasicDataSource，BasicDataSource类实现了IDataSource接口并提供了许多与数据源相关的方法。
## 效果预览
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
|-------------------------------------------------------------------------|----------------------------------------------------------|--------------------------------------------------------------------|
| <img src=screenshots/apk_1.png width=300 height=640 />                  | <img src=screenshots/ios_1.png width=300 height=640 />   | <img src=screenshots/oh_1.png width=300 height=640 />              |
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
| <img src=screenshots/apk_2.png width=300 height=640 />                  | <img src=screenshots/ios_2.png width=300 height=640 />   | <img src=screenshots/oh_2.png width=300 height=640 />              |

### 使用说明

1、打开应用，首页面显示一个长列表界面，内部有Text、color、price、ListItem等。<br>
2、拖拽页面上下滑动，看到色彩对应的价格，按需迭代去展示刷新到的数据，页面发生改变。<br>
3、每加载200个数据，会提示一次是否继续加载。<br>
## 工程目录
```
entry/src/main/ets
|---bean
|   |---BasicDataSource.ets               // LazyForEach数据源的基础数据类
|   |---InfiniteData.ets                  // 列表item的数据类
|   |---MyDataSource.ets                  // 无限列表自定义数据类
|---entryability
|   |---EntryAbility.ets                  // Ability入口文件
|---pages
|   |---index.ets                         // 首页
```
## 具体实现

* 基本的页面展示封装在Index，源码参考:[Index.ets](entry/src/main/ets/pages/Index.ets)
    * 首页由List和LazyForEach构成。每个ListItem中都包含不同的颜色、文本、价格信息以区分。
    * LazyForEach中的数据来源是[MyDataSource.ets](entry/src/main/ets/bean/MyDataSource.ets)，MyDataSource在初始化时会构建新的颜色和价格。MyDataSource继承自[BasicDataSource.ets](entry/src/main/ets/bean/BasicDataSource.ets)
    * 当首页中的list滑动到底部时，会触发onReachEnd()监听回调，然后弹出弹框询问是否继续加载。如果用户选择确定，那么就会调用[MyDataSource.ets](entry/src/main/ets/bean/MyDataSource.ets)中的setData()函数补充数据，并刷新页面，达到无限列表的效果。

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
echo /InfiniteList > .git/info/sparse-checkout
git remote add origin https://gitee.com/arkui-x/samples.git
git pull origin master
```