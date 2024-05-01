# Bridge平台桥接应用示例
## 简介
本示例通过[ArkUI-X] ace create project创建的一个跨平台工程

![android_main](./screenshots/devices/android_main.jpg)

![android_state1](./screenshots/devices/android_state1.jpg)

![android_state2](./screenshots/devices/android_state2.jpg)

![android_state3](./screenshots/devices/android_state3.jpg)

## 相关概念

* Bridge

## 相关权限

不涉及。

## 使用说明

1.打开app，首页面显示三种Bridge模式和其对应的功能按钮。<br/>
2.以Json模式为例，点击调用不同功能的Button按钮，Text内容发生改变。<br/>
3.点击名为sendMessage按钮，Ts侧向原生侧发送数据，原生侧接受成功并返回数据，使用 “原生侧返回结果: ” Text文本接受原生侧返回数据并显示。<br/>
4.点击名为callMethod按钮，Ts侧调用原生侧方法，原生侧方法调用成功并返回结果，使用“原生侧返回结果: ” Text文本接受原生侧返回数据并显示。<br/>
5.点击名为callMethodWithCallback按钮，注册Ts侧方法并调用原生侧方法（在该原生侧方法里调用Ts侧刚注册的方法），原生侧方法调用成功并返回结果，使用“原生侧返回结果: ” Text文本接受原生侧返回数据并显示。同时Ts侧注册方法被调用成功并返回结果，使用 “注册函数被调用结果: ” Text文本接受原生侧返回数据并显示。<br/>

## 约束与限制

1.本示例支持在Android\iOS\OpenHarmony平台上运行。

2.本示例需要使用DevEco Studio 4.0 Release及以上版本才可编译运行，Android API 26以上，iOS13版本及以上。