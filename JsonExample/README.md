# 反序列化JSON应用示例
## 介绍
本示例通过[ArkUI-X] Entry Ability模版创建的一个工程,实现使用不同的第三方库反序列化json字符串，可通过点击Button按钮反序列化JSON字符串展示内容。

## 效果预览

| Android平台                                              | iOS平台                                                    | 鸿蒙平台                                                               |
|--------------------------------------------------------|----------------------------------------------------------|--------------------------------------------------------------------|
| <img src=screenshots/apk_1.png width=300 height=640 /> | <img src=screenshots/ios_1.png width=300 height=640 />   | <img src=screenshots/oh_1.png width=300 height=640 />              |
| Android平台                                              | iOS平台                                                    | 鸿蒙平台                                                               |
| <img src=screenshots/apk_2.png width=300 height=640 /> | <img src=screenshots/ios_2.png width=300 height=640 />   | <img src=screenshots/oh_2.png width=300 height=640 />              |

### 使用说明

1、打开应用，首页面展示可以使用的反序列化工具单选按钮：GSON库、原生JS；以及需要反序列化的内容选择按钮：自定义数据、查看示例。<br>
2、选择反序列化工具后，点击示例数据或自定义数据

- 点击查看示例

  使用序列化按钮，可以将JSON字符串格式化后的内容展示在页面上，不同页签可以点击或者通过滑动进行切换。<br>

  使用反序列化按钮，可以将JSON字符串反序列化后的结果展示在页面上。<br>

- 点击自定义数据

  在文本框中输入标准格式的JSON字符串，点击序列化按钮，可以将JSON字符串序列化后的内容展示在页面上。<br>

  点击反序列化按钮，可以将JSON字符串反序列化后的结果展示在页面上。<br>

  输入错误格式的JSON字符串会有相关提示。<br>

## 工程目录
```
entry/src/main/ets
|---beans                                       // json实体类
|   |---ComplicatedObject.ets
|   |---SimpleObject.ets
|   |---TabsBean.ets
|---components
|   |---JSONParseContent.ets                    // json反序列化
|   |---JSONStrContent.ets                      // json序列化
|   |---MyTabs.ets                              // 序列化和反序列化容器组件
|---datasource                                  // LazyForEach数据源
|   |---BasicData.ets
|   |---ComplicatedData.ets
|   |---SimpleData.ets
|---entryability
|   |---EntryAbility.ets
|   |---EntryAbility.ts
|---gson
|   |---internal
|   |   |---bind                                // json输入输出调用接口
|   |   |   |---jsonTreeReader.ts
|   |   |   |---jsonTreeWriter.ts
|   |   |   |---typeAdapters.ts
|   |   |---streams.ts
|   |---lang                                    // gson工具类
|   |   |---appendable.ts
|   |   |---gsonIterator.ts
|   |   |---stringBuilder.ts
|   |   |---stringReader.ts
|   |---stream                                  // 解析json输入输出流
|   |   |---jsonReader.ts
|   |   |---jsonReplace.ts
|   |   |---jsonScope.ts
|   |   |---jsonToken.ts
|   |   |---jsonWriter.ts
|   |---gson.ts                                 // gson工具类
|   |---gsonBuilder.ts                          // gson构造器
|   |---index.ts                                // 导出模块，提供调用入口
|   |---jsonArray.ts                            // json数组工具类
|   |---jsonElement.ts                          // json复制工具类
|   |---jsonNull.ts                             // 空json构造器
|   |---jsonObject.ts                           // json构造器
|   |---jsonParser.ts                           // json解析阅读器
|   |---jsonPrimitive.ts                        // 反序列化json工具类
|   |---typeAdapter.ts                          // 类型适配器
|   |---utils.ts
|---pages
|   |---CustomerExample.ets                     // 自定义数据并反序列化页面
|   |---Index.ets                               // json反序列化首页
|   |---JsonExample.ets                         // 反序列化示例页面
|---util
|   |---ConvertJSON.ts                          // 解析json字符串工具类
|   |---Formatter.ts                            // 构造数组类型和对象类型的文本内容工具类
|   |---Index.ts                                // 判断数据的类型是否是数组或基础数据类型工具类
```
## 具体实现

* 首页封装在Index，源码参考:[Index.ets](entry/src/main/ets/pages/Index.ets)
* 点击示例页面按钮后进入示例页面[JsonExample.ets](entry/src/main/ets/pages/JsonExample.ets)，示例页面中每个tab对应一个示例。
    * 如果选择的是gson-ts，则会使用gson的工具类[ConvertJSON.ts](entry/src/main/ets/utils/ConvertJSON.ts)中的fromJsonObject()函数进行序列化或反序列化。
    * 如果选择的是原生js，则会使用js工具类[ConvertJSON.ts](entry/src/main/ets/utils/ConvertJSON.ts)中的convertObjData()函数进行序列化或反序列化。
* 点击自定义数据，跳转到[CustomerExample.ets](entry/src/main/ets/pages/CustomerExample.ets)页面。
    * 如果选择的是gson-ts，输入字符串并点击序列化，则会调用[JSONStrContent.ets](entry/src/main/ets/components/JSONStrContent.ets)组件，在JSONStrContent组件的aboutToAppear()初始化函数中，调用fromJsonObject()函数序列化或反序列化，并将序列化结果显示到页面中。
    * 如果选择的是原生js，输入字符串并点击序列化，则会调用[JSONParseContent.ets](entry/src/main/ets/components/JSONParseContent.ets)组件，在JSONParseContent组件的aboutToAppear()初始化函数中，调用convertObjData()函数序列化或反序列化，并将序列化结果显示到页面中。

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
echo /JsonExample > .git/info/sparse-checkout
git remote add origin https://gitee.com/arkui-x/samples.git
git pull origin master
```