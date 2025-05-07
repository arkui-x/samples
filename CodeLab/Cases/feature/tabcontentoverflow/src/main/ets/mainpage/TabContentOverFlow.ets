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

import { display, window } from '@kit.ArkUI';
import { PlatformInfo, PlatformTypeEnum } from 'utils';
import { CONFIGURATION, STRINGCONFIGURATION } from '../common/Constants';
import { Side, TopView, VideoDes } from '../view/Side';

/**
 * 功能描述: 本示例实现了tabContent内容可以在tabBar上显示并且tabBar可以响应滑动事件的功能。
 *
 * 推荐场景: 小视频播放场景
 *
 * 核心组件:
 * 1. Tabs
 *
 * 实现步骤:
 * 1. 创建Tabs组件，将barHeight设置为0。
 * 2. 创建自定义tabBar组件。
 * 3. 将TabContent的内容分为上下两部分，上半部高度为100% - 60vp，存放video组件，下部分高度为60vp，存放进度条，设置滑动手势响应事件。
 * 4. 将Tabs组件的zIndex属性设置为2，tabContent的视图就可以堆叠在自定义tabBar之上。
 * 5. 再设置hitTestBehavior属性使被覆盖的自定义的tabBar可以响应点击事件。
 */
@Component
export struct TabContentOverFlowComponent {
  @State tabArray: string[] = ['app.string.tabcontentoverflow_homepage', 'app.string.tabcontentoverflow_video',
    'app.string.tabcontentoverflow_mall', 'app.string.tabcontentoverflow_mine'];
  @State imageArray: string[] =
    ['app.media.tabcontentoverflow_homepage', 'app.media.tabcontentoverflow_video', 'app.media.tabcontentoverflow_mall',
      'app.media.tabcontentoverflow_mine'];
  @State imageClickArray: string[] =
    ['app.media.tabcontentoverflow_homepage_filled', 'app.media.tabcontentoverflow_video_filled',
      'app.media.tabcontentoverflow_mall_filled', 'app.media.tabcontentoverflow_mine_filled'];
  @State index: number = 1;
  @State offsetX: number = 0; // 用来记录实时拖动的距离
  @State positionX: number = 0; // 用来记录拖动后的距离
  @State playTime: string = ''; // 用来记录现在播放的时间
  @State totalTime: number = 0; // 用来记录视频全部时长
  @State isPlay: boolean = false; // 用来控制播放状态
  @State isTouch: boolean = false; // 是否处于拖动状态
  @State isTextButtonVisible: boolean = true;
  @State bottomRectHeight: number = 0;
  private isSeek: boolean = false; // 是否拖拽跳转
  private tabsController: TabsController = new TabsController();
  private videoController: VideoController = new VideoController();
  private panOption: PanGestureOptions = new PanGestureOptions({
    direction: PanDirection.Left | PanDirection.Right
  }); // 设置拖动方向，只能左右拖动。
  private screenW: number = px2vp(display.getDefaultDisplaySync().width); // 获取设备宽度
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number =
    PlatformInfo.getPlatform() === PlatformTypeEnum.IOS ? 15 : 0;

  aboutToAppear(): void {
    window.getLastWindow(getContext(this)).then((data: window.Window) => {
      this.bottomRectHeight = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height;
    })
  }

  private dragAnimation() {
    animateTo({
      duration: CONFIGURATION.TABCONTENT_OVERFLOW_TOAST_DURATION,
      curve: Curve.EaseOut,
    }, () => {
      this.isTouch = true;
    });
  }

  @Builder
  videoTabContent() {
    /**
     * TODO: 高性能知识点: 界面嵌套带来了渲染和计算的大量开销，造成性能的衰退。使用扁平化布局优化嵌套层级，建议采用相对布局RelativeContainer进行扁平化布局，有效减少容器的嵌套层级，减少组件的创建时间。
     * 优化布局性能:https://gitee.com/harmonyos-cases/cases/blob/master/docs/performance/reduce-view-nesting-levels.md#%E4%BC%98%E5%8C%96%E5%B8%83%E5%B1%80%E6%80%A7%E8%83%BD
     */
    RelativeContainer() {
      Video({
        src: $rawfile('tabcontentoverflow_play_video.MP4'),
        currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X,
        previewUri: $r("app.media.tabcontentoverflow_preview"),
        controller: this.videoController
      })
        .height($r('app.string.tabcontentoverflow_video_height'))
        .width($r('app.string.tabcontentoverflow_full_size'))
        .objectFit(ImageFit.Cover)
        .autoPlay(false)
        .controls(false)
        .onPrepared((event) => {
          if (event !== undefined) {
            this.totalTime = event.duration;
          }
        })
        .onFinish(() => {
          this.isPlay = false;
        })
        .onUpdate((event) => {
          if (event !== undefined) {
            if (!this.isTouch) {
              if (!this.isSeek) {
                // 当没有进行拖动进度条时，进度条根据播放进度进行变化。
                this.offsetX =
                  event.time / this.totalTime * (this.screenW - CONFIGURATION.TABCONTENT_OVERFLOW_INTERVAL_NUMBER);
                this.positionX = this.offsetX;
              } else {
                this.isSeek = false;
              }
            }
          }
        })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO)
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: VerticalAlign.Top },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start }
        })
        .onClick(() => {
          if (this.isPlay) {
            this.isPlay = false;
            this.videoController.pause();
          } else {
            this.isPlay = true;
            this.videoController.start();
          }
        })
      // 播放按钮
      Image($r('app.media.tabcontentoverflow_play'))
        .width($r('app.integer.tabcontentoverflow_image_width'))
        .height($r('app.integer.tabcontentoverflow_image_height'))
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO, align: VerticalAlign.Top },
          bottom: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_IMAGE)
        .onClick(() => {
          if (this.isPlay) {
            this.isPlay = false;
            this.videoController.pause();
          } else {
            this.isPlay = true;
            this.videoController.start();
          }
        })
        .visibility(this.isPlay ? Visibility.Hidden : Visibility.Visible)
      // 展示视频相关信息,拖动进度条时隐藏。
      VideoDes()
        .alignRules({
          bottom: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
        })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEODES)
        .margin({ bottom: $r('app.integer.tabcontentoverflow_video_des_margin_bottom') })
        .visibility(this.isTouch ? Visibility.Hidden : Visibility.Visible)
      // 展示视频播放界面右侧用户头像、视频评论数量、收藏数量、分享数量、作者是否被用户关注等信息，拖动进度条时隐藏。
      Side()
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO, align: VerticalAlign.Center },
          right: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.End },
        })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_SIDE)
        .margin({ top: $r('app.integer.tabcontentoverflow_side_margin_top') })
        .visibility(this.isTouch ? Visibility.Hidden : Visibility.Visible)
      // 顶部视图
      TopView()
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO, align: VerticalAlign.Top },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
        })
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TOPVIEW)
      // 拖动进度条时展示现在播放哪个到具体的时间点
      Text(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PLAYTIME_TEXT + this.playTime)
        .fontSize($r('app.integer.tabcontentoverflow_play_time_text_font_size'))
        .width($r('app.integer.tabcontentoverflow_play_time_text_width'))
        .height($r('app.integer.tabcontentoverflow_play_time_text_height'))
        .textAlign(TextAlign.End)
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PLAYTIME_TEXT_ID)
        .fontColor($r('app.color.tabcontentoverflow_play_time_text_color'))
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO, align: VerticalAlign.Bottom },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Center },
        })
        .visibility(this.isTouch ? Visibility.Visible : Visibility.Hidden)
        .margin({
          left: $r('app.integer.tabcontentoverflow_play_time_text_margin'),
          top: $r('app.integer.tabcontentoverflow_play_time_text_margin')
        })
      // 拖动进度条时展示视频总时长
      Text(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TOTALTIME_TEXT + this.totalTime)
        .fontSize($r('app.integer.tabcontentoverflow_play_time_text_font_size'))
        .width($r('app.integer.tabcontentoverflow_play_time_text_width'))
        .height($r('app.integer.tabcontentoverflow_play_time_text_height'))
        .textAlign(TextAlign.Start)
        .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TOTALTIME_TEXT_ID)
        .fontColor($r('app.color.tabcontentoverflow_total_time_text_color'))
        .alignRules({
          top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PLAYTIME_TEXT_ID, align: VerticalAlign.Top },
          left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_PLAYTIME_TEXT_ID, align: HorizontalAlign.End },
        })
        .visibility(this.isTouch ? Visibility.Visible : Visibility.Hidden)
      // TODO: 知识点：使用三个Text组件来模拟播放进度条，第一个text位置不变，宽度不变。第二个text根据this.offsetX来变换宽度。第三个text根据this.offsetX来translate该组件在x轴的位置。
      RelativeContainer() {
        Text()
          .width(this.screenW - CONFIGURATION.TABCONTENT_OVERFLOW_INTERVAL_NUMBER)
          .height(this.isTouch ? $r('app.integer.tabcontentoverflow_text1_touch_height') :
          $r('app.integer.tabcontentoverflow_text1_height'))
          .borderRadius(this.isTouch ? $r('app.integer.tabcontentoverflow_text1_touch_border_radius') :
          $r('app.integer.tabcontentoverflow_text1_borderradius'))
          .backgroundColor($r('app.color.tabcontentoverflow_text1_background_color'))
          .translate({
            y: this.isTouch ? CONFIGURATION.TABCONTENT_OVERFLOW_TEXT_TOUCH_TRANSLATE :
            CONFIGURATION.TABCONTENT_OVERFLOW_TEXT_TRANSLATE
          })
          .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TEXTONE_ID)
          .margin({
            top: $r('app.integer.tabcontentoverflow_text1_margin_top'),
            left: $r('app.integer.tabcontentoverflow_text1_margin_left')
          })
        Text()
          .width(this.offsetX)
          .height(this.isTouch ? $r('app.integer.tabcontentoverflow_text1_touch_height') :
          $r('app.integer.tabcontentoverflow_text1_height'))
          .borderRadius(this.isTouch ? $r('app.integer.tabcontentoverflow_text1_touch_border_radius') :
          $r('app.integer.tabcontentoverflow_text1_borderradius'))
          .backgroundColor($r('app.color.tabcontentoverflow_text2_background_color'))
          .translate({
            y: this.isTouch ? CONFIGURATION.TABCONTENT_OVERFLOW_TEXT_TOUCH_TRANSLATE :
            CONFIGURATION.TABCONTENT_OVERFLOW_TEXT_TRANSLATE
          })
          .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TEXTTWO_ID)
          .alignRules({
            top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TEXTONE_ID, align: VerticalAlign.Top },
            left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TEXTONE_ID, align: HorizontalAlign.Start },
          })
        Text()
          .width($r('app.integer.tabcontentoverflow_text3_width'))
          .height($r('app.integer.tabcontentoverflow_text3_height'))
          .borderRadius($r('app.integer.tabcontentoverflow_text3_border_radius'))
          .backgroundColor($r('app.color.tabcontentoverflow_text2_background_color'))
          .translate({ x: this.offsetX })
          .visibility(this.isTextButtonVisible ? Visibility.Visible : Visibility.None)
          .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TEXTTHREE_ID)
          .alignRules({
            top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TEXTONE_ID, align: VerticalAlign.Top },
            left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TEXTONE_ID, align: HorizontalAlign.Start },
          })
          .margin({
            top: CONFIGURATION.TABCONTENT_OVERFLOW_TEXT_THREE_MARGIN_TOP,
            left: CONFIGURATION.TABCONTENT_OVERFLOW_TEXT_THREE_MARGIN_LEFT
          })
      }
      .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_RELATIVE_CONTAINER)
      .alignRules({
        top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_VIDEO, align: VerticalAlign.Bottom },
        left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
      })
      .margin({
        top: $r('app.integer.tabcontentoverflow_relativecontainer_margin_top'),
      })
      .width(this.screenW)
      .height($r('app.integer.tabcontentoverflow_tabbar_height'))
      // 左右拖动触发该手势事件
      .gesture(
        PanGesture(this.panOption)
          .onActionStart(() => {
            this.dragAnimation();
            this.isTextButtonVisible = false;
            this.isSeek = true;
          })/**
           * TODO: 性能知识点: onActionUpdate是系统高频回调函数，避免在函数中进行冗余或耗时操作，例如应该减少或避免在函数打印日志，会有较大的性能损耗。
           * 合理使用系统接口，避免冗余操作:https://gitee.com/harmonyos-cases/cases/blob/master/docs/performance/README.md
           */
          .onActionUpdate((event: GestureEvent) => {
            let playTime =
              Math.floor(this.offsetX / (this.screenW - CONFIGURATION.TABCONTENT_OVERFLOW_INTERVAL_NUMBER) *
              this.totalTime);
            this.offsetX = this.positionX + event.offsetX;
            if (this.offsetX <= CONFIGURATION.TABCONTENT_OVERFLOW_ZERO) {
              this.offsetX = CONFIGURATION.TABCONTENT_OVERFLOW_ZERO;
            }
            if (this.offsetX >= this.screenW - CONFIGURATION.TABCONTENT_OVERFLOW_INTERVAL_NUMBER) {
              this.offsetX = this.screenW - CONFIGURATION.TABCONTENT_OVERFLOW_INTERVAL_NUMBER;
            }
            if (playTime >= CONFIGURATION.TABCONTENT_OVERFLOW_TEN) {
              this.playTime = playTime.toString();
            } else {
              this.playTime = STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TIME_ZERO + playTime.toString();
            }
          })
          .onActionEnd(() => {
            if (this.positionX === this.offsetX) { // 进度条未发生改变
              this.isSeek = false;
            } else {
              // 拖动进度条发生改变后通过this.videoController.setCurrentTime来精准定位视频现在播放位置。
              this.videoController.setCurrentTime(Number((this.offsetX /
                (this.screenW - CONFIGURATION.TABCONTENT_OVERFLOW_INTERVAL_NUMBER) * this.totalTime).toFixed(3)),
                SeekMode.Accurate);
              this.positionX = this.offsetX;
            }
            this.isTextButtonVisible = true;
            this.isTouch = false;
          })
      )
    }
  }

  build() {
    RelativeContainer() {
      // TODO: 知识点：将barHeight设置为0，预留60vp给自定义tabBar，TabContent的高度则可以使用calc(100% - 60vp)获取。
      Tabs({ index: this.index, controller: this.tabsController }) {
        TabContent() {
          Text(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_HOMEPAGE)
            .fontSize($r('app.integer.tabcontentoverflow_tabcontent_text_fontsize'))
        }
        .align(Alignment.Center)
        .height($r('app.string.tabcontentoverflow_video_height'))
        .width($r('app.string.tabcontentoverflow_full_size'))

        TabContent() {
          this.videoTabContent();
        }

        TabContent() {
          Text(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_MALL)
            .fontSize($r('app.integer.tabcontentoverflow_tabcontent_text_fontsize'))
        }
        .align(Alignment.Center)
        .height($r('app.string.tabcontentoverflow_video_height'))
        .width($r('app.string.tabcontentoverflow_full_size'))

        TabContent() {
          Text(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_MINE)
            .fontSize($r('app.integer.tabcontentoverflow_tabcontent_text_fontsize'))
        }
        .align(Alignment.Center)
        .height($r('app.string.tabcontentoverflow_video_height'))
        .width($r('app.string.tabcontentoverflow_full_size'))
      }
      // TODO: 知识点：将zIndex设置为2，TabContent将在tabBar之上，显示的效果就是TabContent外溢的部分在tabBar上。
      .zIndex(CONFIGURATION.TABCONTENT_OVERFLOW_ZINDEX)
      .scrollable(false)
      .barHeight($r('app.integer.tabcontentoverflow_tabs_barheight'))
      .animationDuration(CONFIGURATION.TABCONTENT_OVERFLOW_TABS_DURATION)
      .onChange((index: number) => {
        this.index = index;
      })
      // TODO: 知识点：hitTestBehavior属性可以实现在复杂的多层级场景下，一些组件能够响应手势和事件，而一些组件不能响应手势和事件。HitTestMode.Transparent的效果为，自身响应触摸测试，不会阻塞兄弟节点的触摸测试。
      .hitTestBehavior(HitTestMode.Transparent)
      .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TABS)
      .alignRules({
        top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: VerticalAlign.Top },
        left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
      })

      // 页签
      Row() {
        ForEach(this.tabArray, (item: string, index: number) => {
          Column() {
            Image(this.index === index ? $r(this.imageClickArray[index]) : $r(this.imageArray[index]))
              .width($r('app.integer.tabcontentoverflow_row_column_image_width'))
              .height($r('app.integer.tabcontentoverflow_row_column_image_height'))
            Text($r(item))
              .fontSize($r('app.integer.tabcontentoverflow_row_column_text_font_size'))
              .fontColor(this.index === index ? $r('app.color.tabcontentoverflow_click_color') :
              $r('app.color.tabcontentoverflow_white'))
          }
          .width($r('app.integer.tabcontentoverflow_row_column_width'))
          .margin({ top: $r('app.integer.tabcontentoverflow_margin_samll') })
          // 为将底部视图扩展到非安全区域，可将原本60vp的高度设置为100vp。
          .height($r('app.integer.tabcontentoverflow_row_column_height'))
          .onClick(() => {
            this.index = index;
            this.tabsController.changeIndex(this.index);
          })
        })
      }
      .offset({
        y: $r('app.integer.tabcontentoverflow_row_offset')
      })
      .width($r('app.string.tabcontentoverflow_full_size'))
      .backgroundColor($r('app.color.tabcontentoverflow_row_background'))
      .justifyContent(FlexAlign.SpaceAround)
      .id(STRINGCONFIGURATION.TABCONTENT_OVERFLOW_TABBAR)
      .alignRules({
        top: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: VerticalAlign.Bottom },
        left: { anchor: STRINGCONFIGURATION.TABCONTENT_OVERFLOW_CONTAINER, align: HorizontalAlign.Start },
      })
    }
    .padding({ bottom: PlatformInfo.isAndroid() ? px2vp(this.bottomRectHeight) : px2vp(this.avoidAreaBottomToModule) })
    .backgroundColor(Color.Black)
  }
}
