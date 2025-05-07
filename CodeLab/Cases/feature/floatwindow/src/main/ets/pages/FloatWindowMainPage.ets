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

import { curves } from '@kit.ArkUI';
import { Constants } from '../common/Constants';

/**
 * 使用悬浮窗组件样例
 *
 * 核心组件:
 * 1. FloatWindowView
 *
 * 实现步骤：
 *  1. 悬浮窗组件使用Stack嵌套video布局，使用属性position绝对定位使组件悬浮，position使用Edges类型控制悬浮窗到父组件四条边的距离
 *  2. 初始化时悬浮窗的position属性设置top和right，让悬浮窗靠右
 *  3. 父组件添加onAreaChange回调，获取父组件的宽高
 *  4. 悬浮窗组件添加onTouchEvent回调，在手指按下时保存触摸点在窗口中的坐标，用于移动时悬浮窗位置的计算
 *  5. 手指移动时，获取触摸点相对于应用窗口左上角的X和Y坐标，通过计算设置悬浮窗的position坐标实现拖拽，使用默认参数的弹性跟手动画曲线curves.responsiveSpringMotion结合animateTo实现跟手动画效果
 *  6. 手指抬起时，通过判断悬浮窗中心在水平方向位于父组件中心的左侧或右侧设置悬浮窗靠左或靠右，如果悬浮窗超出内容区上下边界，则将悬浮窗设置在边界位置，使用curves.springMotion弹性动画曲线实现吸附边界时的弹性动画效果
 */
@Component
export struct FloatWindowMainPage {
  private scroller: Scroller = new Scroller();
  // 父组件宽度
  @State containerWidth: number = 0;
  // 父组件高度
  @State containerHeight: number = 0;

  @Builder
  server(text: Resource) {
    Text() {
      ImageSpan($r('app.media.float_window_service'))
        .objectFit(ImageFit.Contain)
        .width($r('app.integer.float_window_icon_width'))
        .aspectRatio(Constants.ASPECT_RATIO)
        .margin({ right: $r('app.string.float_window_elements_margin_vertical_m') })
      Span(text)
    }
    .fontSize($r('app.string.float_window_text_size_body2'))
    .fontColor($r('app.color.float_window_color_foreground'))
  }

  @Builder
  addressService() {
    // 配送地址
    Row() {
      Text($r('app.string.float_window_send_to'))
        .fontSize($r('app.string.float_window_text_size_body2'))
        .fontColor($r('app.color.float_window_color_foreground'))
        .fontWeight(FontWeight.Bold)
        .margin({ right: $r('app.string.float_window_elements_margin_vertical_l') })
      Image($r('app.media.float_window_local'))
        .width($r('app.integer.float_window_icon_width'))
        .aspectRatio(Constants.ASPECT_RATIO)
        .margin({ right: $r('app.string.float_window_elements_margin_vertical_m') })
      Text($r('app.string.float_window_address'))
        .fontSize($r('app.string.float_window_text_size_body2'))
        .fontColor($r('app.color.float_window_color_foreground'))
        .opacity($r('app.string.float_window_opacity'))
    }
    .alignItems(VerticalAlign.Top)
    .width($r('app.string.float_window_full_size'))
    .margin({ top: $r('app.string.float_window_card_margin_start') })
    .padding({
      top: $r('app.string.float_window_card_padding_start'),
      left: $r('app.string.float_window_card_padding_start'),
      right: $r('app.string.float_window_card_padding_start')
    })
    .backgroundColor($r('app.color.float_window_color_background'))
    .borderRadius({
      topLeft: $r('app.string.float_window_corner_radius_default_l'),
      topRight: $r('app.string.float_window_corner_radius_default_l')
    })

    // 服务
    Row() {
      Text($r('app.string.float_window_service'))
        .fontSize($r('app.string.float_window_text_size_body2'))
        .fontColor($r('app.color.float_window_color_foreground'))
        .fontWeight(FontWeight.Bold)
        .margin({ right: $r('app.string.float_window_elements_margin_vertical_l') })
      Column({ space: Constants.PRODUCT_SERVICE_SPACE }) {
        this.server($r('app.string.float_window_free_hipping'))
        this.server($r('app.string.float_window_store_delivery'))
        this.server($r('app.string.float_window_return_goods'))
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width($r('app.string.float_window_full_size'))
    .alignItems(VerticalAlign.Top)
    .padding($r('app.string.float_window_card_padding_start'))
    .backgroundColor($r('app.color.float_window_color_background'))
    .borderRadius($r('app.string.float_window_corner_radius_default_l'))
    .borderRadius({
      bottomLeft: $r('app.string.float_window_corner_radius_default_l'),
      bottomRight: $r('app.string.float_window_corner_radius_default_l')
    })
  }

  @Builder
  choice() {
    Row() {
      Text($r('app.string.float_window_selected'))
        .fontSize($r('app.string.float_window_text_size_body2'))
        .fontColor($r('app.color.float_window_color_foreground'))
      Text($r('app.string.float_window_select_configuration'))
        .fontSize($r('app.string.float_window_text_size_body2'))
        .padding({ left: $r('app.integer.float_window_selected_padding') })
        .layoutWeight(Constants.LAYOUT_WEIGHT)
    }
    .width($r('app.string.float_window_full_size'))
    .padding($r('app.string.float_window_card_padding_start'))
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Top)
    .backgroundColor($r('app.color.float_window_color_background'))
    .borderRadius($r('app.string.float_window_corner_radius_default_l'))
    .margin({ top: $r('app.string.float_window_card_margin_start') })
  }

  @Builder
  information() {
    Column() {
      Text($r('app.string.float_window_price'))
        .fontSize($r('app.string.float_window_text_size_headline'))
        .fontColor($r('app.color.float_window_color_warning'))
        .fontWeight(FontWeight.Bold)

      Text($r('app.string.float_window_product'))
        .fontSize($r('app.string.float_window_text_size_body1'))
        .margin({ top: $r('app.string.float_window_elements_margin_vertical_m') })
    }
    .padding($r('app.string.float_window_card_padding_start'))
    .width($r('app.string.float_window_full_size'))
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('app.color.float_window_color_background'))
    .borderRadius($r('app.string.float_window_corner_radius_default_l'))
    .margin({ top: $r('app.string.float_window_card_margin_start') })
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      // 商品信息展示组件
      Scroll(this.scroller) {
        Column() {
          Image($r('app.media.float_window_product'))
            .objectFit(ImageFit.Contain)
            .backgroundColor($r('app.color.float_window_color_background'))
            .width($r('app.string.float_window_full_size'))
            .borderRadius($r('app.string.float_window_corner_radius_default_l'))
          // 商品信息
          this.information()
          // 商品型号
          this.choice()
          // 配送地址和服务
          this.addressService()
        }
      }
      .width($r('app.string.float_window_full_size'))
      .height($r('app.string.float_window_full_size'))
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .padding(Constants.PAGE_PADDING)

      // 悬浮窗
      FloatWindowView({ containerWidth: this.containerWidth, containerHeight: this.containerHeight })
    }
    .width($r('app.string.float_window_full_size'))
    .height($r('app.string.float_window_full_size'))
    .backgroundColor($r('app.color.float_window_color_sub_background'))
    .onAreaChange((oldValue: Area, newValue: Area) => {
      // TODO：性能知识点：onAreaChange是高频回调，仅在父组件尺寸改变时获取新的父组件宽高，避免性能损耗
      if (oldValue.width !== newValue.width) {
        this.containerWidth = newValue.width as number;
      }
      if (oldValue.height !== newValue.height) {
        this.containerHeight = newValue.height as number;
      }
    })
  }
}

@Component
struct FloatWindowView {
  // 悬浮窗相对于父组件四条边的距离，top和bottom同时设置时top生效，right和left同时设置时left生效
  @State edge: Edges = { top: Constants.INIT_POSITION_Y, right: Constants.PAGE_PADDING };
  @Link containerWidth: number;
  @Link containerHeight: number;
  // 拖拽移动开始时悬浮窗在窗口中的坐标，每次移动回调触发时更新
  private windowStartX: number = 0;
  private windowStartY: number = 0;
  private videoController: VideoController = new VideoController();

  /**
   * 触摸回调，悬浮窗跟手和贴边动画
   */
  onTouchEvent(event: TouchEvent): void {
    switch (event.type) {
      case TouchType.Down: {
        // 获取拖拽开始时悬浮窗在窗口中的坐标
        this.windowStartX = event.touches[0].windowX;
        this.windowStartY = event.touches[0].windowY;
        break;
      }
      case TouchType.Move: {
        const windowX: number = event.touches[0].windowX;
        const windowY: number = event.touches[0].windowY;
        // TODO：知识点：跟手动画，推荐使用默认参数的弹性跟手动画曲线curves.responsiveSpringMotion。
        animateTo({ curve: curves.responsiveSpringMotion() }, () => {
          // 判断当前edge中属性left和right哪个不为undefined，用于控制悬浮窗水平方向的位置
          if (this.edge.left !== undefined) {
            this.edge.left = this.edge.left as number + (windowX - this.windowStartX);
          } else {
            this.edge.right = this.edge.right as number - (windowX - this.windowStartX);
          }
          this.edge.top = this.edge.top as number + (windowY - this.windowStartY);
          this.windowStartX = windowX;
          this.windowStartY = windowY;
        })
        break;
      }
      case TouchType.Up: {
        // 计算悬浮窗中心点在父组件中水平方向的坐标
        let centerX: number;
        if (this.edge.left !== undefined) {
          centerX = this.edge.left as number + Constants.FLOAT_WINDOW_WIDTH / 2;
        } else {
          centerX = this.containerWidth - (this.edge.right as number) - Constants.FLOAT_WINDOW_WIDTH / 2;
        }
        // TODO：知识点：通过判断悬浮窗在父组件中的位置，设置悬浮窗贴边，使用curves.springMotion()弹性动画曲线，可以实现阻尼动画效果
        animateTo({ curve: curves.springMotion() }, () => {
          // 判断悬浮窗中心在水平方向是否超过父组件宽度的一半，根据结果设置靠左或靠右
          if (centerX > (this.containerWidth / 2)) {
            this.edge.right = Constants.PAGE_PADDING;
            this.edge.left = undefined;
          } else {
            this.edge.right = undefined;
            this.edge.left = Constants.PAGE_PADDING;
          }
          // 判断悬浮窗是否超出内容区上下边界，根据结果将悬浮窗设置在边界位置
          if (this.edge.top as number < Constants.PAGE_PADDING) {
            this.edge.top = Constants.PAGE_PADDING;
          } else if (this.edge.top as number >
            this.containerHeight - Constants.FLOAT_WINDOW_HEIGHT - Constants.PAGE_PADDING) {
            this.edge.top = this.containerHeight - Constants.FLOAT_WINDOW_HEIGHT - Constants.PAGE_PADDING;
          }
        })
        break;
      }
      default: {
        break;
      }
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Video({
        src: $rawfile('float_window_video.mp4'),
        controller: this.videoController
      })
        .controls(false)
        .autoPlay(true)
        .loop(true)
        .muted(true)
        .width($r('app.string.float_window_full_size'))
        .borderRadius($r('app.integer.float_window_content_border_radius'))
      Text($r('app.string.float_window_live_text'))
        .width($r('app.string.float_window_full_size'))
        .fontSize($r('app.string.float_window_text_size_body1'))
        .fontColor($r('app.color.float_window_color_background'))
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.float_window_color_list_alert'))
        .borderRadius({
          bottomLeft: $r('app.integer.float_window_content_border_radius'),
          bottomRight: $r('app.integer.float_window_content_border_radius')
        })
    }
    .clip(true)
    .border({
      width: $r('app.integer.float_window_border_width'),
      color: $r('app.color.float_window_color_background')
    })
    .borderRadius($r('app.string.float_window_corner_radius_default_l'))
    .width(Constants.FLOAT_WINDOW_WIDTH)
    .height(Constants.FLOAT_WINDOW_HEIGHT)
    .backgroundColor($r('app.color.float_window_color_foreground'))
    .position(this.edge)
    .onTouch((event: TouchEvent) => {
      this.onTouchEvent(event);
    })
  }
}