# Router路由跳转应用示例 
## 介绍
本示例通过[ArkUI-X] ace create Router创建的一个跨平台工程，来实现通过Navigation接口以及Router接口进行页面的跳转。 

## 效果预览

|Android平台|iOS平台|鸿蒙平台|
|--------------------------------|--------------------------------|--------------------------------|
|<img src=screenshots/devices/android_1.png width=300 height=640 />|<img src=screenshots/devices/ios_1.png width=300 height=640 />|<img src=screenshots/devices/OH_1.png width=300 height=640 />|

**Book页**

|Android平台|iOS平台|鸿蒙平台|
|--------------------------------|--------------------------------|--------------------------------|
|<img src=screenshots/devices/android_2.png width=300 height=640 />|<img src=screenshots/devices/ios_2.png width=300 height=640 />|<img src=screenshots/devices/OH_2.png width=300 height=640 />|

**Authors页**

|Android平台|iOS平台|鸿蒙平台|
|--------------------------------|--------------------------------|--------------------------------|
|<img src=screenshots/devices/android_3.png width=300 height=640 />|<img src=screenshots/devices/ios_3.png width=300 height=640 />|<img src=screenshots/devices/OH_3.png width=300 height=640 />|

**Settings页**

|Android平台|iOS平台|鸿蒙平台|
|--------------------------------|--------------------------------|--------------------------------|
|<img src=screenshots/devices/android_4.png width=300 height=640 />|<img src=screenshots/devices/ios_4.png width=300 height=640 />|<img src=screenshots/devices/OH_4.png width=300 height=640 />|


### 使用说明 
 
1、打开应用，进入登录页面。页面有用户名、密码，Sign in三个部分，页面含有带焦点移动的动画，即焦点在用户名和密码对话框之间切换时，Text文字大小会有变化效果。 <br>
2、点击 Sign in 登录按钮跳转进入主页面，主页面上面的tab组件嵌套在下面tab组件的第一个节点，达到了一个页签上子页面的切换显示效果，上方的Popular、New、All页签可以点击图标进行切换，也可以左右滑动进行切换，下方的Book、Authors、Settings可以点击图标切换进入相应页面。<br>
3、点击相应的书籍可以进入相应的书籍页面，点击浏览作者可以跳转到作者页面。<br>
4、点击Settings设置页面中的Sign out登出按钮，会跳转到登录页面，同时销毁当前页面，防止登出后还能返回上级页面的问题。 <br>
 
## 工程目录
```
entry/src/main/ets
|---component
|   |---ListModelAll.ets              // 所有书籍模块
|   |---ListModelNew.ets              // 最新书籍模块
|   |---ListModelPopular.ets          // 最受欢迎书籍模块
|   |---TitleBar.ets				  // 标题模块
|---entryability
|   |---EntryAbility.ts               // Ability入口
|---pages
|   |---author                        // 作者页面
|   |	|---FirstAuthor.ets			  //
|   |	|---SecondAuthor.ets		  //
|   |	|---ThirdAuthor.ets			  //
|   |---book                          // 书籍页面
|   |	|---FirstBook.ets			  //
|   |	|---FourthBook.ets			  //
|   |	|---SecondBook.ets			  //
|   |	|---ThirdBook.ets			  //
|   |---ContentPage.ets               // 作者页面
|   |---HomePage.ets                  // 主页
|   |---loginPage.ets                 // 登录页面
|   |---RedirectPage.ets              // 首页
```


## 具体实现

* 打开应用后进入首页[RedirectPage.ets](entry/src/main/ets/pages/RedirectPage.ets)，然后直接跳转到登录页面[loginPage.ets](entry/src/main/ets/pages/loginPage.ets)。在登录页面点击登录按钮后跳转到首页[HomePage.ets](entry/src/main/ets/pages/HomePage.ets)。首页包含三个tab，分别为书籍模块、作者模块、设置模块。
    * 书籍模块[book](entry/src/main/ets/pages/book)提供书籍之间的跳转示例。书籍模块提供了最受欢迎的、最新的、全部三个模块，每个模块中有书籍列表。当点击列表中的书籍时，会调用router.pushUrl()函数跳转到目标书籍详情页面。
    * 作者模块[ContentPage.ets](entry/src/main/ets/pages/ContentPage.ets)提供了作者页面跳转的示例。在作者模块中，如果点击对应的作者，则会通过router.pushUrl()的方式跳转到作者详情页面。
    * 设置模块[ContentPage.ets](entry/src/main/ets/pages/ContentPage.ets)提供了退出登录的功能，如果点击退出登录按钮，页面会跳转到登录页面。

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
echo /Router > .git/info/sparse-checkout
git remote add origin https://gitee.com/arkui-x/samples.git
git pull origin master
```