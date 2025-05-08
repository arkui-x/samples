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

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import window from '@ohos.window';
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import display from '@ohos.display';
import { BusinessError } from '@ohos.base';
import webview from '@ohos.web.webview';
import { GlobalContext } from '@ohos/danmakuflamemaster';
import { systemShare } from '@kit.ShareKit';
import { logger, PlatformInfo, PlatformTypeEnum } from 'utils';
import { DynamicsRouter } from 'routermodule';
import {
  addUIContext,
  generateAbilityID,
  registryDocumentViewPickerFn,
  removeUIContext,
  setTopAbilityID
} from 'etswrapper';
import { preloadSOByTaskPool } from 'nativerawfile';
import { SceneModuleInfo } from 'functionalscenes';
import { DataManager, DateModel } from 'customcalendarpickerdialog';
import { BreakpointConstants } from '../constants/BreakpointConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { getwaterFlowData } from '../data/WaterFlowData';

const TAG = '[PhoneAbility] '

/*
 * 案例-065 NAPI封装ArkTS接口案例
 * napi封装ets;步骤一
 * */
registryDocumentViewPickerFn();

export default class PhoneAbility extends UIAbility {
  abilityID: string = generateAbilityID();
  private mainWindow!: window.Window;
  private currentWindowStage: window.WindowStage | null = null;
  private selectPage: string = '';

  /*
   * 更新Breakpoint
   * */
  private updateBreakpoint(windowWidth: number): void {
    let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
    let curBp: string = '';
    if (windowWidthVp < BreakpointConstants.BREAKPOINT_RANGES[1]) {
      curBp = BreakpointConstants.BREAKPOINT_SM;
    } else if (windowWidthVp < BreakpointConstants.BREAKPOINT_RANGES[2]) {
      curBp = BreakpointConstants.BREAKPOINT_MD;
    } else {
      curBp = BreakpointConstants.BREAKPOINT_LG;
    }
    AppStorage.setOrCreate('currentBreakpoint', curBp);
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    logger.info(TAG, 'PhoneAbility onCreate');

    // 全局存储上下文信息
    AppStorage.setOrCreate('context', this.context);
    // 全局设置为浅色模式
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      /*
       * 案例-159 图片分享案例
       * 获取分享的图片数据并存储
       * */
      systemShare.getSharedData(want).then((data: systemShare.SharedData) => {
        data.getRecords().forEach((record: systemShare.SharedRecord) => {
          AppStorage.setOrCreate('imageUri', record.uri)
        });
      })
      // 桌面卡片判断跳转内容
      if (want?.parameters?.params) {
        // want.parameters.params 对应 postCardAction() 中 params 内容
        let params: Record<string, Object> = JSON.parse(want.parameters.params as string);
        this.selectPage = params.targetPage as string;
      }
    }

    /**
     * 案例-011 预加载so并读取RawFile文件
     * 在Ability的onCreate周期函数中和后续的应用声明周期函数中可以使用TaskPool子线程预加载so库，后续通过句柄调用库中的native方法。
     * 此处在Ability的onCreate周期函数中使用TaskPool子线程预加载so库，加载完成后在nativerawfile模块中使用。
     */
    preloadSOByTaskPool();
    GlobalContext.getContext().setValue("path", this.context.filesDir);

    /*
     * 案例-026 动态路由
     * 初始化动态路由
     * */
    DynamicsRouter.routerInit({
      libPrefix: "", mapPath: "routerMap"
    }, this.context);

    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      /*
       * 通过WebviewController可以控制Web组件各种行为。
       * 一个WebviewController对象只能控制一个Web组件，且必须在Web组件和WebviewController绑定后，才能调用WebviewController上的方法（静态方法除外）。
       * */
      webview.WebviewController.initializeWebEngine();
      // 启动预连接，连接地址为即将打开的网址。
      webview.WebviewController.prepareForPageLoad(CommonConstants.REMOTE_URL, true, 1);
    }
  }

  onDestroy(): void {
    logger.info(TAG, 'PhoneAbility onDestroy');
  }

  /*
   * 如果UIAbility已在后台运行，在收到Router事件后会触发onNewWant生命周期回调
   * */
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      if (want.parameters!['ability.params.stream'] !== undefined) {
        AppStorage.setOrCreate('imageUri', want.parameters!["ability.params.stream"].toString());
        return;
      }
      if (want?.parameters?.params) {
        // want.parameters.params 对应 postCardAction() 中 params 内容
        let params: Record<string, Object> = JSON.parse(want.parameters.params as string);
        this.selectPage = params.targetPage as string;
      } else {
        this.selectPage = '';
      }
      if (this.currentWindowStage !== null) {
        //  存在窗口时点击卡片后进行页面跳转
        if (this.selectPage) {
          getwaterFlowData().forEach((item: SceneModuleInfo) => {
            let index = item.appUri.indexOf(this.selectPage);
            if (index > -1) {
              if (DynamicsRouter.appRouterStack.slice(-1)[0].name !== item.appUri) {
                DynamicsRouter.clear();
                DynamicsRouter.pushUri(item.appUri);
              }
              return;
            }
          })
          this.selectPage = '';
        }
      }
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    logger.info(TAG, 'PhoneAbility onWindowStageCreate');
    this.mainWindow = windowStage.getMainWindowSync();

    if (PlatformInfo.isArkUIX()) {
      this.mainWindow.setPreferredOrientation(window.Orientation.PORTRAIT);
    }
    /*
     * 案例-018 深色模式案例
     * 获取当前的颜色模式并保存数据
     * */
    AppStorage.setOrCreate('currentColorMode', this.context.config.colorMode);

    /*
     * 案例-169 悬浮工具箱案例
     * 获取当前的屏幕密度并保存数据
     * */
    AppStorage.setOrCreate('currentScreenDensity', this.context.config.screenDensity);

    /*
     * 案例-026 动态路由
     * 案例-073 应用新功能引导实现
     * 案例-100 音乐播放转场一镜到底效果实现
     * 案例-108 首页下拉进入二楼效果案例
     * 案例-123 NavDestination弹窗
     * avoidAreaChange:  安全区域变化时更新状态栏和导航栏高度
     * */
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      // 安全区域变化时更新状态栏和导航栏高度
      this.mainWindow.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          // 存储窗口内容规避的状态栏高度
          AppStorage.setOrCreate('statusHeight', data.area.topRect.height);
        } else if (data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          // 存储窗口内容规避的底部安全区高度
          AppStorage.setOrCreate('bottomHeight', data.area.bottomRect.height);
        }
      })
    }

    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      // 判断是否存在窗口可进行页面跳转
      if (this.currentWindowStage === null) {
        this.currentWindowStage = windowStage;
      }
      //  点击卡片后进行页面跳转
      if (this.selectPage && AppStorage.get('isConfirmPrivacyAgreement')! === true) {
        AppStorage.setOrCreate('formNavigationRouter', this.selectPage);
        windowStage.loadContent('pages/EntryView', (err, data) => {
          if (err.code) {
            logger.info(TAG, 'Failed to load the content. Cause:', JSON.stringify(err));
            return;
          }
        });
      } else {
        AppStorage.setOrCreate('formNavigationRouter', this.selectPage);
        windowStage.loadContent('pages/AdvertisingPage', (err, data) => {
          if (err.code) {
            logger.info(TAG, 'Failed to load the content. Cause:', JSON.stringify(err));
            return;
          }
          /*
           * 案例-065 NAPI封装ArkTS接口案例
           * napi封装ets;步骤三
           * */
          addUIContext(this.abilityID, this.mainWindow); // napi封装ets
          logger.info(TAG, 'Succeeded in loading the content. Data:', JSON.stringify(data));
        });
      }
    } else if (PlatformInfo.isArkUIX()) {
      windowStage.loadContent('pages/AdvertisingPage', (err, data) => {
        if (err.code) {
          logger.info(TAG, 'Failed to load the content. Cause:' + JSON.stringify(err));
          return;
        }
        /*
         * 案例-065 NAPI封装ArkTS接口案例
         * napi封装ets;步骤三
         * */
        addUIContext(this.abilityID, this.mainWindow);
        logger.info(TAG, 'Succeeded in loading the content. Data:' + JSON.stringify(data));
      });
    }

    /*
     * 案例-030 折叠屏音乐播放器
     * 案例-082 折叠屏扫描二维码方案
     * 案例-108 首页下拉进入二楼效果案例
     * 案例-111 全局弹窗封装案例
     * 获取当前的windowStage实例并保存数据
     * */
    AppStorage.setOrCreate('windowStage', windowStage);

    /*
     * 案例-026 动态路由
     * 案例-134 蓝牙实现服务端和客户端通讯
     * windowSizeChange: 订阅窗口尺寸变化
     * */
    windowStage.getMainWindow().then((data: window.Window) => {
      this.updateBreakpoint(data.getWindowProperties().windowRect.width);
      data.on('windowSizeChange', (windowSize: window.Size) => {
        console.info(`onWindowSizeChange: size = ${JSON.stringify(windowSize)}`);
        AppStorage.setOrCreate('windowSize', windowSize);
        this.updateBreakpoint(windowSize.width);
      })
    })

    /*
     * 案例-034 自定义日历选择器
     * 获取Preferences实例
     * */
    DataManager.getDate(this.context, (dateModel: DateModel) => {
      AppStorage.setOrCreate<DateModel>('selectedDate', dateModel);
    })

    /*
     * 案例-065 NAPI封装ArkTS接口案例
     * napi封装ets;步骤四：
     * */
    setTopAbilityID(this.abilityID, windowStage); // napi封装ets

    /*
     * 案例-134 蓝牙实现服务端和客户端通讯
     * 定义全局方法回调 globalThis.setOrientation
     * */
    globalThis.setOrientation = async (orientation: window.Orientation): Promise<void> => {
      // 设置导航栏、状态栏不显示，从而达到沉浸式效果
      await this.mainWindow.setWindowSystemBarEnable(['status', 'navigation']);
      // 设置窗口的显示方向
      await this.mainWindow.setPreferredOrientation(orientation);
    };

    window.getLastWindow(this.context, (err: BusinessError, windowClass) => {
      if (err.code) {
        logger.error(TAG, 'Failed to obtain top window. Cause:' + JSON.stringify(err));
        return;
      }
      /*
       * 案例-006 瀑布流实现
       * 案例-026 动态路由
       * 案例-073 应用新功能引导实现
       * 案例-100 音乐播放转场一镜到底效果实现
       * 案例-108 首页下拉进入二楼效果案例
       * 案例-123 NavDestination弹窗
       * statusHeight: 窗口内容规避的顶部状态栏高度;获取并存储
       * bottomHeight: 窗口内容规避的底部安全区高度;获取并存储
       * windowsWidth: 窗口宽度(vp单位);获取并存储
       * screenHeight: 当前窗口高度;获取并存储
       * */
      let statusHeight: number = 0;
      let bottomHeight: number = 0;
      let windowWidth: number = 0;
      let screenHeight: number = 0;
      try {
        statusHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height;
        bottomHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height
        // 解决部分Android机型首页布局错乱， 如：小米
        windowWidth = (PlatformInfo.getPlatform() === PlatformTypeEnum.ANDROID)
          ? display.getDefaultDisplaySync().width : windowClass.getWindowProperties().windowRect.width;
        screenHeight = display.getDefaultDisplaySync().height;
      } catch (exception) {
        logger.error(TAG, 'Failed to get Data. Cause:' + JSON.stringify(exception));
      }
      AppStorage.setOrCreate('statusHeight', statusHeight);
      AppStorage.setOrCreate('bottomHeight', bottomHeight);
      AppStorage.setOrCreate('windowsWidth', px2vp(windowWidth));
      AppStorage.setOrCreate('screenHeight', screenHeight);
      logger.info(TAG, 'Window avoid area data, statusHeight is ' + JSON.stringify(statusHeight));
      logger.info(TAG, 'Window avoid area data, bottomHeight is ' + JSON.stringify(bottomHeight));
      logger.info(TAG, "Window data, windowsWidth is " + JSON.stringify(px2vp(windowWidth)));
      logger.info(TAG, 'Window data, screenHeight is ' + JSON.stringify(screenHeight));

      if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
        /*
         * 案例-043 SideBarContainer侧边栏淡入淡出动效实现
         * 案例-102 表情聊天案例
         * 案例-139 编辑收货地址案例
         * TODO: 知识点：设置监听键盘变化，控制虚拟键盘抬起时页面避让
         * keyboardHeight: 当前键盘高度;获取并存储.回调未获取到时设置为0
         * */
        const bottomAvoidArea =
          windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height;
        windowClass.on('keyboardHeightChange', (data) => {
          if (data > 0) {
            AppStorage.setOrCreate('keyboardHeight', data - bottomAvoidArea);
          } else {
            AppStorage.setOrCreate('keyboardHeight', 0);
          }
          logger.info(TAG, 'keyboardHeight data:' + data.toString() + ',bottomAvoidArea:' + bottomAvoidArea.toString());
        })
      }
    });
  }

  onWindowStageDestroy(): void {
    logger.info(TAG, 'PhoneAbility onWindowStageDestroy');
    /*
     * 移除当前windowStage实例缓存
     * */
    AppStorage.delete('windowStage');
    /*
     * 案例-065 NAPI封装ArkTS接口案例
     * napi封装ets;步骤五
     * */
    removeUIContext(this.abilityID);
  }

  onForeground(): void {
    logger.info(TAG, 'PhoneAbility onForeground');
  }

  onBackground(): void {
    /*
     * 案例-159 图片分享案例
     * 清除分享数据
     * */
    AppStorage.set('imageUri', undefined)
  }
}
