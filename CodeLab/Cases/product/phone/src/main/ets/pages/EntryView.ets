/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { common } from '@kit.AbilityKit';
import { display, promptAction, window } from '@kit.ArkUI';
import { BusinessError, deviceInfo, emitter } from '@kit.BasicServicesKit';
import {
  BridgeUtil,
  createNWeb,
  GlobalStateDialog,
  GlobalStateDialogManager,
  logger,
  PlatformInfo,
  PlatformTypeEnum,
  PreferenceManager
} from 'utils';
import { DynamicsRouter, FoldableRouter, NavMode } from 'routermodule';
import { SearchComponent } from 'searchcomponent';
import { FunctionalScenes, SceneModuleInfo } from 'functionalscenes';
import { ShareButton } from 'sharebutton';
import { BreakpointConstants } from '../constants/BreakpointConstants';
import { HelperConstants } from '../constants/HelperConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { getwaterFlowData } from '../data/WaterFlowData';
import { HelperView } from '../view/HelperView';
import { HomePageSwiper } from '../view/HomePageSwiper';

/*
 * 案例：需要取消页面路由标题
 * */
const CANCEL_ROUTE_TITLE: string[] = [
  'mediafullscreen/MediaFullScreen', 'fitfordarkmode/FitForDarkMode',
  'foldablescreencases/MusicPlayerPage', 'pageflip/PageFlip',
  'secondfloorloadanimation/SecondFloorLoadAnimation', 'diggingholescreen/DiggingHoleScreen',
  'dynamicattributes/ShoppingCart', 'dynamicattributes/Details',
  'bottomdrawerslidecase/BottomDrawerSlideComponent', 'danmakuplayer/DanmakuVideoDemo',
  'effectKit/MainPage', 'videoscreendirectionswitching/VideoScreenDirectionSwitching',
  'operaterdbintaskpool/OperateRDBInTaskPoolComponent', 'videolistautoplay/VideoListAutoplay',
  'imagecompression/ImageCompression', 'statusbaranimation/StatusBarAnimation', 'groupavatar/GroupAvatarMainPage',
  'groupavatar/GroupAvatarAddPage', 'immersive/ImmersiveView',
  'containernestedslide/NewsDetailPageComponent', 'videocreategif/VideoPlayPage',
  'multiplescreening/MultipleScreening', 'encapsulationdialog/DialogExample', 'videotrimmer/VideoDetail',
  'videotrimmer/VideoUpload', 'clickanimation/ClickAnimationPage', 'shortvideo/ShortVideo',
  'toolbox/ToolBoxComponent'
];

/*
 * 案例：需要设置全屏
 * */
const FULL_SCREEN_COMPONENT: string[] = ['danmakuplayer/DanmakuVideoDemo', 'toolbox/ToolBoxComponent'];

/*
 * 案例：需要在折叠屏展开时全屏显示
 * */
const FULL_SCREEN_ROUTE: string[] = ['foldablescreencases/MusicPlayerPage', 'mediafullscreen/MediaFullScreen',
  'multimodaltransion/HalfModalWindow', 'customscan/CustomScanPage', 'videocache/VideoCacheView',
  'videoscreendirectionswitching/VideoScreenDirectionSwitching', 'collapsemenu/ArticleWebComponent',
  'bluetooth/HeartRate', 'videocreategif/VideoPlayPage', 'sharebutton/MockSharePage'];

/*
 * 案例：需要设置窗口全屏
 * */
const NEED_WINDOW_FULL_SCREEN: string[] = [
  'pageflip/PageFlip', 'customscan/CustomScanPage',
  'diggingholescreen/DiggingHoleScreen', 'effectKit/MainPage', 'immersive/ImmersiveView',
  'mediafullscreen/MediaFullScreen', 'secondfloorloadanimation/SecondFloorLoadAnimation',
  'statusbaranimation/StatusBarAnimation', 'videocreategif/VideoCreateGifView',
  'videoscreendirectionswitching/VideoScreenDirectionSwitching',
  'miniplayeranimation/MiniPlayerAnimation', 'dynamicattributes/ShoppingCart', 'foldablescreencases/MusicPlayerPage',
  'videotrimmer/VideoDetail', 'videotrimmer/VideoUpload', 'clickanimation/ClickAnimationPage',
  'videoscreendirectionswitching/VideoScreenDirectionSwitching', 'shortvideo/ShortVideo'];

const TAG = '[EntryView] ';

/*
 * 从卡片处点击时获取的LocalStorage
 * */
let storage = LocalStorage.getShared();

/*
 * 获取从卡片处点击时的LocalStorage，用于跳转具体案例名称
 * */
@Entry(storage)
@Component
struct EntryView {
  @Provide('pageStack') pageStack: NavPathStack = DynamicsRouter.navPathStack; // Navigation路由栈,控制页面跳转
  @Provide('isFullScreen') isFullScreen: boolean = false; // 是否全屏状态
  @Provide('swiperDisplayCount') swiperDisplayCount: number = 1; // 首页swiper展示item数量
  @Provide @Watch('onHomeOptionPluginButtonClicked') homeOptionPluginButtonClicked: boolean = false; // 侧边栏红点提示
  @StorageLink('formNavigationRouter') formRouter: string = ''; // 卡片方式进入（仅支持HarmonyOS）
  @StorageLink('bottomHeight') bottomHeight: number = 0; // 窗口内容规避的底部安全区高度
  @StorageProp('enterRouteName') enterRouteName: string = ''; // 即将进入的路由名称
  @StorageLink('currentBreakpoint') @Watch('onWindowSizeChange') currentBreakpoint: string = ''; // 界面栅格断点数
  @StorageProp('windowSize') @Watch('onWindowSizeChange') windowSize: window.Size = {
    width: display.getDefaultDisplaySync().width,
    height: display.getDefaultDisplaySync().height
  }; // 窗口尺寸变化的监听事件
  @State listData: SceneModuleInfo[] = getwaterFlowData() // 瀑布流数据源
  @State sideBarIsShow: boolean = false; // 侧边栏是否展示
  @State isMarquee: boolean = false; // Text组件展示文本是否使用跑马灯动效展示
  @State navigationMode: NavigationMode = NavigationMode.Stack; // NavigationMode组件mode形式
  @State @Watch('onModeChange') navMode: NavMode = NavMode.DefaultMode; // 导航栏显示改变模式枚举值
  @State @Watch('onHomeOptionBadgeClicked') homeOptionBadgeClicked: boolean = false; // 侧边栏红点提示
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance(); // 持久化存储实例
  private isSecondPressBack: boolean = false; // 在侧滑退出应用时，用于判断是否第二次滑动
  private isFoldable: boolean = false; // 是否为折叠屏
  private windowClass?: window.Window; // 窗口实例
  private readonly EXIT_TOAST_DURATION: number = 1800; // 侧滑拦截toast提示时长
  private readonly EXIT_PRESS_BACK_DURATION: number = 1000; // 两次侧滑事件间隔时长
  private readonly OPEN_EMULATOR_TOAST_DURATION: number = 2000; // 模拟器打开应用toast提示时长
  private readonly SHARE_TITLE =
    getContext().resourceManager.getStringSync($r('app.string.PhoneAbility_label')); // 分享按钮title
  private readonly verifyCode: string = 'verifycode/VerifyCodeView'; //案例-023
  private readonly shortVideo: string = 'shortvideo/ShortVideo'; //案例-040
  private readonly bottomDrawerSlideCase: string = 'bottomdrawerslidecase/BottomDrawerSlideCase'; //案例-055
  private readonly transitionAnimation: string = 'transitionanimation/TransitionAnimationComponent'; //案例-068
  private readonly multimodaltransion: string = 'multimodaltransion/HalfModalWindow'; //案例-069
  private readonly pageFlip: string = 'pageflip/PageFlip'; //案例-091
  private readonly miniPlayerAnimation: string = 'miniplayeranimation/MiniPlayerAnimation'; //案例-100
  private readonly webPageSnapShot: string = 'webpagesnapshot/WebPageSnapshot'; //案例-101
  private readonly navdestinationdialog: string = 'navdestinationdialog/CommentDialog'; //案例-123
  private readonly statusBarAnimation: string = 'statusbaranimation/StatusBarAnimation'; //案例-141
  private readonly keyboardAvoid: string = 'keyboardavoid/KeyboardAvoidComponent'; //案例-152
  private readonly privacyAgreement: string = 'privacyagreement/PrivacyAgreementComponent'; //案例-165
  private readonly networkstatusobserver: string = 'networkstatusobserver/NetworkStatusObserverComponent' //案例-170
  private readonly shareButton: string = 'sharebutton/MockSharePage'; //案例-180

  aboutToAppear(): void {
    this.preferenceManager.getValue<boolean>('homeOptionBadgeClicked').then((data: boolean | null) => {
      if (data != null) {
        this.homeOptionBadgeClicked = data
      }
    }).catch((err: BusinessError) => {
      logger.error(TAG + 'get homeOptionBadgeClicked Failed, err: ' + err);
    });
    this.preferenceManager.getValue<boolean>('homeOptionPluginButtonClicked').then((data: boolean | null) => {
      if (data != null) {
        this.homeOptionPluginButtonClicked = data
      }
    }).catch((err: BusinessError) => {
      logger.error(TAG + 'get homeOptionPluginButtonClicked Failed, err: ' + err);
    });

    // 首次进入应用判断页面展示类型
    this.navMode = NavMode.HomePageMode;
    // 获取应用窗口实例
    window.getLastWindow(getContext(this)).then((data: window.Window) => {
      this.windowClass = data;
    });
    this.onWindowSizeChange();

    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      this.isFoldable = display.isFoldable();
      // 全局存储折叠屏设备信息
      AppStorage.setOrCreate('isFoldable', this.isFoldable);
      // 设置折叠屏展开态下全屏路由信息
      DynamicsRouter.setFullScreenRoutes(FULL_SCREEN_ROUTE);
    }

    // 虚拟机处理
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      // 获取当前设备外部产品系列
      const marketNameInfo: string = deviceInfo.marketName;
      if (marketNameInfo === 'emulator') {
        promptAction.showToast({
          message: $r('app.string.app_open_emulator_toast_msg'),
          duration: this.OPEN_EMULATOR_TOAST_DURATION
        });
      }
    }

    /*
     * 案例-026 动态路由模块
     * 收到eventId为3的事件后执行回调函数
     * */
    emitter.on({ eventId: 3 }, (params) => {
      if (params.data && params.data.navMode) {
        this.navMode = params.data.navMode;
      }
    });

    /*
     * 案例-037 搜索功能实现
     * 存储初始数据用于搜索筛选
     * */
    AppStorage.setOrCreate('listData', this.listData);

    /*
     * 案例-098 使用预渲染实现Web页面瞬开效果实践
     * TODO：知识点： 默认加载一个空白的Web组件，预先拉起Web渲染进程
     * 更新helperUrl
     * */
    createNWeb('about:// blank', this.getUIContext());
    this.updateHelperUri();

    /*
     * 案例-106 通过全局状态保留弹窗实现评论组件案例
     * 全局状态保留能力弹窗存储UIContext
     * */
    GlobalStateDialogManager.getGlobalStateDialogNodeController().setUIContext(this.getUIContext());

    /*
     * 案例-110 Navigation路由拦截案例
     * 初始化登录状态
     * */
    AppStorage.setOrCreate('login', false);
  }

  onPageShow(): void {
    window.getLastWindow(getContext(this)).then((data: window.Window) => {
      let bottomHeight = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height;
      AppStorage.setOrCreate('bottomHeight', bottomHeight);
    })

    /*
     * 案例-159 图片分享案例
     * 清除分享数据
     * */
    let shareImageUri: string | undefined = AppStorage.get('imageUri');
    if (shareImageUri !== '' && shareImageUri !== undefined) {
      if (DynamicsRouter.appRouterStack.find(item => (item.name === 'shareimagepage/ShareImagePage')) === undefined) {
        DynamicsRouter.pushUri('shareimagepage/ShareImagePage');
      }
    }
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      // 从卡片进入页面时判断具体跳转页面
      if (this.formRouter) {
        getwaterFlowData().forEach((item: SceneModuleInfo) => {
          let index = item.appUri.indexOf(this.formRouter);
          if (index > -1) {
            if (DynamicsRouter.appRouterStack.slice(-1)[0].name !== item.appUri) {
              DynamicsRouter.clear();
              DynamicsRouter.pushUri(item.appUri);
            }
            return;
          }
        })
        this.formRouter = '';
      }
    }
  }

  onBackPress(): boolean {
    // 使用系统侧滑返回或导航条返回键时，若界面侧边栏打开，优先关闭
    if (this.sideBarIsShow) {
      animateTo({
        duration: 300
      }, () => {
        this.sideBarIsShow = false;
      })
      return true;
    }

    // 使用系统侧滑返回或导航条返回键时，优先退出子路由
    if (this.pageStack.size() > 0) {
      DynamicsRouter.popAppRouter();
      return true;
    }

    // 使用系统侧滑返回或导航条返回键时，需在1秒内侧滑两次才能退出应用
    if (this.isSecondPressBack) {
      return false;
    } else {
      this.isSecondPressBack = true;
      setTimeout(() => {
        this.isSecondPressBack = false;
      }, this.EXIT_PRESS_BACK_DURATION);
      promptAction.showToast({
        message: $r('app.string.app_exit_toast_msg'),
        duration: this.EXIT_TOAST_DURATION
      });
      return true;
    }
  }

  onHomeOptionBadgeClicked() {
    this.preferenceManager.setValue('homeOptionBadgeClicked', this.homeOptionBadgeClicked)
  }

  onHomeOptionPluginButtonClicked() {
    this.preferenceManager.setValue('homeOptionPluginButtonClicked', this.homeOptionPluginButtonClicked)
  }

  /*
   * 屏幕尺寸发生改变时触发navMode改变
   * */
  onWindowSizeChange() {
    if (DynamicsRouter.appRouterStack.length > 1 &&
      !FULL_SCREEN_COMPONENT.includes(DynamicsRouter.appRouterStack[1].name)) {
      if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM) {
        this.navMode = NavMode.HomePageMode;
      } else {
        this.navMode = NavMode.FoldMode;
      }
    }
  }

  private isLoadBlackHTML(name: string): void {
    if (name == "mediafullscreen/MediaFullScreen" || "videoscreendirectionswitching/VideoScreenDirectionSwitching") {
      createNWeb($rawfile("blackHTML.html"), this.getUIContext());
    }
  }

  onModeChange() {
    // 获取路由栈最后一个路由的名称
    let lastRouteName = DynamicsRouter.appRouterStack.slice(-1)[0].name;
    if (PlatformInfo.isArkUIX()) {
      this.isLoadBlackHTML(lastRouteName);
    }
    switch (this.navMode) {
      case NavMode.FoldMode: // 当设备折叠态发生改变或屏幕旋转时响应以下逻辑
        if (FULL_SCREEN_ROUTE.includes(lastRouteName)) {
          // 全屏案例在折叠态变化时不需要切换NavigationMode
          this.navigationMode = NavigationMode.Stack;
          break;
        }
        if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM) {
          if (this.pageStack.size() > 0) {
            // 宽屏条件下且展示了子路由，NavigationMode为Split
            this.navigationMode = NavigationMode.Split;
            this.swiperDisplayCount = 1;
          } else {
            // 宽屏条件下且未展示子路由，NavigationMode为Stack
            this.navigationMode = NavigationMode.Stack;
            this.swiperDisplayCount = 2;
          }
        } else {
          this.navigationMode = NavigationMode.Stack;
          this.swiperDisplayCount = 1;
        }
        break;
      case NavMode.ChildPageMode: // 当应用进入子路由时响应以下逻辑
        if (FULL_SCREEN_ROUTE.includes(this.enterRouteName)) {
          // 进入全屏案例需切换为Stack
          this.navigationMode = NavigationMode.Stack;
          break;
        }
        // 根据屏幕宽度决定NavigationMode
        if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM) {
          this.navigationMode = NavigationMode.Split;
        } else {
          this.navigationMode = NavigationMode.Stack;
        }
        this.swiperDisplayCount = 1;
        break;
      case NavMode.HomePageMode: // 当应用返回首页时响应以下逻辑
        if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM) {
          this.navigationMode = NavigationMode.Stack;
          this.swiperDisplayCount = 2;
        } else {
          this.navigationMode = NavigationMode.Stack;
          this.swiperDisplayCount = 1;
          this.isFullScreen = false;
        }
        this.pageStack.disableAnimation(false);
        break;
      default:
        break;
    }
    // 重置NavMode
    if (this.navMode !== NavMode.DefaultMode) {
      this.navMode = NavMode.DefaultMode;
    }
    if (lastRouteName == "EntryView") {
      setTimeout(() => {
        BridgeUtil.getInstance().setStatusBar();
      }, 900)
    }
  }

  getModuleTitle(name: string): null | string {
    let waterFlowData = getwaterFlowData();
    for (let index = 0; index < waterFlowData.length; index++) {
      if (waterFlowData[index].appUri === name) {
        return waterFlowData[index].name;
      }
    }
    if (name === this.privacyAgreement) {
      let value: string | undefined = AppStorage.get('agreementTitle');
      return value!;
    }
    return null;
  }

  updateHelperUri(): void {
    this.listData.forEach((data: SceneModuleInfo) => {
      let moduleName: string = data.appUri.split('/')[0];
      if (data.category.includes('性能示例') && data.name !== '解决相机预览花屏案例') {
        data.helperUrl = HelperConstants.HELPER_URL_PROTOTYPE_PERFERMANCE.replace('{placeholder}', moduleName);
      } else {
        data.helperUrl = HelperConstants.HELPER_URL_PROTOTYPE.replace('{placeholder}', moduleName);
      }
    });
  }

  cancelFullScreen(name: string): void {
    if (NEED_WINDOW_FULL_SCREEN.includes(name)) {
      this.windowClass?.setWindowLayoutFullScreen(false).then(() => {
        this.windowClass?.setWindowSystemBarEnable(['status', 'navigation']);
        if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
          let sysBarProps: window.SystemBarProperties = {
            statusBarContentColor: '#000000'
          };
          this.windowClass?.setWindowSystemBarProperties(sysBarProps);
        }
      })
    }
  }

  /*
   * 创建NavDestination组件
   * */
  @Builder
  pageMap(name: string, param: ESObject) {
    if (CANCEL_ROUTE_TITLE.includes(name)) {
      /*
       * 案例：需要取消页面路由标题
       * */
      NavDestination() {
        // 根据模块名，获取WrappedBuilder对象，通过builder接口创建页面
        DynamicsRouter.getBuilder(name).builder(param);
      }
      .backgroundColor($r('app.color.main_background_color'))
      .hideTitleBar(true)
      .onWillDisappear(() => {
        // 设置了全屏的案例在退出时取消全屏
        this.cancelFullScreen(name);
      })
      .onBackPressed(() => {
        if (name === this.pageFlip || name === this.statusBarAnimation) {
          /*
           * 案例-091 阅读翻页方式
           * 案例-141 状态栏动画实现案例
           * */
          emitter.emit({ eventId: 2 }, { data: { 'backPressed': true } });
          return true;
        } else if (name === this.shortVideo) {
          /*
           * 案例-040 短视频切换
           * */
          emitter.emit({ eventId: 8 }, { data: { 'backPressed': true } });
          return true;
        }
        DynamicsRouter.popAppRouter();
        return true;
      })
    } else if (name === this.multimodaltransion) {
      /*
       * 案例-069 多模态页面转场动效实现
       * */
      NavDestination() {
        // 根据模块名，获取WrappedBuilder对象，通过builder接口创建页面
        DynamicsRouter.getBuilder(name).builder(param);
      }
      .onWillDisappear(() => {
        // 退出时取消全屏
        this.cancelFullScreen(name);
      })
      // 登录页是半模态，需要背景透明，设置为DIALOG
      .mode(NavDestinationMode.DIALOG)
      .hideTitleBar(true)
    } else if (name === this.miniPlayerAnimation) {
      /*
       * 案例-100 音乐播放转场一镜到底效果实现
       * */
      NavDestination() {
        // 根据模块名，获取WrappedBuilder对象，通过builder接口创建页面
        DynamicsRouter.getBuilder(name).builder(param);
      }
      // .padding({ bottom: px2vp(this.bottomHeight) })
      .onShown(() => {
        this.windowClass?.setWindowLayoutFullScreen(true);
      })
      .onWillDisappear(() => {
        // 设置了全屏的案例在退出时取消全屏
        this.cancelFullScreen(name);
      })
      .onBackPressed(() => {
        if (name === this.miniPlayerAnimation || name === this.bottomDrawerSlideCase) {
          emitter.emit({ eventId: 1 }, { data: { 'backPressed': true } });
          return true;
        } else {
          return false;
        }
      })
      .backgroundColor($r('app.color.main_background_color'))
      .hideTitleBar(true)
    } else if (name === this.navdestinationdialog || name === this.shareButton) {
      /*
       * 案例-123 NavDestination弹窗
       * 案例-180 二维码分享案例
       * */
      NavDestination() {
        // 根据模块名，获取WrappedBuilder对象，通过builder接口创建页面
        DynamicsRouter.getBuilder(name).builder(param);
      }
      .onWillDisappear(() => {
        // 设置了全屏的案例在退出时取消全屏
        this.cancelFullScreen(name);
      })
      .onBackPressed(() => {
        emitter.emit({ eventId: 4 }, { data: { 'backPressed': true } });
        DynamicsRouter.popAppRouter();
        return true;
      })
      .mode(NavDestinationMode.DIALOG) // 登录页是半模态，需要背景透明，设置为DIALOG
      .hideTitleBar(true)
    } else if (name === this.keyboardAvoid) {
      /*
       * 案例-152 组件随软键盘弹出避让案例
       * */
      NavDestination() {
        this.navDestinationTitle(name);
        // 根据模块名，获取WrappedBuilder对象，通过builder接口创建页面
        DynamicsRouter.getBuilder(name).builder(param);
      }
      .onWillDisappear(() => {
        // 设置了全屏的案例在退出时取消全屏
        this.cancelFullScreen(name);
      })
      .padding({
        bottom: 64
      })
      .backgroundColor($r('app.color.main_background_color'))
      .hideTitleBar(true)
      .onBackPressed(() => {
        DynamicsRouter.popAppRouter();
        return true;
      })
    } else {
      NavDestination() {
        this.navDestinationTitle(name);
        // 根据模块名，获取WrappedBuilder对象，通过builder接口创建页面
        DynamicsRouter.getBuilder(name).builder(param);
      }
      .onHidden(() => {
        // 设置了全屏的案例在退出时取消全屏
        this.cancelFullScreen(name);
      })
      .padding({
        bottom: 64
      })
      .backgroundColor($r('app.color.main_background_color'))
      .hideTitleBar(true)
      .onBackPressed(() => {
        if (name === this.verifyCode) {
          /*
           * 案例-023 验证码页面
           * */
          emitter.emit({ eventId: 5 }, { data: { 'backPressed': true } });
          return true;
        } else if (name === this.transitionAnimation) {
          /*
           * 案例-068 页面转场一镜到底动画
           * */
          emitter.emit({ eventId: 7 }, { data: { 'backPressed': true } });
          return true;
        }
        DynamicsRouter.popAppRouter();
        return true;
      })
    }
  }

  /*
   * 模块页面顶部导航栏（返回按钮--ModuleTitle--源码网页）
   * */
  @Builder
  navDestinationTitle(name: string) {
    Column() {
      Row() {
        Row() {
          Row() {
            Column() {
              Image($r('app.media.operate_rdb_in_taskpool_arrow_left'))
                .width($r('app.integer.nav_destination_title_image_size'))
            }
            .onClick(() => {
              // 若子路由还发生了跳转,继续返回
              if (this.pageStack.size() > 1) {
                DynamicsRouter.popAppRouter();
                return;
              } else if (name === this.webPageSnapShot || name === this.networkstatusobserver) {
                /*
                 * 案例-101 Web页面长截图
                 * 案例-170 网络状态监听案例
                 * 拦截左上角返回按钮点击事件
                 * */
                let innerEvent: emitter.InnerEvent = { eventId: 6 };
                emitter.emit(innerEvent);
                return;
              }
              DynamicsRouter.popAppRouter();
            })
            .justifyContent(FlexAlign.Center)
            .width($r('app.integer.nav_destination_title_image_background_size'))
            .height($r('app.integer.nav_destination_title_image_background_size'))
            .borderRadius($r('app.integer.nav_destination_title_image_border_radius'))
            .backgroundColor($r('app.color.nav_destination_title_image_background_color'))

            Text(this.getModuleTitle(name))
              .maxLines(1)
              .fontWeight(FontWeight.Bold)
              .fontSize($r('app.integer.nav_destination_title_text_size'))
              .margin({ left: $r('app.integer.nav_destination_title_text_margin') })
              .width(AppStorage.get('isFoldable') ? $r('app.integer.nav_destination_title_text_foldable_width') :
              $r('app.integer.nav_destination_title_text_width'))
              .onDisAppear(() => {
                this.isMarquee = false;
              })
              .onAppear(() => {
                setTimeout(() => {
                  this.isMarquee = true;
                }, 5000)
              })
              .textOverflow(this.isMarquee ? { overflow: TextOverflow.MARQUEE } : { overflow: TextOverflow.None })
              .id('case_name')
          }

          if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
            HelperView({ name: name })
              .visibility(this.getModuleTitle(name) === CommonConstants.PRIVACY_AGREEMENT ||
                this.getModuleTitle(name) === CommonConstants.USER_AGREEMENT ?
              Visibility.None : Visibility.Visible)
          }
        }
        .height($r('app.integer.nav_destination_title_height'))
        .layoutWeight(1)
        .padding({
          left: $r('app.integer.nav_destination_title_padding'),
          right: $r('app.integer.nav_destination_title_padding')
        })
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .backgroundColor($r('app.color.main_background_color'))
      .margin({ bottom: $r('app.integer.nav_destination_title_bottom') })
      .justifyContent(FlexAlign.Center)
      .width('100%')
    }
  }

  /*
   * 侧边栏遮罩层
   * */
  @Builder
  OverlayNode() {
    Row() {
    }
    .onClick(() => {
      animateTo({
        duration: 300
      }, () => {
        this.sideBarIsShow = false;
      })
    })
    .visibility(this.sideBarIsShow ? Visibility.Visible : Visibility.Hidden)
    .width('100%')
    .height('120%')
    .backgroundColor(Color.Black)
    .opacity(0.3)
  }

  build() {
    Stack() {
      SideBarContainer(SideBarContainerType.Overlay) {
        Column() {
          Column({ space: 16 }) {
            Button($r('app.string.privacy_agreement'))
              .width('100%')
              .backgroundColor(Color.White)
              .fontColor(Color.Black)
              .onClick(() => {
                animateTo({
                  duration: 300
                }, () => {
                  this.sideBarIsShow = false;
                })
                let context = getContext() as common.UIAbilityContext
                context.resourceManager.getStringValue($r('app.string.privacy_agreement')).then((data) => {
                  AppStorage.setOrCreate('agreementTitle', data)
                  FoldableRouter.pushUri(this.privacyAgreement, '');
                })
              })

            Button($r('app.string.user_agreement'))
              .width('100%')
              .backgroundColor(Color.White)
              .fontColor(Color.Black)
              .onClick(() => {
                animateTo({
                  duration: 300
                }, () => {
                  this.sideBarIsShow = false;
                })
                let context = getContext() as common.UIAbilityContext
                context.resourceManager.getStringValue($r('app.string.user_agreement')).then((data) => {
                  AppStorage.setOrCreate('agreementTitle', data)
                  FoldableRouter.pushUri(this.privacyAgreement, '');
                })
              })

            if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
              ShareButton({
                url: CommonConstants.AGC_APP_LINK,
                linkTitle: this.SHARE_TITLE
              }) {
                Button($r('app.string.entry_quick_share'))
                  .width('100%')
                  .backgroundColor(Color.White)
                  .fontColor(Color.Black)
              }
            }
          }
          .margin({ top: 30 })

          Text($r('app.string.cases_version_number'))
            .fontSize($r('app.integer.nav_destination_title_padding'))
            .opacity(0.7)
            .margin({ bottom: 5 })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          left: $r('app.integer.nav_destination_title_padding'),
          right: $r('app.integer.nav_destination_title_padding'),
        })
        .backgroundColor($r('app.color.advertising_backgroundColor'))
        .width('100%')
        .height('100%')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

        Navigation(this.pageStack) {
          Column() {
            Row() {
              // 首页搜索组件
              SearchComponent()

              if (this.homeOptionBadgeClicked && this.homeOptionPluginButtonClicked) {
                Image($r('app.media.ic_public_drawer_filled'))
                  .margin({ left: $r('app.integer.privacy_agreement_dialog_button_margin_left') })
                  .width($r('app.integer.advertising_page_font_size'))
                  .height($r('app.integer.advertising_page_font_size'))
                  .onClick(() => {
                    animateTo({
                      duration: 300
                    }, () => {
                      this.sideBarIsShow = true;
                    })
                  })
              } else {
                Badge({
                  value: '',
                  style: { badgeSize: 10, badgeColor: $r('app.color.home_option_badge_color') },
                }) {
                  Image($r('app.media.ic_public_drawer_filled'))
                    .margin({ left: $r('app.integer.privacy_agreement_dialog_button_margin_left') })
                    .width($r('app.integer.advertising_page_font_size'))
                    .height($r('app.integer.advertising_page_font_size'))
                    .onClick(() => {
                      animateTo({
                        duration: 300
                      }, () => {
                        this.sideBarIsShow = true;
                        this.homeOptionBadgeClicked = true;
                      })
                    })
                }
                .padding({
                  right: $r('app.integer.home_option_badge_padding_right')
                })
              }

            }
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              left: $r('app.integer.search_component_search_foldable_padding1'),
              right: $r('app.integer.search_component_search_foldable_padding1')
            })
            .width('100%')

            Scroll() {
              Column() {
                // 首页轮播图组件
                HomePageSwiper()
                // 首页列表组件
                FunctionalScenes({ listData: this.listData })
              }
              .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
            }
            .width('100%')
            .layoutWeight(1)
            .scrollBar(BarState.Off)
            .scrollable(ScrollDirection.Vertical)
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
          }
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
        }
        .overlay(this.OverlayNode())
        .backgroundColor($r('app.color.main_background_color'))
        .hideTitleBar(true)
        .navBarWidth($r('app.string.entry_half_size'))
        .hideNavBar(this.isFullScreen)
        .navDestination(this.pageMap)
        .mode(this.navigationMode)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      }
      .sideBarWidth(180)
      .showSideBar($$this.sideBarIsShow)
      .showControlButton(false)
      .sideBarPosition(SideBarPosition.End)
      .clip(false)

      /*
       * 案例-040 短视频切换
       * 案例-106 通过全局状态保留弹窗实现评论组件案例
       * */
      GlobalStateDialog()
    }
    .alignContent(Alignment.BottomEnd)
    .height('100%')
    .backgroundColor($r('app.color.main_background_color'))
  }
}