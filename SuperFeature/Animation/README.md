# 动画samples应用示例
## 介绍
1、本示例通过[ArkUI-X]ace create project 创建的一个跨平台工程，此Sample主要分为5个动画模块：转场动画、Interpolation Calculation插值计算、animateTo 显示动画、animation 属性动画、motionPath 路径动画。

2、其中转场动画又分为：pageTransition 页面间转场、sharedTransition 共享元素转场、多任务、悬浮窗、文件夹展开、系统图标、商店卡片展开、图库卡片展开、component transition 组件内转场、布局动效、尺寸变换动效、侧边栏动效。


## 效果预览
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
|-------------------------------------------------------------------------|----------------------------------------------------------|--------------------------------------------------------------------|
| <img src=screenshots/apk_1.png width=300 height=640 />                  | <img src=screenshots/ios_1.png width=300 height=640 />   | <img src=screenshots/oh_1.png width=300 height=640 />              |
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
| <img src=screenshots/apk_2.png width=300 height=640 />                  | <img src=screenshots/ios_2.png width=300 height=640 />   | <img src=screenshots/oh_2.png width=300 height=640 />              |
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
| <img src=screenshots/apk_3.png width=300 height=640 />                  | <img src=screenshots/ios_3.png width=300 height=640 />   | <img src=screenshots/oh_3.png width=300 height=640 />              |
| Android平台                                                               | iOS平台                                                    | 鸿蒙平台                                                               |
| <img src=screenshots/apk_4.png width=300 height=640 />                  | <img src=screenshots/ios_4.png width=300 height=640 />   | <img src=screenshots/oh_4.png width=300 height=640 />              |

### 使用说明

1.打开应用，点击对应示例进入示例sample

2.转场动画<br>
<blockquote>
2.1 pageTransition 页面间转场，在PageTransitionSample UI模块，定义动画进退场类型，通过router传递 type和旋转缩放参数，然后在PageTransitionSampleTo UI模块接收参数，修改slide、scale、rotate属性值，进行相应展示。<br>
点击不同的按钮，执行对应的页面进场动画效果，再点击“返回页面间转场页面”按钮，可查看页面退场动画效果，存在6种页面转场类别：<br>
<blockquote>
1、顶部进场--底部退场<br>
2、底部进场--顶部退场<br>
3、左侧进场--右侧退场<br>
4、右侧进场--左侧退场<br>
5、缩放进场--缩放退场<br>
6、旋转进场--旋转退场<br>
</blockquote>
2.2 sharedTransition 共享元素转场，在ShareElementTransitionSample UI模块，grid布局，为每个gridItem添加sharedTransition 属性，设置其配置项中的delay、duration、curve、type、motionPath，每个gridItem点击跳转至ShareElementTransitionSampleTo UI模块。
点击页面中八张不同图片，可展示不同的元素转场效果<br>
2.3 多任务，MultiplexSample UI模块是多任务示例的入口；定义ScrollItem UI模块，改变scale、rotate 、translate、opacity 属性值，改变过渡效果。<br>
展示五张图片，对应的五个任务<br>
<blockquote>
1、左右滑动，可进行任务的切换<br>
2、向上滑动，可进行任务的移除<br>
3、向下滑动，可进行任务的缩小<br>
</blockquote>
2.4 悬浮窗，FloatingWindowSample UI模块，利用@ohos.display库计算出当前设备屏幕一半大小的数值，在onTouch事件中，监听手指按下、移动、松开的过程，改变position属性值进行过渡效果, 等待接听图标可实现拖拽，并且一直显示在页面的最上面（与置顶效果一致）<br>
2.5 文件夹展开，在FolderSample UI模块，通过改变元素的width、height、translate属性值进行过渡效果，点击外层文件夹可进行放大展开，展示文件夹中各个图标，点击文件夹外部，可进行缩小<br>
2.6 系统图标，在SystemIcon UI模块，自定义animation和rotate属性，通过改变width、height属性值进行过渡效果，按住可实现上下滑动<br>
2.7 商店卡片展开，在ShopCardSample UI模块，自定义animateTo和transition属性，通过改变zIndex属性值进行过渡效果，点击图片可放大查看，再次点击图片会缩小<br>
2.8 图库卡片展开，点击图片，图片会移动到页面中间放大，再次点击图片移动到最初位置缩小<br>
2.9 component transition 组件内转场，在InterpolationCalculation UI模块，调用Curves接口，定义animation属性，设置每个容器元素的curve分别为initCurvestepCurve、cubicBezierCueve、springCurve，通过修改curve进行过渡效果，点击隐藏按钮，桃心旋转消失，点击显示按钮，桃心再次显示<br>
2.10 布局动效，在LayoutAnimationSample UI模块，设计定时器定时调用animateTo接口修改组件align、direction、position、offset、markAnchor、alignRules、backgroundColor过渡效果，进入页面会自动播放布局动效的效果，并且不同动效展示效果不同<br>
2.11 尺寸变换动效，进入页面会自动播放尺寸动效的效果，并且不同动效展示效果不同<br>
2.12 侧边栏动效，点击展示侧边栏按钮，页面从左边展示侧边栏，点击隐藏侧边栏按钮，侧边栏消失<br>
</blockquote>
3.Interpolation Calculation 插值计算，在InterpolationCalculation UI模块，调用Curves接口，定义animation属性，设置每个容器元素的curve分别为initCurvestepCurve、cubicBezierCueve、springCurve，通过修改curve进行过渡效果，点击Go！进行动效展示<br>
4.animateTo 显示动画，在AnimationToSample UI模块，调用animateTo接口改变配置项中的duration、curve、delay、iterations、playMode、tempo进行过渡效果。<br>
点击对应按钮进行动效展示，包含7种动画按钮：<br>
<blockquote>
1、改变大小<br>
2、改变旋转角度<br>
3、设置动画shrap曲线<br>
4、延时3s<br>
5、播放2次<br>
6、播放速度<br>
7、无限播放<br>
</blockquote>
5.animation 属性动画，点击对应按钮进行动效展示，与animateTo 显示动画一致。<br>
6.motionPath 路径动画，在MotionPathSample UI模块，自定义motionPath属性，调用animateTo接口，添加过渡效果，点击“点击我”按钮，进行动画展示。<br>

## 工程目录
```
entry/src/main/ets
|---common
|   |---IntroductionTitle.ets
|   |---TitleBar.ets
|---entryability
|   |---EntryAbility.ets
|   |---EntryAbility.js
|   |---EntryAbility.js.map
|   |---EntryAbility.ts
|---model
|   |---CategoricalDataType.ets
|---pages
|   |---animateToSample
|   |   |---AnimateToSample.ets                                        // 显式动画
|   |---animationSample
|   |   |---AnimationSample.ets                                        // 属性动画
|   |---interpolationCalculationSample
|   |   |---InterpolationCalculationSample.ets                         // 进度条计算动画
|   |---motionPathSample
|   |   |---MotionPathSample.ets                                       // 路径动画
|   |---TransitionAnimations
|   |   |---componentTransitionSample
|   |   |   |---ComponentTransitionSample.ets                          // 组件内转场动画
|   |   |---floatingSample
|   |   |   |---FloatingWindowComponent.ets
|   |   |   |---FloatingWindowSample.ets                               // 悬浮窗动画
|   |   |---folderSample
|   |   |   |---Folder.ets
|   |   |   |---FolderItem.ets
|   |   |   |---FolderSample.ets                                       // 文件夹展开动画
|   |   |---gallerySample
|   |   |   |---GalleryCardSample.ets                                  // 图库卡片展开动画
|   |   |---layoutAnimationSample
|   |   |   |---LayoutAnimationSample.ets                              // 布局动效动画
|   |   |---multiplexSample
|   |   |   |---MultiplexModel.ets
|   |   |   |---MultiplexSample.ets                                    // 多任务动画
|   |   |   |---ScrollItem.ets
|   |   |---pageTransitionSample
|   |   |   |---PageTransitionSample.ets                               // 页面间转场动画
|   |   |   |---PageTransitionSampleTo.ets
|   |   |---shareElementTransitionSample
|   |   |   |---ShareElementTransitionSample.ets                       // 共享元素转场动画
|   |   |   |---ShareElementTransitionSampleTo.ets
|   |   |---shopSample
|   |   |   |---ShopCardSample.ets                                     // 商店卡片展开动画
|   |   |---sideBarTransitionSample
|   |   |   |---SideBarTransitionSample.ets                            // 侧边栏动效
|   |   |---sizeTransitionSample
|   |   |   |---SizeTransitionSample.ets                               // 尺寸变换动效
|   |   |---systemIcon
|   |   |   |---SystemIcon.ets                                         // 系统图标操作动画
|   |---AnimationData.ets
|   |---index.ets
|---util
|   |---Logger.ts
|   |---ShowToast.ets
```

## 具体实现

* 基本的页面展示封装在Index，源码参考:[Index.ets](entry/src/main/ets/pages/Index.ets)
    * 转场动画模块[TransitionAnimations](entry/src/main/ets/pages/TransitionAnimations)
        * 组件内转场动画[ComponentTransitionSample.ets](entry/src/main/ets/pages/TransitionAnimations/componentTransitionSample/ComponentTransitionSample.ets)：Image的显示和消失配置为不同的过渡效果，出现时从指定的x方向scale为0、y方向scale为1的状态变为默认的x、y方向scale都为1的状态；消失时从默认的旋转角为0变为绕z轴顺时针旋转180°的状态。
        * 悬浮窗动画[FloatingWindowSample.ets](entry/src/main/ets/pages/TransitionAnimations/floatingSample/FloatingWindowSample.ets)：先获取屏幕的宽高，当手指移动时，控制悬浮窗也朝手指的方向移动。当手指离开时，悬浮窗播放移动到屏幕的边缘的动画。
        * 文件夹展开动画[FolderSample.ets](entry/src/main/ets/pages/TransitionAnimations/folderSample/FolderSample.ets)：点击文件夹时，播放图片的宽高放大动画，并使用translate属性使图片向下平移。
        * 图库卡片展开动画[GalleryCardSample.ets](entry/src/main/ets/pages/TransitionAnimations/gallerySample/GalleryCardSample.ets)：点击图片后改变图片的宽度、高度、圆角属性。
        * 布局动效动画[LayoutAnimationSample.ets](entry/src/main/ets/pages/TransitionAnimations/layoutAnimationSample/LayoutAnimationSample.ets)：进入页面后通过改变组件的Padding内边距、Margin外边距、Size大小、Alignment对齐方式、Direction水平布局、Color颜色、HorizontalAlign水平对齐方式，并通过设置动画播放时间达到动态改变布局动效的目的。
        * 多任务动画[MultiplexSample.ets](entry/src/main/ets/pages/TransitionAnimations/multiplexSample/MultiplexSample.ets)：图片左右滑动之后，获取屏幕中央图片的索引，通过scale属性动态放大此图片。当手指操作图片上滑时，图片宽高缩小并从数组中删除此图片，达到删除任务的目的。
        * 页面间转场动画[PageTransitionSample.ets](entry/src/main/ets/pages/TransitionAnimations/pageTransitionSample/PageTransitionSample.ets)：通过在新打开的页面中重写pageTransition()函数，控制新打开的页面从上、下、左、右四个方向打开进入。
        * 共享元素转场动画[ShareElementTransitionSample.ets](entry/src/main/ets/pages/TransitionAnimations/shareElementTransitionSample/ShareElementTransitionSample.ets)：在页面间跳转时，将图片资源传递到要打开的页面，并将图片在要打开的页面中显示。在这个过程中，图片以及动画在屏幕上播放，不会被打断。
        * 商店卡片展开动画[ShopCardSample.ets](entry/src/main/ets/pages/TransitionAnimations/shopSample/ShopCardSample.ets)：点击图片后，动态改变图片的宽高。
        * 侧边栏动效[SideBarTransitionSample.ets](entry/src/main/ets/pages/TransitionAnimations/sideBarTransitionSample/SideBarTransitionSample.ets)：通过开关，控制SideBarContainer组件的showSideBar属性。加入动画播放时间，达到动态控制侧边栏的效果。
        * 尺寸变换动效[SizeTransitionSample.ets](entry/src/main/ets/pages/TransitionAnimations/sizeTransitionSample/SizeTransitionSample.ets)：通过控制组件的宽高、显示隐藏，加入动画播放时间，达到控制组件尺寸变换、淡入淡出的效果。
        * 系统图标操作动画[SystemIcon.ets](entry/src/main/ets/pages/TransitionAnimations/systemIcon/SystemIcon.ets)：通过操作进度条改变图标的大小和颜色。
    * 图表插值计算模块[interpolationCalculationSample](entry/src/main/ets/pages/interpolationCalculationSample)
        * 图标插值计算[InterpolationCalculationSample.ets](entry/src/main/ets/pages/interpolationCalculationSample/InterpolationCalculationSample.ets)：使用cubicBezierCurve设置贝塞尔曲线，点击go按钮后进度条开始按照设置的曲线动效前进。
    * animateTo显式动画[animateToSample](entry/src/main/ets/pages/animateToSample)
        * 显式动画[AnimateToSample.ets](entry/src/main/ets/pages/animateToSample/AnimateToSample.ets)：通过点击按钮后使用animateTo函数改变width、height、rotate等属性达到产生动效的目的。
    * animation属性动画[animationSample](entry/src/main/ets/pages/animationSample)
        * 属性动画[AnimationSample.ets](entry/src/main/ets/pages/animationSample/AnimationSample.ets)：通过在animation属性中设置动画播放方式，当组件的其他属性发生变化时，就会按照设置的播放方式播放。
    * 路径动画[motionPathSample](entry/src/main/ets/pages/motionPathSample)
        * 路径动画[MotionPathSample.ets](entry/src/main/ets/pages/motionPathSample/MotionPathSample.ets)：通过在组件的motionPath属性中设置路径，在点击事件中通过animateTo设置动画效果。点击按钮播放动画，当动画开始播放时组件就会按照设置的路径进行移动。

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
echo /Animation > .git/info/sparse-checkout
git remote add origin https://gitcode.com/arkui-x/samples.git
git pull origin master
```