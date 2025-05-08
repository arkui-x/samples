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

import { promptAction } from '@kit.ArkUI';

const TEXT_OPACITY = 0.5; // 输入框透明度
const VIDEO_INTRODUCE = 0.6; // 视频详情介绍透明度
const VIDEO_CONTENT = 0.8; // 视频内容介绍透明度

/**
 * 视频介绍页面，渲染效果不参与画中画功能开发
 */
@Component
export struct VideoInfoComponent {
  @State TabsInfo: Array<string> = ['视频', '评论']; // tab标题
  private scrollerForList: Scroller = new Scroller(); // 列表滚动控制器
  private arr: number[] = []; // 视频列表图片数组

  aboutToAppear() {
    for (let i = 0; i < 4; i++) {
      this.arr.push(i)
    }
  }

  build() {
    Column() {
      // 视频详情页面
      this.PageView()
    }
  }

  @Builder
  PageView() {
    Column() {
      // 视频详情页面tab组件
      this.TabView()
      // 视频详情页面vip卡片
      this.VipCard()
      // 视频详情页面相关视频详细介绍
      this.VideoItem()
      // 视频详情页面选集列表
      this.ListVideo()
    }
    .width($r('app.string.pip_window_full_width'))
    .height($r('app.string.pip_window_full_width'))
    .backgroundImage($r('app.media.pip_window_bg_blurry'))
    .backgroundImageSize({ width: $r('app.string.pip_window_full_width') })
  }

  /**
   * tab样式页面
   */
  @Builder
  TabView() {
    Row() {
      ForEach(this.TabsInfo, (item: string, index: number) => {
        this.TabItem(item, index);
      })
      Blank()
        .width($r('app.string.pip_window_tab_view_blank_width'))
      TextInput({ placeholder: $r('app.string.pip_window_tab_view_text') })
        .focusable(false)
        .width($r('app.integer.pip_window_tab_view_text_width'))
        .height($r('app.integer.pip_window_tab_view_text_height'))
        .padding({
          top: $r('app.integer.pip_window_tab_view_text_padding_top'),
          bottom: $r('app.integer.pip_window_tab_view_text_padding_top')
        })
        .margin({ right: $r('app.integer.pip_window_tab_view_text_margin_right') })
        .fontSize($r('app.integer.pip_window_tab_view_text_font_size'))
        .onClick(() => {
          // 调用Toast显示提示:此样式仅为案例展示
          promptAction.showToast({ message: $r("app.string.pip_window_toast_tips") });
        })
        .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
        .opacity(TEXT_OPACITY)
    }
    .clip(false)
    .height($r('app.integer.pip_window_tab_view_height'))
    .width($r('app.string.pip_window_full_width'))
    .border({
      width: {
        left: $r('app.integer.pip_window_tab_view_border_width_left'),
        right: $r('app.integer.pip_window_tab_view_border_width_left'),
        top: $r('app.integer.pip_window_tab_view_border_width_left'),
        bottom: $r('app.integer.pip_window_tab_view_border_width_bottom')
      },
      color: { bottom: $r('app.color.pip_window_tab_view_border_color_bottom') },
      style: {
        bottom: BorderStyle.Solid
      }
    })
  }

  @Builder
  TabItem(item: string, index: number) {
    Column() {
      Text(item)
        .fontSize($r('app.integer.pip_window_tab_item_font_size'))
        .fontColor(index === 0 ? $r('app.color.pip_window_tab_item_font_color_true') :
        $r('app.color.pip_window_tab_item_font_color'))
    }
    .clip(false)
    .padding({
      top: $r('app.integer.pip_window_tab_item_padding_top'),
      bottom: $r('app.integer.pip_window_tab_item_padding_top')
    })
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      // 调用Toast显示提示:此样式仅为案例展示
      promptAction.showToast({ message: $r("app.string.pip_window_toast_tips") });
    })
  }

  @Builder
  VipCard() {
    Stack() {
      Text($r('app.string.pip_window_vip_card_text'))
        .fontColor(Color.White)
    }
    .alignContent(Alignment.Center)
    .backgroundColor($r('app.color.pip_window_vip_card_background_color'))
    .height($r('app.integer.pip_window_vip_card_height'))
    .borderRadius($r('app.integer.pip_window_vip_card_border_radius'))
    .width($r('app.string.pip_window_vip_card_width'))
    .margin({
      top: $r('app.integer.pip_window_vip_card_margin_top'),
      bottom: $r('app.integer.pip_window_vip_card_margin_top')
    })
  }

  /**
   * 视频渲染详情页面
   */
  @Builder
  VideoItem() {
    Row() {
      Column() {
        Row() {
          // 视频图片
          Image($r('app.media.pip_window_preview1'))
            .height($r('app.integer.pip_window_video_item_row_image_height'))
            .width($r('app.integer.pip_window_video_item_row_image_width'))
            .margin({
              right: $r('app.integer.pip_window_video_item_row_image_margin_right'),
              bottom: $r('app.integer.pip_window_video_item_row_image_margin_bottom')
            })
            .borderRadius($r('app.integer.pip_window_video_item_row_image_border'))
          // 视频标题、演出人员
          Column() {
            Text($r('app.string.pip_window_video_item_row_text'))
              .width($r('app.string.pip_window_full_width'))
              .fontSize($r('app.integer.pip_window_video_item_row_text_font'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ bottom: $r('app.integer.pip_window_video_item_row_text_margin_bottom') })
            Text($r('app.string.pip_window_video_item_row_text_second'))
              .width($r('app.string.pip_window_full_width'))
              .fontSize($r('app.integer.pip_window_video_item_row_text_second_font'))
              .opacity(VIDEO_CONTENT)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .textAlign(TextAlign.Start)
          }
          .height($r('app.integer.pip_window_video_item_row_column_height'))
          .width($r('app.string.pip_window_video_item_row_column_width'))
          .justifyContent(FlexAlign.SpaceEvenly)
        }
        .width($r('app.string.pip_window_video_item_column_row_width'))
        .margin({
          top: $r('app.integer.pip_window_video_item_row_margin_bottom'),
          bottom: $r('app.integer.pip_window_video_item_row_margin_bottom')
        })

        // 视频介绍
        Text($r('app.string.pip_window_video_item_column_text'))
          .width($r('app.string.pip_window_video_item_column_text_width'))
          .fontSize($r('app.integer.pip_window_video_item_column_text_font_size'))
          .opacity(VIDEO_INTRODUCE)
          .padding({ bottom: $r('app.integer.pip_window_video_item_column_text_padding_bottom') })
      }
      .width($r('app.string.pip_window_video_item_column_width'))
    }
    .width($r('app.string.pip_window_full_width'))
    .justifyContent(FlexAlign.SpaceBetween)
  }

  /**
   * 轮播样式
   */
  @Builder
  ListVideo() {
    Column() {
      Text($r('app.string.pip_window_list_video_text'))
        .width($r('app.string.pip_window_full_width'))
      Row() {
        List({ space: 20, scroller: this.scrollerForList }) {
          ForEach(this.arr, (index: number) => {
            ListItem() {
              Image($r(`app.media.pip_window_preview` + (index + 1)))
                .margin({
                  right: $r('app.integer.pip_window_list_video_image_margin_right'),
                  bottom: $r('app.integer.pip_window_list_video_image_margin_bottom')
                })
                .width($r('app.integer.pip_window_list_video_image_width'))
                .height($r('app.integer.pip_window_list_video_image_height'))
                .borderRadius($r('app.integer.pip_window_list_video_image_border'))
            }
          })
        }
        .listDirection(Axis.Horizontal)
        .width($r('app.string.pip_window_full_width'))
        .height($r('app.string.pip_window_full_width'))
      }
      .margin({
        bottom: $r('app.integer.pip_window_list_video_list_margin_bottom'),
        top: $r('app.integer.pip_window_list_video_list_margin_top')
      })
    }
    .margin($r('app.integer.pip_window_list_video_margin'))
  }
}

