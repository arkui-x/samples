# 多Ability跳转应用示例
## 简介
本示例通过DevEco Studio创建一个跨平台工程，在此基础上，展示多module之间的ability跳转，
以及同一个module下面的多个ability跳转功能

## 相关概念

* ability
* module

## 相关权限

不涉及。

## 使用说明

1.打开app，点击“Page firstAbility”，会跳转到同一个module下另一个ability的page，显示"Next Ability"。
点击“First Module Ability”，会跳转到另外一个module下的ability的page，显示“Second Module Ability”
2.ios点击左上角back，安卓左滑都可以返回原来ability的page。
3.ios运行时，需要在info->URL Types->URL Schemes里添加包名，例如：com.example.multiability

## 约束与限制

1.本示例支持在Android\iOS\OpenHarmony平台上运行。

2.本示例需要使用DevEco Studio 4.0 Release及以上版本才可编译运行。
