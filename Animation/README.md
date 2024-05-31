# 动画samples应用示例
## 简介
1、本示例通过[ArkUI-X]ace create project 创建的一个跨平台工程，此Sample主要分为5个动画模块：转场动画、Interpolation Calculation插值计算、animateTo 显示动画、animation 属性动画、motionPath 路径动画。

2、其中转场动画又分为：pageTransition 页面间转场、sharedTransition 共享元素转场、多任务、悬浮窗、文件夹展开、系统图标、商店卡片展开、图库卡片展开、component transition 组件内转场、布局动效、尺寸变换动效、侧边栏动效。

## 相关概念

不涉及

## 相关权限

不涉及

## 使用说明

### 1.打开应用，点击对应示例进入示例sample
![img.png](screenshots%2Fimg.png)

### 2.转场动画
#### 2.1 pageTransition 页面间转场，在PageTransitionSample UI模块，定义动画进退场类型，通过router传递 type和旋转缩放参数，然后在PageTransitionSampleTo UI模块接收参数，修改slide、scale、rotate属性值，进行相应展示。
- 点击不同的按钮，进行对应的页面进场动画效果，再点击“返回页面间转场页面”按钮，可查看页面退场动画效果，存在6种页面转场类别：
	  1、顶部进场--底部退场
	  2、底部进场--顶部退场
	  3、左侧进场--右侧退场
	  4、右侧进场--左侧退场
	  5、缩放进场--缩放退场
	  6、旋转进场--旋转退场
- ![img_2.png](screenshots%2Fimg_2.png)
- ![img_1.png](screenshots%2Fimg_1.png)

#### 2.2 sharedTransition 共享元素转场，在ShareElementTransitionSample UI模块，grid布局，为每个gridItem添加sharedTransition 属性，设置其配置项中的delay、duration、curve、type、motionPath，每个gridItem点击跳转至ShareElementTransitionSampleTo UI模块。
- 点击页面中八张不同图片，可展示不同的元素转场效果
- ![img_3.png](screenshots%2Fimg_3.png)
- ![img_4.png](screenshots%2Fimg_4.png)

#### 2.3 多任务，在MultiplexSample UI模块，是多任务示例的入口；定义ScrollItem UI模块，改变scale、rotate 、translate、opacity 属性值，进行过渡效果。
- 展示五张图片，对应的五个任务

	  1、左右滑动，可进行任务的切换
	  2、向上滑动，可进行任务的移除
	  3、向下滑动，可进行任务的缩小
- ![img_5.png](screenshots%2Fimg_5.png)

#### 2.4 悬浮窗，在FloatingWindowSample UI模块，利用@ohos.display库计算出当前设备屏幕一半大小，在onTouch事件中，监听手指按下、移动、松开的过程，改变position属性值进行过渡效果。
- 等待接听图标可实现拖拽，并且一直显示在页面的最上面（与置顶效果一致）
- ![img_6.png](screenshots%2Fimg_6.png)

#### 2.5 文件夹展开，在FolderSample UI模块，通过改变元素的width、height、translate属性值进行过渡效果。
- 点击外层文件夹可进行放大展开，展示文件夹中各个图标，点击文件夹外部，可进行缩小
- ![img_7.png](screenshots%2Fimg_7.png)
- ![img_8.png](screenshots%2Fimg_8.png)

#### 2.6 系统图标，在SystemIcon UI模块，自定义animation和rotate属性，通过改变width、height属性值进行过渡效果。
- 按住可实现上下滑动
- ![img_9.png](screenshots%2Fimg_9.png)
- ![img_10.png](screenshots%2Fimg_10.png)

#### 2.7 商店卡片展开，在ShopCardSample UI模块，自定义animateTo和transition属性，通过改变zIndex属性值进行过渡效果。
- 点击图片可放大查看，再次点击图片会缩小
- ![img_11.png](screenshots%2Fimg_11.png)

#### 2.8 图库卡片展开
- 点击图片，图片会移动到页面中间放大，再次点击图片移动到最初位置缩小
- ![img_12.png](screenshots%2Fimg_12.png)
- ![img_13.png](screenshots%2Fimg_13.png)

#### 2.9 component transition 组件内转场，在InterpolationCalculation UI模块，调用Curves接口，定义animation属性，设置每个容器元素的curve分别为initCurvestepCurve、cubicBezierCueve、springCurve，通过修改curve进行过渡效果。
- 点击隐藏按钮，桃心旋转消失，点击显示按钮，桃心再次显示
- ![img_14.png](screenshots%2Fimg_14.png)

#### 2.10 布局动效，在LayoutAnimationSample UI模块，设计定时器定时调用animateTo接口修改组件align、direction、position、offset、markAnchor、alignRules、backgroundColor过渡效果。
- 进入页面会自动播放布局动效的效果，并且不同动效展示效果不同
- ![img_15.png](screenshots%2Fimg_15.png)

#### 2.11 尺寸变换动效
- 进入页面会自动播放尺寸动效的效果，并且不同动效展示效果不同
- ![img_16.png](screenshots%2Fimg_16.png)

#### 2.12 侧边栏动效
- 点击展示侧边栏按钮，页面从左边展示侧边栏，点击隐藏侧边栏按钮，侧边栏消失
- ![img_17.png](screenshots%2Fimg_17.png)
- ![img_18.png](screenshots%2Fimg_18.png)

### 3.Interpolation Calculation 插值计算，在InterpolationCalculation UI模块，调用Curves接口，定义animation属性，设置每个容器元素的curve分别为initCurvestepCurve、cubicBezierCueve、springCurve，通过修改curve进行过渡效果。
- 点击Go！进行动效展示
- ![img_19.png](screenshots%2Fimg_19.png)

### 4.animateTo 显示动画，在AnimationToSample UI模块，调用animateTo接口改变配置项中的duration、curve、delay、iterations、playMode、tempo进行过渡效果。
- 点击对应按钮进行动效展示，包含7种动画按钮：

	  1、改变大小
	  2、改变旋转角度
	  3、设置动画shrap曲线
	  4、延时3s
	  5、播放2次
	  6、播放速度
	  7、无限播放
- ![img_20.png](screenshots%2Fimg_20.png)

### 5.animation 属性动画
- 点击对应按钮进行动效展示，与animateTo 显示动画一致
- ![img_21.png](screenshots%2Fimg_21.png)

### 6.motionPath 路径动画，在MotionPathSample UI模块，自定义motionPath属性，调用animateTo接口，添加过渡效果。
- 点击“点击我”按钮，进行动画展示
- ![img_22.png](screenshots%2Fimg_22.png)

## 约束与限制

1、本示例支持在Android\iOS\OpenHarmony平台上运行。

2、本示例需要使用DevEco Studio 4.0 Beta2及以上版本才可编译运行。