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

import { LineCharts } from './LineCharts';
import { BarCharts } from './BarCharts';
import { AppRouter } from 'routermodule';

const HEART_RATE: string = 'heartRate';
const STEP_NUMBER: string = 'stepNumber';
// 心跳当日数据
const HEART_RATE_TODAY_DATA: Array<number> = [75, 70, 85, 75, 83, 72, 79, 80, 83, 86, 79, 86, 93, 80, 76, 78, 85, 91, 81, 78, 85, 93, 87, 79, 73];
// 心跳参考数据
const HEART_RATE_REFERENCE_DATA: Array<number> = [78, 73, 78, 71, 79, 76, 83, 85, 79, 86, 89, 75, 84, 87, 79, 75, 83, 79, 85, 83, 77, 84, 73, 71, 79, 86, 88, 79];
// 步数当日数据
const STEP_NUMBER_TODAY_DATA: Array<number> = [0, 0, 0, 0, 0, 0, 0, 580, 1309, 820, 103, 86, 1715, 1235, 76, 155, 168, 268, 2045, 405, 404, 21, 582, 144, 0];
// 步数参考数据
const STEP_NUMBER_REFERENCE_DATA: Array<number> = [0, 0, 0, 0, 0, 0, 230, 706, 809, 450, 166, 186, 708, 304, 31, 166, 188, 406, 1405, 155, 303, 122, 0, 0, 0, 0, 0, 0];

/**
 * 场景描述：当前组件为MpCharts页面。
 * 利用曲线图和柱状图构建了的健康数据页面。
 * 具体实现参考 LineCharts 和 BarCharts 页面。
 */
@AppRouter({ name: "healthchart/MpCharts" })
@Preview
@Component
export struct MpCharts {

  build() {
    List() {
      ListItem() {
        Column() {
          Row() {
            Row() {
              Text($r('app.string.bar_chart_health_fitness_record'))
                .font({
                  size: $r('app.integer.bar_chart_health_font_size_twenty_four'),
                  weight: FontWeight.Bold,
                  family: $r('app.string.bar_chart_health_font_family')
                })

              Text($r('app.string.bar_chart_health_fitness_date'))
                .font({
                  size: $r('app.integer.bar_chart_health_font_size_twenty'),
                  weight: FontWeight.Bold,
                  family: $r('app.string.bar_chart_health_font_family')
                })
                .fontColor(Color.Gray)
                .margin({ left: $r('app.integer.bar_chart_health_margin_ten') })
                .alignSelf(ItemAlign.End)
            }

            Text($r('app.string.bar_chart_health_fitness_rate'))
              .font({ size: $r('app.integer.bar_chart_health_font_size_eighteen'), family: $r('app.string.bar_chart_health_font_family') })
              .alignSelf(ItemAlign.End)

          }
          .width('100%')
          .alignItems(VerticalAlign.Bottom)
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ bottom: $r('app.integer.bar_chart_health_margin_twenty') })

          // 柱状图组件
          BarCharts()
        }
        .width($r('app.string.bar_chart_health_layout_full_size'))
        .backgroundColor(Color.White)
        .border({ radius: $r('app.integer.bar_chart_health_radius_twenty') })
        .shadow({ radius: $r('app.integer.bar_chart_health_radius_ten'), color: Color.Gray })
        .padding($r('app.integer.bar_chart_health_padding_twenty'))
      }
      .margin({ bottom: $r('app.integer.bar_chart_health_margin_twenty') })

      ListItem() {
        Column() {
          Row() {
            Text($r('app.string.bar_chart_health_record'))
              .font({
                size: $r('app.integer.bar_chart_health_font_size_twenty_four'),
                weight: FontWeight.Bold,
                family: $r('app.string.bar_chart_health_font_family')
              })

            Text($r('app.string.bar_chart_health_date'))
              .font({
                size: $r('app.integer.bar_chart_health_font_size_twenty'),
                weight: FontWeight.Bold,
                family: $r('app.string.bar_chart_health_font_family')
              })
              .fontColor(Color.Gray)
              .margin({ left: $r('app.integer.bar_chart_health_margin_ten') })
              .alignSelf(ItemAlign.End)
          }
          .width($r('app.string.bar_chart_health_layout_full_size'))
          .alignItems(VerticalAlign.Bottom)
          .margin({ bottom: $r('app.integer.bar_chart_health_margin_twenty') })

          Divider()
            .margin({ bottom: $r('app.integer.bar_chart_health_margin_twenty') })
            .color($r('app.color.bar_chart_health_divider'))

          Text($r('app.string.bar_chart_health_heart_rate'))
            .font({
              size: $r('app.integer.bar_chart_health_font_size_twenty'),
              weight: FontWeight.Bold,
              family: $r('app.string.bar_chart_health_font_family')
            })
            .alignSelf(ItemAlign.Start)
          // 曲线图组件
          LineCharts({
            type: HEART_RATE,
            todayData: HEART_RATE_TODAY_DATA,
            referenceData: HEART_RATE_REFERENCE_DATA
          })

          Text($r('app.string.bar_chart_health_step_number'))
            .font({
              size: $r('app.integer.bar_chart_health_font_size_twenty'),
              weight: FontWeight.Bold,
              family: $r('app.string.bar_chart_health_font_family')
            })
            .alignSelf(ItemAlign.Start)
          // 曲线图组件
          LineCharts({
            type: STEP_NUMBER,
            todayData: STEP_NUMBER_TODAY_DATA,
            referenceData: STEP_NUMBER_REFERENCE_DATA
          })
        }
        .width($r('app.string.bar_chart_health_layout_full_size'))
        .backgroundColor(Color.White)
        .border({ radius: $r('app.integer.bar_chart_health_radius_twenty') })
        .shadow({ radius: $r('app.integer.bar_chart_health_radius_ten'), color: Color.Gray })
        .padding($r('app.integer.bar_chart_health_padding_twenty'))
      }
    }
    .id('mpChartList')
    .height($r('app.string.bar_chart_health_layout_full_size'))
    .backgroundColor(Color.Gray)
    .padding({
      top: $r('app.integer.bar_chart_health_padding_ten'),
      left: $r('app.integer.bar_chart_health_padding_ten'),
      right: $r('app.integer.bar_chart_health_padding_ten')
    })
    .width($r('app.string.bar_chart_health_layout_full_size'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}