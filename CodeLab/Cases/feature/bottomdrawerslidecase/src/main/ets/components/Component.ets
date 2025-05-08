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

import { CommonConstants } from '../constants/CommonConstants';
import WindowModel from '../utils/WindowModel';

// 地图顶部标题栏
@Component
export struct TopTitle {
  @Link isShow: boolean; // 是否显示顶部
  @State statusBarHeight: number = 0; // 状态栏高度
  private windowModel: WindowModel = WindowModel.getInstance(); // 窗口管理model

  aboutToAppear(): void {
    // 获取顶部导航栏高度
    this.windowModel.getStatusBarHeight((statusBarHeight) => {
      this.statusBarHeight = px2vp(statusBarHeight);
    })
  }

  build() {
    Column() {
      Column() {
        Row() {
          Image($r("app.media.bottomdrawerslidecase_next"))
            .width($r("app.integer.bottomdrawerslidecase_height_22"))
            .height($r("app.integer.bottomdrawerslidecase_height_22"))
            .margin({
              left: $r("app.integer.bottomdrawerslidecase_number_25"),
              right: $r("app.integer.bottomdrawerslidecase_number_15")
            })
          Text($r("app.string.bottomdrawerslidecase_homeTop"))
            .fontColor(Color.Black)
            .fontSize($r("app.integer.bottomdrawerslidecase_number_20"))
        }
        .backgroundColor(Color.White)
        .width(CommonConstants.FULL_SIZE)
        .height(CommonConstants.PAGE_HEADER_HEIGHT)
      }
      .id('statusHead')
      .backgroundColor(Color.White)
      .padding({ top: this.statusBarHeight })
      .visibility(this.isShow ? Visibility.Visible : Visibility.None)
      .animation({
        duration: 200, // 动画持续时间，单位毫秒
        curve: Curve.Smooth, // 动画曲线
        iterations: 1, // 动画播放次数
        playMode: PlayMode.Normal// 动画播放模式
      })

      Row() {
        Text($r("app.string.bottomdrawerslidecase_homeTop"))
          .margin({
            left: $r("app.integer.bottomdrawerslidecase_number_25"),
            right: $r("app.integer.bottomdrawerslidecase_number_15"),
            top: this.statusBarHeight
          })
          .fontColor(Color.Black)
          .fontSize($r("app.integer.bottomdrawerslidecase_number_18"))
      }
      .width('100%')
      .height($r("app.integer.bottomdrawerslidecase_height_48"))
      .visibility(!this.isShow ? Visibility.Visible : Visibility.None)
    }
  }
}

// listItem布局样式
@Component
export struct SettingItemView {
  build() {
    Column() {
      Image($r("app.media.bottomdrawerslidecase_list_item"))
        .draggable(false)
        .height($r("app.integer.bottomdrawerslidecase_other_itemheight"))
        .width($r('app.string.bottom_drawer_slide_full_percent'))
        .padding({
          left: $r('app.integer.bottom_drawer_slide_padding_left_12'),
          right: $r('app.integer.bottom_drawer_slide_padding_right_12')
        })
        .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
    }
  }
}

// Image地图布局样式
@Component
export struct ImageMapView {
  @State imagePositionX: number = 0; // 图片在父组件内X轴位置
  @State imagePositionY: number = 0; // 图片在父组件内Y轴位置
  @State offsetX: number = 0; // 拖动事件结束后图片X轴位置
  @State offsetY: number = 0; // 拖动事件结束后图片Y轴位置

  build() {
    Column() {
      // 背景地图图片
      Image($r("app.media.bottomdrawerslidecase_map"))
        .id("bg_img")
        .width($r("app.integer.bottomdrawerslidecase_number_1000"))
        .height($r("app.integer.bottomdrawerslidecase_number_1000"))
        .objectFit(ImageFit.Contain)
        .translate({ x: this.offsetX, y: this.offsetY })// 以组件左上角为坐标原点进行移动
        .draggable(false) // 图片不可手势拖动，默认为true

    }
    .width($r('app.string.bottom_drawer_slide_full_percent'))
    .height($r('app.string.bottom_drawer_slide_full_percent'))
    .clip(true) // 地图图片超出页面区域时裁剪掉
    .gesture(
      PanGesture({ direction: PanDirection.All, fingers: 1 })
        .onActionUpdate((event: GestureEvent) => {
          this.offsetX = event.offsetX + this.imagePositionX;
          this.offsetY = event.offsetY + this.imagePositionY;
        })
        .onActionEnd((event: GestureEvent) => {
          this.imagePositionX = this.offsetX;
          this.imagePositionY = this.offsetY;
        })
    )
  }
}



