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

import { mapCommon, map } from '@kit.MapKit';
import { promptAction } from '@kit.ArkUI';
import { intl } from '@kit.LocalizationKit';
import { ClockInComponent } from '../components/ClockInComponent';
import { ClockInController, ClockInInfo } from '../model/ClockInModel';
import { Constants } from '../utils/Constants';

/**
 * 功能描述: 本示例使用geoLocationManager进行地理位置定位和地理信息获取，并利用MapComponent组件展示地图，添加用户位置和打卡范围，通过计算用户位置和打卡中心点的距离判断用户是否处于打卡区域，实现了打卡功能。
 *
 * 推荐场景: 定位打卡场景
 *
 * 核心组件:
 * 1. MapComponent 地图组件
 * 2. MapComponentController 地图组件控制器
 * 3. MapCircleOptions 打卡范围参数
 * 4. geoLocationManager 位置服务，获取用户位置和地理信息
 *
 * 实现步骤：
 * 1. 初始化地图参数。
 * 2. 初始化打卡范围参数。
 * 3. 设置是否显示定位按钮及按钮位置。
 * 4. 初始化打卡组件控制器。
 * 5. 初始化获取地图控制器的回调函数。
 * 6. 初始化自定义信息窗口Builder。
 * 7. 定义状态变量isInArea，接收用户位置是否在打卡范围内的判断结果。
 * 8. 导入并构建打卡组件。
 */
@Component
export struct ClockInSamplePage {
  // 是否正在加载打卡信息
  @State isLoading: boolean = false;
  // 初始打卡按钮文本
  @State clockInButtonText: Resource = $r('app.string.clock_in_button_text_clock_in');
  // 是否在打卡范围内
  @State isInArea: boolean = true;
  // 上班打卡信息
  @State clockInInfo: ClockInInfo | null = null;
  // 下班打卡信息
  @State clockOutInfo: ClockInInfo | null = null;
  // 设置定位按钮位置，默认在右下角
  @State locationButtonPosition?: Position | Edges | LocalizedEdges = undefined;
  // 设置地图参数
  private mapOptions: mapCommon.MapOptions = {
    position: {
      target: {
        latitude: 39.9,
        longitude: 116.4
      },
      zoom: 14
    }
  };
  // 是否显示定位按钮
  private isLocationButtonVisible: boolean = true;
  // 设置是否开启定位监听
  private isAddLocationListener: boolean = true;
  // 设置监听位置变化的时间间隔，单位为秒
  private locationTimeInterval: number = 1;
  // 地图控制器
  private mapController?: map.MapComponentController;
  // 设置日期格式化器
  private dateFormat: intl.DateTimeFormat = new intl.DateTimeFormat('zh-CN', { dateStyle: 'full' });
  // 设置时间格式化器
  private timeFormat: intl.DateTimeFormat =
    new intl.DateTimeFormat('zh-CN', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
  // 创建打卡控制器实例
  private clockInController: ClockInController = new ClockInController();
  // 获取地图控制器回调
  private getController: (mapController: map.MapComponentController) => void =
    (mapController: map.MapComponentController) => {
      this.mapController = mapController;
    };

  // 自定义信息窗口插槽
  @Builder
  customInfoWindowSlot(marker: map.Marker) {
    Text(marker.getTitle())
      .id('userAddress')
      .lineHeight($r('app.integer.clock_in_info_window_line_height'))
      .textAlign(TextAlign.Center)
      .fontColor(Color.Black)
      .font({ size: $r('app.integer.clock_in_info_window_font_size'), weight: FontWeight.Bold })
  }

  build() {
    RelativeContainer() {
      // 打卡组件
      Column() {
        /**
         * 构建打卡组件
         * clockInController: 打卡组件控制器
         * isInArea: 是否在打卡范围内
         * isLocationButtonVisible: 是否显示右下角定位按钮
         * locationButtonPosition: 设置定位按钮位置
         * mapOptions: 地图初始化参数
         * getMapController: 获取地图控制器的方法
         * customInfoWindowSlotParam: 自定义信息窗口插槽
         */
        ClockInComponent({
          clockInController: this.clockInController,
          isInArea: this.isInArea,
          isLocationButtonVisible: this.isLocationButtonVisible,
          locationButtonPosition: this.locationButtonPosition,
          mapOptions: this.mapOptions,
          getMapController: this.getController,
          customInfoWindowSlotParam: this.customInfoWindowSlot
        })
      }
      .width($r('app.string.clock_in_full_size'))
      .height($r('app.string.clock_in_full_size'))
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })

      // 顶部标题文本
      Text($r('app.string.clock_in_top_text'))
        .fontWeight(FontWeight.Bolder)
        .id('title')
        .width($r('app.string.clock_in_full_size'))
        .height($r('app.integer.clock_in_top_text_height'))
        .textAlign(TextAlign.Center)
        .backgroundColor(Color.White)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top }
        })

      // 详细信息栏
      Column({ space: Constants.COLUMN_SPACE }) {
        // 日期
        Text($r('app.string.clock_in_today_message', this.dateFormat.format(new Date())))
          .fontWeight(FontWeight.Bold)
        Text($r('app.string.clock_in_policy_message'))
          .fontWeight(FontWeight.Normal)
          .fontSize($r('app.integer.clock_in_detail_text_font_size'))
          .fontColor($r('app.color.clock_in_detail_text_color'))
        // 签到信息
        if (this.clockInInfo) {
          Divider()
            .width($r('app.string.clock_in_full_size'))
            .strokeWidth(1)
            .color($r('app.color.clock_in_divider_color'))
          Column({ space: Constants.COLUMN_SPACE }) {
            Row() {
              Text(this.clockInInfo.time)
                .fontWeight(FontWeight.Bold)
              Text($r('app.string.clock_in_checked_in'))
                .fontSize($r('app.integer.clock_in_detail_text_font_size'))
                .fontColor($r('app.color.clock_in_detail_text_color'))
                .backgroundColor($r('app.color.clock_in_detail_background_color'))
                .padding($r('app.integer.clock_in_detail_padding'))
                .margin({ left: $r('app.integer.clock_in_detail_margin_left') })
            }

            Row() {
              Image($r('app.media.clock_in_map_badge_local'))
                .height($r('app.integer.clock_in_icon_height'))
                .margin({ right: $r('app.integer.clock_in_icon_margin_right') })
              Text(this.clockInInfo.address)
                .fontColor($r('app.color.clock_in_detail_text_color'))
                .fontSize($r('app.integer.clock_in_detail_text_font_size'))
                .id('clockInAddress')
            }
            .id('clockInInfo')

          }
          .alignItems(HorizontalAlign.Start)
        }
        // 签退信息
        if (this.clockOutInfo) {
          Column({ space: Constants.COLUMN_SPACE }) {
            Row() {
              Text(this.clockOutInfo.time)
                .fontWeight(FontWeight.Bold)
              Text($r('app.string.clock_in_checked_out'))
                .fontSize($r('app.integer.clock_in_detail_text_font_size'))
                .fontColor($r('app.color.clock_in_detail_text_color'))
                .backgroundColor($r('app.color.clock_in_detail_background_color'))
                .padding($r('app.integer.clock_in_detail_padding'))
                .margin({ left: $r('app.integer.clock_in_detail_margin_left') })
            }

            Row() {
              Image($r('app.media.clock_in_map_badge_local'))
                .height($r('app.integer.clock_in_icon_height'))
                .margin({ right: $r('app.integer.clock_in_icon_margin_right') })
              Text(this.clockOutInfo.address)
                .fontColor($r('app.color.clock_in_detail_text_color'))
                .fontSize($r('app.integer.clock_in_detail_text_font_size'))
                .id('clockOutAddress')
            }
            .id('clockOutInfo')
          }
          .alignItems(HorizontalAlign.Start)
        }
      }
      .id('detail')
      .alignItems(HorizontalAlign.Start)
      .padding({
        top: $r('app.integer.clock_in_detail_padding_top'),
        left: $r('app.integer.clock_in_detail_padding_left'),
        right: $r('app.integer.clock_in_detail_padding_right'),
        bottom: $r('app.integer.clock_in_detail_padding_bottom')
      })
      .width($r('app.string.clock_in_full_size'))
      .backgroundColor(Color.White)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .borderRadius({
        topLeft: $r('app.integer.clock_in_detail_border_radius'),
        topRight: $r('app.integer.clock_in_detail_border_radius')
      })
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        // 打卡信息显示区域变化时，更新打卡按钮的位置
        if (newValue.height !== oldValue.height && this.isLocationButtonVisible) {
          this.locationButtonPosition = {
            right: getContext().resourceManager.getNumber($r('app.integer.clock_in_location_button_right').id),
            bottom: (newValue.height as number) +
            getContext().resourceManager.getNumber($r('app.integer.clock_in_location_button_bottom').id)
          };
        }
      })

      // 打卡按钮
      Text(this.clockInButtonText)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .fontSize($r('app.integer.clock_in_button_text_font_size'))
        .textAlign(TextAlign.Center)
        .width($r('app.integer.clock_in_button_width'))
        .height($r('app.integer.clock_in_button_height'))
        .linearGradient({
          direction: GradientDirection.Top, // 渐变方向
          colors: [
            [$r('app.color.clock_in_button_gradient_start'), 0.0],
            [$r('app.color.clock_in_button_gradient_end'), 1.0]
          ]
        })
        .borderRadius($r('app.integer.clock_in_button_radius'))
        .zIndex(1)// 设置zIndex值为1，使其在地图上方
        .alignRules({
          center: { anchor: 'detail', align: VerticalAlign.Top },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          // 如果在打卡范围内，进行打卡操作，否则显示提示信息
          if (this.isInArea) {
            // 显示1秒的加载动画，模拟打卡时网络请求同步耗时
            this.isLoading = true;
            setTimeout(() => {
              // 如果已有上班打卡信息，则进行下班打卡，否则新增上班打卡信息
              if (this.clockInInfo) {
                // 如果已有下班打卡信息，则更新下班打卡信息，否则新增下班打卡信息
                this.clockOutInfo = {
                  time: this.timeFormat.format(new Date()),
                  address: this.clockInController.getAddress()
                };
                this.clockInButtonText = this.clockOutInfo !== null ? $r('app.string.clock_in_button_text_update') :
                $r('app.string.clock_in_button_text_clock_out');
              } else {
                this.clockInInfo = {
                  time: this.timeFormat.format(new Date()),
                  address: this.clockInController.getAddress()
                };
                this.clockInButtonText = $r('app.string.clock_in_button_text_clock_out');
              }
              this.isLoading = false;
            }, 1000)
          } else {
            promptAction.showToast({
              message: $r('app.string.clock_in_toast_message_out_of_range')
            });
          }
        })

      // 打卡时的加载动画
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .color($r('app.color.clock_in_loading_progress_color'))
            .width($r('app.integer.clock_in_loading_progress_width'))
            .height($r('app.integer.clock_in_loading_progress_height'))
            .backgroundColor($r('app.color.clock_in_loading_progress_background'))
            .borderRadius($r('app.integer.clock_in_loading_progress_border_radius'))
            .padding($r('app.integer.clock_in_loading_progress_padding'))
        }
        .width($r('app.string.clock_in_full_size'))
        .height($r('app.string.clock_in_full_size'))
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor($r('app.color.clock_in_loading_mask_background'))
        .zIndex(1) // 设置zIndex值为2，使其在页面最上方
      }
    }
    .width($r('app.string.clock_in_full_size'))
    .height($r('app.string.clock_in_full_size'))
  }
}