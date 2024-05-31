# 今日头条应用示例

## 简介
本示例是一个帮助用户看见更大的世界的通用信息平台，将优质丰富的信息进行高效精准的分发。
<br>
整体使用Tabs容器设计应用框架，通过TabContent组件设置分页面，在子页面中绘制界面。使用自定义弹窗 设置分享页面。使用stack组件实现主页面和登录弹窗的堆叠。通过不同的url访问不同的页面，包括跳转到应用内的指定页面、同应用内的某个页面替换当前页面、返回上一页面或指定的页面等。
<br>
HTTP数据请求能力接口@ohos.net.http
<br>
页面路由接口@ohos.router
<br>
弹窗接口@ohos.promptAction

#### 注意事项
- 本项目使用http网络请求，请确保设备已连接网络

## 相关概念

不涉及

## 相关权限

ohos.permission.INTERNET


## 使用说明

1. 连接网络获取头条接口链接
2. 首页推荐为新闻列表页，可下滑加载更多
- ![Alt text](screenshots/img_6.png)
- 点击新闻进入详情页
- ![Alt text](screenshots/img_7.png)
- ![Alt text](screenshots/img_9.png)
- 点击分享
- ![Alt text](screenshots/img_10.png)
- 点击点赞
- ![Alt text](screenshots/img_11.png)
- 点击分享
- ![Alt text](screenshots/img_11.png)
- 点击右上方更多图标
- ![Alt text](screenshots/img_12.png)
3. 首页关注
- ![Alt text](screenshots/img_8.png)
4. 视频页
- ![Alt text](screenshots/img_15.png)
- ![Alt text](screenshots/img_16.png)
5. 商城页
- ![Alt text](screenshots/img_13.png)
6. 点击未登录
- ![Alt text](screenshots/img_14.png)

## 约束与限制

	1、本示例支持在Android\iOS\OpenHarmony平台上运行。
    
	2、本示例需要使用DevEco Studio 4.0 Beta2及以上版本才可编译运行。