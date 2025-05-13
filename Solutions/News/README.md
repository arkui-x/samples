# News应用示例

## 介绍
本示例是一个帮助用户看见更大的世界的通用信息平台，将优质丰富的信息进行高效精准的分发。
<br>
整体使用Tabs容器设计应用框架，通过TabContent组件设置分页面，在子页面中绘制界面。使用自定义弹窗设置分享页面。使用stack组件实现主页面和登录弹窗的堆叠。通过不同的url访问不同的页面，包括跳转到应用内的指定页面、同应用内的某个页面替换当前页面、返回上一页面或指定的页面等。



## 效果预览
| Android平台                                                                 | iOS平台                                                      | 鸿蒙平台                                                                 |
|---------------------------------------------------------------------------|------------------------------------------------------------|----------------------------------------------------------------------|
| <img src=screenshots/apk_1.png width=300 height=640 />                    | <img src=screenshots/ios_1.png width=300 height=640 />     | <img src=screenshots/oh_1.png width=300 height=640 />                |
| Android平台                                                                 | iOS平台                                                      | 鸿蒙平台                                                                 |
| <img src=screenshots/apk_2.png width=300 height=640 />                    | <img src=screenshots/ios_2.png width=300 height=640 />     | <img src=screenshots/oh_2.png width=300 height=640 />                |
| Android平台                                                                 | iOS平台                                                      | 鸿蒙平台                                                                 |
| <img src=screenshots/apk_3.png width=300 height=640 />                    | <img src=screenshots/ios_3.png width=300 height=640 />     | <img src=screenshots/oh_3.png width=300 height=640 />                |
| Android平台                                                                 | iOS平台                                                      | 鸿蒙平台                                                                 |
| <img src=screenshots/apk_4.png width=300 height=640 />                    | <img src=screenshots/ios_4.png width=300 height=640 />     | <img src=screenshots/oh_4.png width=300 height=640 />                |
| Android平台                                                                 | iOS平台                                                      | 鸿蒙平台                                                                 |
| <img src=screenshots/apk_5.png width=300 height=640 />                    | <img src=screenshots/ios_5.png width=300 height=640 />     | <img src=screenshots/oh_5.png width=300 height=640 />                |
| Android平台                                                                 | iOS平台                                                      | 鸿蒙平台                                                                 |
| <img src=screenshots/apk_6.png width=300 height=640 />                    | <img src=screenshots/ios_6.png width=300 height=640 />     | <img src=screenshots/oh_6.png width=300 height=640 />                |
| Android平台                                                                 | iOS平台                                                      | 鸿蒙平台                                                                 |
| <img src=screenshots/apk_7.png width=300 height=640 />                    | <img src=screenshots/ios_7.png width=300 height=640 />     | <img src=screenshots/oh_7.png width=300 height=640 />                |
| Android平台                                                                 | iOS平台                                                      | 鸿蒙平台                                                                 |
| <img src=screenshots/apk_8.png width=300 height=640 />                    | <img src=screenshots/ios_8.png width=300 height=640 />     | <img src=screenshots/oh_8.png width=300 height=640 />                |
| Android平台                                                                 | iOS平台                                                      | 鸿蒙平台                                                                 |
| <img src=screenshots/apk_9.png width=300 height=640 />                    | <img src=screenshots/ios_9.png width=300 height=640 />     | <img src=screenshots/oh_9.png width=300 height=640 />                |

### 使用说明
1.连接网络获取新闻接口链接<br>
2.首页推荐为新闻列表页，可下滑加载更多<br>
- 点击新闻进入详情页
- 点击分享，弹出分享选项
- 点击点赞，为文章点赞
- 点击右上方更多图标，弹出选项
3.点击关注，进入关注页面<br>
4.点击视频，进入视频页面<br>
5.点击商城，进入商城页面<br>
6.点击未登录，进入登录页面<br>
## 工程目录
```
entry/src/main/ets
|---entryability					
|   |---EntryAbility.ets			// Ability入口
|---pages             				
|   |---components                  
|   |	|---LogIn.ets				// 登录页面
|   |	|---OfflinePage.ets			// 无网络页面
|   |	|---TopSearch.ets			// 搜索栏组件
|   |---news                 		
|   |	|---NewHomeItem.ets	        // 新闻列表组件
|   |	|---NewHomePage.ets	        // 新闻首页
|   |	|---NewsDetail.ets	        // 新闻详情页面
|   |	|---NewsLazy.ets	        // 新闻数据源
|   |---util                  		
|   |	|---Common.ets				// 公共工具类
|   |	|---Mock.ets				// 模拟数据工具类
|   |	|---Request.ets				// 网络请求工具类
|   |---video                  		
|   |	|---VideoDetail.ets			// 视频播放页面
|   |	|---VideoItem.ets			// 视频列表
|   |	|---VideoLazy.ets			// 视频数据源
|   |	|---VideoPage.ets			// 视频推荐页面
```


## 具体实现

* 基本的页面展示封装在Index，源码参考:[Index.ets](entry/src/main/ets/pages/Index.ets)
    * 进入首页之后自动打开[NewHomePage.ets](entry/src/main/ets/pages/news/NewHomePage.ets)首页tab。
        * 进入NewHomePage后通过homePageRequest()函数请求网络数据，如果请求失败则显示网络异常页面，如果请求成功则显示新闻列表。
        * 新闻列表由[NewHomeItem.ets](entry/src/main/ets/pages/news/NewHomeItem.ets)解析并显示。
        * 如果点击新闻列表中的某一条新闻，在NewHomeItem页面中会通过skipRouter()函数传递url数据并跳转到新闻详情页面[NewsDetail.ets](entry/src/main/ets/pages/news/NewsDetail.ets)。
        * 如果监听到新闻列表滑动到最下面，则会在[NewHomePage.ets](entry/src/main/ets/pages/news/NewHomePage.ets)中自动调用homePageRequest()函数请求加载新的新闻数据。
    * 进入视频页面之后自动打开[VideoPage.ets](entry/src/main/ets/pages/video/VideoPage.ets)视频tab。
        * 视频tab页面分为两种显示情况，分别是有网络[VideoItem.ets](entry/src/main/ets/pages/video/VideoItem.ets)和无网络页面[OfflinePage.ets](entry/src/main/ets/pages/components/OfflinePage.ets)。
        * 视频列表的实现方式为在[VideoPage.ets](entry/src/main/ets/pages/video/VideoPage.ets)中通过LazyForEach解析显示VideoItem。
        * 当视频列表滑动到最下面时，通过onReachEnd()监听到滑到结束位置之后，自动调用homePageRequest('video')函数请求更新视频数据。
        * 点击视频则调用[VideoItem.ets](entry/src/main/ets/pages/video/VideoItem.ets)文件中的onClick()回调开始播放，当滑动视频列表时通过onVisibleAreaChange()回调监听视频是否可见，如果视频不可见则调用stop()函数停止播放。
    * 点击商城tab后显示[Index.ets](entry/src/main/ets/pages/Index.ets)页面中的自定义组件ShopLogIn()，显示内容为您还没有登录账号。
    * 点击登录tab后显示[LogInPage.ets](entry/src/main/ets/pages/LogInPage.ets)登录页面。


## 相关权限
[ohos.permission.INTERNET](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissioninternet)
- 本项目使用http网络请求，请确保设备已连接网络



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
echo /News > .git/info/sparse-checkout
git remote add origin https://gitcode.com/arkui-x/samples.git
git pull origin master
```