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

import { promptAction, window } from '@kit.ArkUI';
import { Constants } from '../contants/Constants';
import { LIST_DATA } from '../mock/Mock';
import WindowModel from '../model/WindowModel';
import LazyDataSource from '../model/LazyDataSource';
import { Model } from '../model/Model';
import { Banner } from './Banner';
import { ArticlesList } from './ArticlesList';
import { logger, PlatformInfo, PlatformTypeEnum } from 'utils';
import { DynamicsRouter } from 'routermodule';

const TAG = '[StatusBarAnimation]';

/**
 * 功能描述: 本案例展示了状态栏的动态交互效果。通过监听页面滚动事件 onDidScroll，随着页面的上下滚动，实现状态栏颜色的变化。搜索框会在滚动时流畅地展开或收起，并伴有自然的透明度过渡效果。
 *
 * 推荐场景: 页面滚动时状态栏和搜索框需要流畅过渡动效的场景
 *
 * 核心组件:
 * 1. WindowModel
 *
 * 实现步骤：
 * 1. 初始化和状态设置。在 aboutToAppear() 方法中，初始化了窗口模型 windowModel。启用沉浸式（设置全屏显示和状态栏为白色），获取状态栏高度存储在 statusBarHeight 变量中，从预定义的数据源 LIST_DATA 加载数据到 dataSource中。
 * 2. 界面布局构造。使用Stack控件使状态栏与列表重叠，并为列表添加滚动监听器，以根据滚动位置调整状态栏和导航栏的透明度及展开收起动效。
 * 3. 滚动事件处理。通过监听页面滚动事件 onDidScroll，根据当前的滚动偏移量 yOffset 调整状态栏和导航栏的透明度。如果滚动超过了设定的阈值，则改变状态栏的颜色和展开收起动画。
 */
@Component
export struct StatusBarAnimationComponent {
  @State statusBarHeight: number = 0; // 顶部状态栏高度
  @State navigateBarOpacity: number = 0; // 顶部状态栏透明度
  @State isWhiteColor: boolean = true; // 状态栏是否为白色
  @State isFlow: boolean = false; // 搜索框是否收起
  @State negativeOffsetY: number = 0; // List向下拉到顶后继续上拉为负数的偏移量
  @State isTop: boolean = false; // 是否通过按钮点击回到顶部
  @State dataSource: LazyDataSource<Model> = new LazyDataSource();
  private scroller: ListScroller = new ListScroller();
  private windowModel: WindowModel = WindowModel.getInstance(); // 窗口管理model
  popPage: (() => void) | undefined = undefined;

  aboutToAppear(): void {
    // 初始化窗口管理model
    const windowStage: window.WindowStage | undefined = AppStorage.get('windowStage');
    // 没有windowStage将无法执行下列逻辑
    if (!windowStage) {
      logger.error(TAG, 'windowStage init error!');
      return;
    }
    this.windowModel.setWindowStage(windowStage);

    const windowClass: window.Window | undefined = windowStage.getMainWindowSync();
    windowClass.setWindowSystemBarEnable(["status"]);
    
    // 设置沉浸模式及状态栏白色
    this.windowModel.setImmersive(this.popPage);

    // 获取顶部状态栏高度
    this.windowModel.getStatusBarHeight((statusBarHeight) => {
      logger.info(TAG, 'statusBarHeight is ' + statusBarHeight);
      this.statusBarHeight = px2vp(statusBarHeight);
    })

    // 组装数据源
    this.dataSource.pushArrayData(LIST_DATA);
  }

  aboutToDisappear(): void {
    this.windowModel.deleteEmitter();
  }

  /**
   * 搜索框提示字
   */
  @Builder
  articleTitleBuilder() {
    Text($r('app.string.status_bar_animation_beautiful_text'))
      .fontWeight(FontWeight.Bold)
      .fontFamily(Constants.HARMONY_HEI_TI_BOLD_FONT_FAMILY)
      .fontSize($r('app.integer.status_bar_animation_beautiful_text_font'))
      .width(Constants.FULL_PERCENT)
      .height($r('app.integer.status_bar_animation_beautiful_text_height'))
      .padding({
        left: $r('app.integer.status_bar_animation_beautiful_padding_left'),
        top: $r('app.integer.status_bar_animation_beautiful_padding_top')
      })
      .backgroundColor($r('app.color.status_bar_animation_beautiful_background_color'))
  }

  /**
   * 定位和天气
   */
  @Builder
  locationAndWeatherBuilder() {
    Column() {
      Text($r('app.string.status_bar_animation_location_text'))
        .textAlign(TextAlign.Center)
        .fontSize($r('app.integer.status_bar_animation_location_text_font'))
        .fontColor(this.isWhiteColor ? $r("app.color.status_bar_animation_text_white") :
                   $r("app.color.status_bar_animation_text_black"))
        .fontWeight(FontWeight.Bold)
        .width($r('app.integer.status_bar_animation_location_text_width'))
        .height($r('app.integer.status_bar_animation_location_text_height'))

      Text($r('app.string.status_bar_animation_weather_text'))
        .textAlign(TextAlign.Center)
        .fontSize($r('app.integer.status_bar_animation_weather_text_font'))
        .fontColor(this.isWhiteColor ? $r("app.color.status_bar_animation_text_white") :
                   $r("app.color.status_bar_animation_text_black"))
        .fontWeight(FontWeight.Bold)
        .width($r('app.integer.status_bar_animation_weather_text_width'))
        .height($r('app.integer.status_bar_animation_weather_text_height'))
    }
    .onClick(() => {
      promptAction.showToast({
        message: $r('app.string.status_bar_animation_prompt_text')
      });
    })
    .padding({
      left: $r('app.integer.status_bar_animation_weather_padding_left')
    })
    .zIndex(Constants.Z_INDEX_ONE)
  }

  /**
   * 展开后的蓝色回顶部图标
   */
  @Builder
  topUpBuilder() {
    Column() {
      Image($r("app.media.status_bar_animation_top_up"))
        .width($r('app.integer.status_bar_animation_top_up_width'))
        .aspectRatio(Constants.ASPECT_RATIO_ONE)

      Text($r('app.string.status_bar_animation_top_up_text'))
        .textAlign(TextAlign.Center)
        .fontSize($r('app.integer.status_bar_animation_top_up_text_font'))
        .fontColor($r("app.color.status_bar_animation_text_black"))
        .width($r('app.integer.status_bar_animation_top_up_text_width'))
        .height($r('app.integer.status_bar_animation_top_up_text_height'))
    }
    .onClick(() => {
      this.isTop = true;
      // 点击回顶部按钮列表回滚到顶部
      setTimeout(() => {
        this.scroller.scrollTo({
          xOffset: Constants.MAIN_SCROLLER_OFFSET_X,
          yOffset: Constants.MAIN_SCROLLER_OFFSET_Y,
          animation: {
            duration: Constants.ANIMATION_DURATION1,
            curve: Curve.FastOutLinearIn
          }
        })
      }, Constants.ANIMATION_DURATION)


    })
    .padding({
      left: $r('app.integer.status_bar_animation_top_up_padding_left')
    })
    .zIndex(Constants.Z_INDEX_ONE)
  }

  /**
   * 展开和收起的动效视图
   */
  @Builder
  searchViewBuilder() {
    Row() {
      // 爱心图标
      Image($r("app.media.status_bar_animation_favor"))
        .width($r('app.integer.status_bar_animation_favor_width'))
        .aspectRatio(Constants.ASPECT_RATIO_ONE)
        .visibility(this.isFlow ? Visibility.Visible : Visibility.Hidden)
        .position({
          x: Constants.FAVOR_POSITION_X
        })
        .animation({
          duration: Constants.ANIMATION_DURATION1,
          curve: Curve.FastOutLinearIn,
          playMode: PlayMode.Normal,
        })
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.status_bar_animation_prompt_text')
          });
        })

      // 圆圈五星图标
      Image($r("app.media.status_bar_animation_highlight"))
        .width($r('app.integer.status_bar_animation_highlight_width'))
        .aspectRatio(Constants.ASPECT_RATIO_ONE)
        .visibility(this.isFlow ? Visibility.Visible : Visibility.Hidden)
        .position({
          x: this.isFlow ? Constants.HIGHLIGHT_POSITION_X2 : Constants.HIGHLIGHT_POSITION_X
        })
        .animation({
          duration: Constants.ANIMATION_DURATION1,
          curve: Curve.FastOutLinearIn,
          playMode: PlayMode.Normal
        })
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.status_bar_animation_prompt_text')
          });
        })

      // 五星图标
      Image($r("app.media.status_bar_animation_collected"))
        .width($r('app.integer.status_bar_animation_collected_width'))
        .aspectRatio(Constants.ASPECT_RATIO_ONE)
        .visibility(this.isFlow ? Visibility.Visible : Visibility.Hidden)
        .position({
          x: this.isFlow ? Constants.COLLECTED_POSITION_X2 : Constants.COLLECTED_POSITION_X
        })
        .animation({
          duration: Constants.ANIMATION_DURATION1,
          curve: Curve.FastOutLinearIn,
          playMode: PlayMode.Normal
        })
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.status_bar_animation_prompt_text')
          });
        })

      // 搜索图标
      Row() {
        Image(this.isWhiteColor ? $r("app.media.status_bar_animation_search_white") :
              $r("app.media.status_bar_animation_search_black"))
          .width($r("app.integer.status_bar_animation_search_image_width"))
          .aspectRatio(Constants.ASPECT_RATIO_ONE)
          .margin({
            left: $r("app.integer.status_bar_animation_search_image_margin_left")
          })

        Text($r('app.string.status_bar_animation_search_text'))
          .fontSize($r('app.integer.status_bar_animation_search_text_font'))
          .fontColor(this.isWhiteColor ? $r("app.color.status_bar_animation_search_title_white") :
                     $r("app.color.status_bar_animation_search_title_black"))
          .layoutWeight(Constants.LAYOUT_WEIGHT)
          .height($r('app.integer.status_bar_animation_search_text_height'))
          .margin({ left: $r('app.integer.status_bar_animation_search_text_margin_left') })
          .wordBreak(WordBreak.NORMAL)
          .clip(true)
      }
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.status_bar_animation_prompt_text')
        });
      })
      .backgroundColor(this.isWhiteColor ? $r("app.color.status_bar_animation_background_black") :
                       $r("app.color.status_bar_animation_background_white"))
      // 搜索框的borderRadius圆角变化
      .borderRadius(this.isFlow ? Constants.SEARCH_BORDER_RADIUS2 :
                    Constants.SEARCH_BORDER_RADIUS1)
      .height($r('app.integer.status_bar_animation_search_height'))
      .width(this.isFlow ?
             $r('app.integer.status_bar_animation_search_width') : Constants.FULL_PERCENT)
      // TODO: 知识点：设置搜索框右侧position为0，使搜索图标展开和收起靠右侧。（默认靠左侧）
      .position({
        right: Constants.SEARCH_POSITION_RIGHT
      })
      // 搜索框添加属性动画
      .animation({
        duration: Constants.ANIMATION_DURATION1,
        curve: Curve.Linear,
        playMode: PlayMode.Normal
      })
    }
    .margin({
      left: $r('app.integer.status_bar_animation_search_margin_left'),
      right: $r('app.integer.status_bar_animation_search_margin_right')
    })
    .layoutWeight(Constants.LAYOUT_WEIGHT)
    .height($r('app.integer.status_bar_animation_search_height'))
  }

  /**
   * 灰色背景的功能视图
   */
  @Builder
  toolViewBuilder() {
    Row({ space: Constants.TOOL_VIEW_SPACE }) {
      Stack() {
        Row()
          .backgroundColor(this.isWhiteColor ? $r("app.color.status_bar_animation_background_black") :
                           $r("app.color.status_bar_animation_background_white"))
          .borderRadius(Constants.SHARE_BORDER_RADIUS)
          .width($r('app.integer.status_bar_animation_share_width'))
          .height($r('app.integer.status_bar_animation_share_height'))

        Image(this.isWhiteColor ? $r("app.media.status_bar_animation_share_white") :
              $r("app.media.status_bar_animation_share_black"))
          .width($r('app.integer.status_bar_animation_share_image_width'))
          .aspectRatio(Constants.ASPECT_RATIO_ONE)
      }
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.status_bar_animation_prompt_text')
        });
      })

      Stack() {
        Row()
          .backgroundColor(this.isWhiteColor ? $r("app.color.status_bar_animation_background_black") :
                           $r("app.color.status_bar_animation_background_white"))
          .borderRadius(Constants.SCAN_BORDER_RADIUS)
          .width($r('app.integer.status_bar_animation_scan_width'))
          .height($r('app.integer.status_bar_animation_scan_height'))

        Image(this.isWhiteColor ? $r("app.media.status_bar_animation_scan_white") :
              $r("app.media.status_bar_animation_scan_black"))
          .width($r('app.integer.status_bar_animation_scan_image_width'))
          .aspectRatio(Constants.ASPECT_RATIO_ONE)
      }
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.status_bar_animation_prompt_text')
        });
      })

      Stack() {
        Row()
          .backgroundColor(this.isWhiteColor ? $r("app.color.status_bar_animation_background_black") :
                           $r("app.color.status_bar_animation_background_white"))
          .borderRadius(Constants.SETTING_BORDER_RADIUS)
          .width($r('app.integer.status_bar_animation_setting_width'))
          .height($r('app.integer.status_bar_animation_setting_height'))

        Image(this.isWhiteColor ? $r("app.media.status_bar_animation_setting_white") :
              $r("app.media.status_bar_animation_setting_black"))
          .width($r('app.integer.status_bar_animation_setting_image_width'))
          .aspectRatio(Constants.ASPECT_RATIO_ONE)
      }
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.status_bar_animation_prompt_text')
        });
      })
    }
    .width($r('app.integer.status_bar_animation_tool_view_width'))
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Row() {
        // 动态显示回顶部或位置天气控件
        if (this.isFlow) {
          this.topUpBuilder();
        } else {
          this.locationAndWeatherBuilder();
        }
        this.searchViewBuilder();
        this.toolViewBuilder();
      }
      .height(Constants.NAVIGATION_BAR_HEIGHT + this.statusBarHeight)
      .width(Constants.FULL_PERCENT)
      .padding({
        top: this.statusBarHeight
      })
      .zIndex(Constants.Z_INDEX_THREE)

      // TODO: 知识点：父组件的透明度Opacity影响子组件（如父类Opacity为0.5，若子组件为0.5时，子组件实际Opacity = 0.5*0.5）,此处Row来改变状态栏的透明度不受影响其它组件透明度
      Row() {
      }
      .backgroundColor($r("app.color.status_bar_animation_white"))
      .opacity(this.navigateBarOpacity)
      .height(Constants.STATUS_BAR_HEIGHT + this.statusBarHeight)
      .width(Constants.FULL_PERCENT)
      .zIndex(Constants.Z_INDEX_TWO)

      List({ scroller: this.scroller }) {
        ListItem() {
          Banner({ increaseBannerHeight: this.negativeOffsetY });
        }

        ListItemGroup({ header: this.articleTitleBuilder() }) {
          // 加载列表
          ArticlesList({ listData: this.dataSource, isTop: this.isTop });
        }
      }
      .id('statusbar_animation_main_list')
      // 隐藏滚动条
      .scrollBar(BarState.Off)
      // 渐变蓝色背景色
      .linearGradient({
        colors: [[Constants.LIST_LINEAR_GRADIENT_START_COLOR, Constants.LIST_LINEAR_GRADIENT_START],
          [Constants.LIST_LINEAR_GRADIENT_END_COLOR, Constants.LIST_LINEAR_GRADIENT_END]]
      })
      .height(Constants.FULL_PERCENT)
      .width(Constants.FULL_PERCENT)

      // TODO: 性能知识点：onDidScroll属于高频回调接口，应该避免在内部进行冗余和耗时操作，例如避免打印日志
      .onDidScroll(() => {
        // TODO: 知识点：通过currentOffset来获取偏移量比较准确。
        const yOffset: number = this.scroller.currentOffset().yOffset;

        // 偏移量为负值Banner会有拉伸放大效果
        yOffset <= Constants.MAIN_SCROLLER_OFFSET_Y_ZERO ? this.negativeOffsetY = yOffset :
        Constants.MAIN_SCROLLER_OFFSET_Y_ZERO;

        // 判断导航栏和状态栏背景透明度变化
        yOffset >= Constants.MAIN_SCROLLER_OFFSET_Y_MAX + this.statusBarHeight ?
        this.navigateBarOpacity = Constants.NAVIGATION_BAR_OPACITY_MAX :
        this.navigateBarOpacity = yOffset / Constants.MAIN_SCROLLER_OFFSET_Y_MAX;

        // 判断当前的导航栏和图标颜色变化
        yOffset > this.statusBarHeight ?
        this.isWhiteColor = false : this.isWhiteColor = true;

        // 判断状态栏字体颜色变化
        yOffset > this.statusBarHeight ?
        this.windowModel.setSystemBarContentColor(Constants.StatusBarContentBlackColor) :
        this.windowModel.setSystemBarContentColor(Constants.StatusBarContentWhiteColor);

        // 判断导航栏动效变化
        yOffset >= this.statusBarHeight + Constants.MAIN_SCROLLER_OFFSET_STATUS_CHANGE ?
        this.isFlow = true : this.isFlow = false;
      })
    }
    .zIndex(Constants.Z_INDEX_ONE)
    .height(Constants.FULL_PERCENT)
    .width(Constants.FULL_PERCENT)
    .gesture(
      SwipeGesture({ direction: SwipeDirection.Horizontal })
        .onAction((event: GestureEvent) => {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.IOS) {
            if (event) {
              DynamicsRouter.popAppRouter();
            }
          }
        })
    )
  }
}