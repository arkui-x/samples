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

import { ClickAnimationComponent } from '../components/ClickAnimationComponent';
import { promptAction, window } from '@kit.ArkUI';
import { ReviewListDataSource } from '../model/ReviewDataModel';
import { ReviewItem } from '../model/ReviewDataModel';
import { REVIEW_DATA } from '../mock/MockData';
import { IconAnimationType } from '../model/ClickIconDataModel';
import { DynamicsRouter } from 'routermodule';
import { PlatformInfo, PlatformTypeEnum } from 'utils';

/**
 * 功能描述: 本示例通过集成背景视频和点击动画效果，增强了用户交互体验。每次双击或连续快速点击特定区域时，会触发一个生动的动画效果，如图标放大淡出或向上移动淡出等。此外，还展示了如何结合其他功能模块（例如评论列表、功能按钮等），以构建一个完整的页面布局。

 * 推荐场景: 用户点击互动增强场景，例如直播或视频点赞的视觉反馈。

 * 核心组件:
 * 1. ClickAnimationComponent 点击动画组件，负责处理用户的点击事件并展示动画效果。
 * 2. LazyForEach 数据懒加载，用于动态控制多个动画元素的上下树显示。
 * 3. TransitionEffect 动画效果类，定义动画的入场和出场行为。
 *
 * 实现步骤：
 * 1. 创建背景视频Builder。
 * 2. 创建其他功能模块Builder，如直播账户、评论列表等。
 * 3. 定义点击回调函数，在每次点击后执行特定操作，例如更新点赞计数。
 * 4. 初始化点击动画类型。
 * 5. 导入并构建ClickAnimationComponent组件。
 */
@Component
export struct ClickAnimationSamplePage {
  @State statusHeight: number = 0; // 状态栏高度
  @State bottomHeight: number = 0; // 导航条高度
  @State likeNumber: number = 0; // 已点赞数
  private animationType: IconAnimationType = IconAnimationType.ScaleUpAndFadeOut; // 点击动画类型
  private listScroller: ListScroller = new ListScroller(); // 评论列表滚动控制器
  private reviewList: ReviewListDataSource = new ReviewListDataSource(); // 评论列表数据源
  private controller: VideoController = new VideoController();
  windowClass?: window.Window;
  // 点击回调
  private clickCallback: () => void = () => {
    // 每次触发动画，点赞数+1
    this.likeNumber++;
  };

  async aboutToAppear(): Promise<void> {
    REVIEW_DATA.forEach((item: ReviewItem, index: number) => {
      this.reviewList.pushData(item);
    })
    this.windowClass = await window.getLastWindow(getContext(this));
    // 获取状态栏高度
    const avoidAreaTop = this.windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    this.statusHeight = avoidAreaTop.topRect.height;
    // 获取导航条的高度
    const avoidAreaBottom = this.windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    this.bottomHeight = avoidAreaBottom.bottomRect.height;
  }

  // 背景视频插槽
  @Builder
  videoBackgroundSlotParam() {
    Video({
      src: $r('app.media.click_animation_test_video'),
      previewUri: $r('app.media.click_animation_cover'),
      controller: this.controller
    })
      .height((PlatformInfo.getPlatform() === PlatformTypeEnum.ANDROID) ?
      $r('app.string.android_click_animation_full_size') : $r('app.string.click_animation_full_size'))
      .width($r('app.string.click_animation_full_size'))
      .autoPlay(true)
      .loop(true)
      .controls(false)
      .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
        if (isVisible) {
          // 组件显示时播放视频
          this.controller.start();
        }
        if (!isVisible && currentRatio <= 0.0) {
          // 组件完全隐藏时暂停视频
          this.controller.pause();
        }
      })
  }

  // 其他功能模块
  @Builder
  otherFunctionModuleSlotParam() {
    RelativeContainer() {
      // 顶部直播账户信息
      Row() {
        Image($r('app.media.click_animation_shop_icon'))
          .width($r('app.integer.click_animation_shop_icon_size'))
          .height($r('app.integer.click_animation_shop_icon_size'))
          .borderRadius($r('app.integer.click_animation_shop_icon_border_radius'))
        Column() {
          Text($r('app.string.click_animation_live_today'))
            .fontSize($r('app.integer.click_animation_font_size_medium'))
            .fontWeight(FontWeight.Bolder)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.click_animation_text_color_light'))
          Text($r('app.string.click_animation_viewers_location'))
            .fontSize($r('app.integer.click_animation_font_size_small'))
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.click_animation_text_color_secondary'))
        }
        .margin({
          left: $r('app.integer.click_animation_margin'),
          right: $r('app.integer.click_animation_margin')
        })
        .height($r('app.string.click_animation_full_size'))
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)

        Text($r('app.string.click_animation_follow'))
          .width($r('app.integer.click_animation_button_width'))
          .height($r('app.integer.click_animation_button_height'))
          .borderRadius($r('app.integer.click_animation_button_border_radius'))
          .fontWeight(FontWeight.Bold)
          .fontSize($r('app.integer.click_animation_font_size_medium'))
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .linearGradient({
            angle: 90, // 设置渐变角度为90度，从左到右
            colors: [[$r('app.color.click_animation_button_linear_gradient_start'), 0.0],
              [$r('app.color.click_animation_button_linear_gradient_end'), 1.0]] // 设置从淡红到深红的渐变颜色
          })
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.click_animation_other_function'),
            });
          })
      }
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .height($r('app.integer.click_animation_streaming_account_module_height'))
      .borderRadius($r('app.integer.click_animation_streaming_account_module_radius'))
      .backgroundColor($r('app.color.click_animation_function_module_bg'))
      .padding($r('app.integer.click_animation_streaming_account_module_padding'))
      .justifyContent(FlexAlign.SpaceBetween)

      // 页面操作UI
      Row() {
        Image($r('app.media.click_animation_more'))
          .width($r('app.integer.click_animation_more_icon_size'))
          .height($r('app.integer.click_animation_more_icon_size'))
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.click_animation_other_function'),
            });
          })
        Image($r('app.media.click_animation_cancel'))
          .width($r('app.integer.click_animation_more_icon_size'))
          .height($r('app.integer.click_animation_more_icon_size'))
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.click_animation_other_function'),
            });
          })
      }
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End }
      })
      .width($r('app.integer.click_animation_handle_module_width'))
      .height($r('app.integer.click_animation_handle_module_height'))
      .borderRadius($r('app.integer.click_animation_handle_module_radius'))
      .backgroundColor($r('app.color.click_animation_function_module_bg'))
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)

      List({ scroller: this.listScroller, space: 5 }) {
        ListItem() {
          Text($r('app.string.click_animation_welcome_message'))
            .fontSize($r('app.integer.click_animation_font_size_large'))
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .width($r('app.string.click_animation_full_size'))
            .fontColor($r('app.color.click_animation_text_color_light'))
        }
        .padding($r('app.integer.click_animation_review_item_padding'))
        .backgroundColor($r('app.color.click_animation_review_item_background_color'))
        .borderRadius($r('app.integer.click_animation_review_item_radius'))
        .width($r('app.string.click_animation_full_size'))

        LazyForEach(this.reviewList, (reviewItem: ReviewItem, index: number) => {
          ListItem() {
            Text() {
              Span(`${reviewItem.userName}：`)
                .fontColor($r('app.color.click_animation_review_user_name_color'))
              Span(reviewItem.reviewContent)
                .fontColor($r('app.color.click_animation_text_color_light'))
            }
            .fontSize($r('app.integer.click_animation_font_size_large'))
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .width($r('app.string.click_animation_full_size'))
          }
          .padding($r('app.integer.click_animation_review_item_padding'))
          .backgroundColor($r('app.color.click_animation_review_item_background_color'))
          .borderRadius($r('app.integer.click_animation_review_item_radius'))
          .width($r('app.string.click_animation_full_size'))
        })
      }
      .width($r('app.string.click_animation_review_list_width'))
      .constraintSize({
        maxHeight: $r('app.integer.click_animation_review_list_max_height')
      })
      .scrollBar(BarState.Off)
      .alignRules({
        bottom: { anchor: 'bottom', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .offset({
        x: 0,
        y: $r('app.integer.click_animation_offset_y')
      })

      Row() {
        Text($r('app.string.click_animation_review'))
          .id('review')
          .width($r('app.string.click_animation_review_width'))
          .height($r('app.string.click_animation_full_size'))
          .borderRadius($r('app.integer.click_animation_text_radius'))
          .textIndent($r('app.integer.click_animation_text_indent'))
          .backgroundColor($r('app.color.click_animation_function_module_bg'))
          .fontSize($r('app.integer.click_animation_font_size_medium'))
          .fontColor($r('app.color.click_animation_text_color_secondary'))
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.click_animation_other_function'),
            });
          })
        Image($r('app.media.click_animation_square_fill_grid'))
          .padding($r('app.integer.click_animation_image_padding'))
          .width($r('app.integer.click_animation_image_size'))
          .height($r('app.integer.click_animation_image_size'))
          .borderRadius($r('app.integer.click_animation_image_radius'))
          .fillColor($r('app.color.click_animation_image_fill_color'))
          .backgroundColor($r('app.color.click_animation_function_module_bg'))
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.click_animation_other_function'),
            });
          })
        Image($r('app.media.click_animation_share'))
          .padding($r('app.integer.click_animation_image_padding'))
          .width($r('app.integer.click_animation_image_size'))
          .height($r('app.integer.click_animation_image_size'))
          .borderRadius($r('app.integer.click_animation_image_radius'))
          .fillColor($r('app.color.click_animation_image_fill_color'))
          .backgroundColor($r('app.color.click_animation_function_module_bg'))
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.click_animation_other_function'),
            });
          })
        Stack({ alignContent: Alignment.Top }) {
          Image($r('app.media.click_animation_heart_fill'))
            .padding($r('app.integer.click_animation_image_padding'))
            .width($r('app.integer.click_animation_image_size'))
            .height($r('app.integer.click_animation_image_size'))
            .borderRadius($r('app.integer.click_animation_image_radius'))
            .fillColor($r('app.color.click_animation_image_fill_color'))
            .backgroundColor($r('app.color.click_animation_function_module_bg'))
          Text(this.likeNumber.toString())
            .id('likeNumber')
            .fontSize($r('app.integer.click_animation_font_size_small'))
            .width($r('app.integer.click_animation_like_text_width'))
            .height($r('app.integer.click_animation_like_text_height'))
            .borderRadius($r('app.integer.click_animation_like_text_radius'))
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
            .backgroundColor($r('app.color.click_animation_like_text_bg'))
            .position({
              x: $r('app.integer.click_animation_like_text_x'),
              y: $r('app.integer.click_animation_like_text_y')
            })
        }
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.click_animation_other_function'),
          });
        })
      }
      .id('bottom')
      .width($r('app.string.click_animation_full_size'))
      .height($r('app.integer.click_animation_bottom_row_height'))
      .justifyContent(FlexAlign.SpaceBetween)
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
    }
    .height($r('app.string.click_animation_full_size'))
    .width($r('app.string.click_animation_full_size'))
    .padding({
      left: $r('app.integer.click_animation_other_function_module_padding'),
      right: $r('app.integer.click_animation_other_function_module_padding'),
      top: this.statusHeight + 'px',
      bottom: this.bottomHeight + 'px'
    })
    .hitTestBehavior(HitTestMode.None) // 屏蔽组件自身触摸测试
  }

  build() {
    RelativeContainer() {
      /**
       * 构建点击动画组件
       * animationType: 点击动画类型
       * videoBackgroundSlotParam: 背景视频插槽
       * otherFunctionModuleSlotParam: 其他功能组件插槽，建议使用箭头函数保证this指向
       * clickCallback: 点击回调方法
       */
      ClickAnimationComponent({
        animationType: this.animationType,
        videoBackgroundSlotParam: () => {
          this.videoBackgroundSlotParam();
        },
        otherFunctionModuleSlotParam: () => {
          this.otherFunctionModuleSlotParam();
        },
        clickCallback: this.clickCallback
      })
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height($r('app.string.click_animation_full_size'))
    .width($r('app.string.click_animation_full_size'))
    .priorityGesture(
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