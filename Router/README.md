# Router路由跳转应用示例 
## 简介 
本示例通过[ArkUI-X] ace create Router创建的一个跨平台工程，来实现通过Navigation接口以及Router接口进行页面的跳转。 
 
## 相关概念 
 
* Router 
* Navigator 
 
## 相关权限 
 
不涉及 
 
## 使用说明 
 
- 打开app，有 用户名、密码，Sign in 三个部分 
 
  登录页面含有带焦点移动的动画，即焦点在用户名和密码对话框之间切换时，Text文字大小会有变化效果。 
 
 - ![Alt text](screenshots/img_5.png) 
- 点击 Sign in 登录按钮跳转进入主页面，主页面上面的tab组件嵌套在下面tab组件的第一个节点，达到了一个页签上子页面的切换显示。 
 
	上方的Popular、New、All页签可以点击图标进行切换，也可以左右滑动进行切换。 
 
	下方的Book、Authors、Settings可以点击图标切换进入相应页面。
 - ![Alt text](screenshots/img_1.png) 
- 选择push方式 
 
	点击相应的书籍可以进入相应的书籍页面，点击浏览作者可以跳转到作者页面 
 - ![Alt text](screenshots/img_2.png) 
 - ![Alt text](screenshots/img_3.png) 
- 点击Settings设置页面中的Sign out登出按钮，会跳转到登录页面，同时销毁当前页面，防止登出后还能返回上级页面的问题。 
 - ![Alt text](screenshots/img_4.png) 
 
## 约束与限制 
 
1、本示例支持在Android\iOS\OpenHarmony平台上运行。 
 
2、本示例需要使用DevEco Studio 4.0 Beta2及以上版本才可编译运行。