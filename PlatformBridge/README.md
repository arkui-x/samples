# 以Json模式为例Bridge平台桥接应用示例
## 简介
本示例根据Bridge功能(提供ArkUI侧和原生侧消息通信的功能，包括数据传输、方法调用和事件调用)构建页面组件、布局和逻辑的应用，效果图如下：

* Android平台展示效果：

    | 主页面展示效果                                               | 点击 “sendMessage JSON_TYPE” 按钮展示效果                    | 点击 “callMethod JSON_TYPE” 按钮展示效果                     | 点击 “callMethodWithCallback JSON_TYPE” 按钮展示效果         |
    | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | <img src="./screenshots/devices/android_main.jpg" alt="android_main" style="zoom:20%;" /> | <img src="./screenshots/devices/android_state1.jpg" alt="android_state1" style="zoom:20%;" /> | <img src="./screenshots/devices/android_state2.jpg" alt="android_state2" style="zoom:20%;" /> | <img src="./screenshots/devices/android_state3.jpg" alt="android_state3" style="zoom:18%;" /> |

    

* iOS平台展示效果：

    | 主页面展示效果                                               | 点击 “sendMessage JSON_TYPE” 按钮展示效果                    | 点击 “callMethod JSON_TYPE” 按钮展示效果                     | 点击 “callMethodWithCallback JSON_TYPE” 按钮展示效果         |
    | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | <img src="./screenshots/devices/iOS_main.jpg" alt="iOS_main" style="zoom:22%;" /> | <img src="./screenshots/devices/iOS_state1.jpg" alt="iOS_state1" style="zoom:20%;" /> | <img src="./screenshots/devices/iOS_state2.jpg" alt="iOS_state2" style="zoom:20%;" /> | <img src="./screenshots/devices/iOS_state3.jpg" alt="iOS_state3" style="zoom:20%;" /> |

​		

## 相关概念

* Bridge相关接口文档可参考[ @arkui-x.bridge.d.ts ](https://gitee.com/arkui-x2/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-bridge.md) 。

## 相关权限

不涉及。

## 使用说明

1.打开app，首页面显示三种Bridge模式和其对应的功能按钮。<br/>
2.以Json模式为例，点击调用不同功能的Button按钮，Text内容发生改变。<br/>
3.点击名为sendMessage按钮，Ts侧向原生侧发送数据，原生侧接收成功并返回数据，使用 “原生侧返回结果: ” Text文本接收原生侧返回数据并显示。<br/>
4.点击名为callMethod按钮，Ts侧调用原生侧方法，原生侧方法调用成功并返回结果，使用“原生侧返回结果: ” Text文本接收原生侧返回数据并显示。<br/>
5.点击名为callMethodWithCallback按钮，注册Ts侧方法并调用原生侧方法（在该原生侧方法里调用Ts侧刚注册的方法），原生侧方法调用成功并返回结果，使用“原生侧返回结果: ” Text文本接收原生侧返回数据并显示。同时Ts侧注册方法被调用成功并返回结果，使用 “注册函数被调用结果: ” Text文本接收原生侧返回数据并显示。<br/>

## 约束与限制

1.本示例为跨平台独有功能仅支持在Android\iOS平台上运行。<br/>

2.本示例需要使用DevEco Studio 4.0 Release及以上版本才可编译，Android API 26以上，iOS13版本及以上。<br/>