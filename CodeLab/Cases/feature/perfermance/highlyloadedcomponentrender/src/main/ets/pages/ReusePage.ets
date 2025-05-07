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

import { dateToLunar, getMonthDate } from './GetDate';
import hiTraceMeter from '@ohos.hiTraceMeter';
import { displaySync } from '@kit.ArkGraphics2D';
import { Month, MonthDataSource } from './MonthDataSource';
import { AppRouter } from 'routermodule';

const MONDAY = '一';
const TUESDAY = '二';
const WEDNESDAY = '三';
const THURSDAY = '四';
const FRIDAY = '五';
const SATURDAY = '六';
const SUNDAY = '日';
const WEEK: string[] = [SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY]; // 设置日历周，从周日开始
const MONTH: string = '月';
const YEAR: string = '年';

/**
 * 通过组件复用，加载每个月份的数据，当数据量较多时，快速滑动到底部，会出现掉帧的情况。
 */

@AppRouter({ name: "highlyloadedcomponentrender/ReusePage" })
@Component
export struct ReusePage {
  @State contentData: MonthDataSource = new MonthDataSource(); // 列表数据
  nowDate = new Date();
  currentMonth: number = this.nowDate.getMonth() + 1; // 当前月份
  currentDay: number = this.nowDate.getDate(); // 当前日
  currentYear: number = this.nowDate.getFullYear(); // 当前年份
  currentWeekDay: number = new Date(this.currentYear, this.currentMonth - 1, this.currentDay).getDay(); // 当前周几

  // 初始化日历中一年的数据
  initCalenderData() {
    // 添加自定义trace标签，用于在trace抓取结果中查看相关运行时间信息
    hiTraceMeter.startTrace('push_data_direct', 1);
    for (let k = this.currentYear; k < 2035; k++) {
      for (let i = 1; i <= 12; i++) {
        // 获取每个月的日数据
        const monthDays: number[] = getMonthDate(i, k);
        const lunarDays: string[] = [];
        for (let j = 0; j < monthDays.length; j++) {
          if (monthDays[j] === 0) {
            lunarDays.push("");
          } else {
            lunarDays.push(dateToLunar(k, i, monthDays[j]));
          }
        }
        const month: Month = {
          month: i + MONTH,
          num: i,
          days: monthDays,
          lunarDays: lunarDays,
          year: k
        }
        this.contentData.pushData(month);
      }
    }
    hiTraceMeter.finishTrace('push_data_direct', 1);
  }

  aboutToAppear() {
    this.initCalenderData();
  }

  build() {
    Column() {
      Text(this.currentYear + YEAR)
        .width($r('app.string.percent_100'))
        .height($r('app.integer.highlyloadedcomponentrender_year_height'))
        .fontSize($r('app.integer.highlyloadedcomponentrender_year_font_size'))
        .fontColor(Color.Black)
        .backgroundColor($r("app.color.highlyloadedcomponentrender_color_year_background"))
        .textAlign(TextAlign.Center)
        .id('id_highly_loaded_component_render_title')
      List() {
        LazyForEach(this.contentData, (monthItem: Month) => {
          // 每个月的日期
          ListItem() {
            ItemView({
              monthItem: monthItem,
              currentMonth: this.currentMonth,
              currentDay: this.currentDay
            }).reuseId("reuse_id_" + monthItem.days.length.toString())
          }
        })
      }
      .layoutWeight(1)
      .width($r('app.string.percent_100'))
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Off)
      .padding({
        left: $r('app.integer.highlyloadedcomponentrender_list_padding_left'),
        right: $r('app.integer.highlyloadedcomponentrender_list_padding_right'),
      })
      .id('id_highly_loaded_component_render_list')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .width($r('app.string.percent_100'))
    .height($r('app.string.percent_100'))
    .borderRadius({
      topLeft: $r('app.string.ohos_id_corner_radius_default_l'),
      topRight: $r('app.string.ohos_id_corner_radius_default_l')
    })
    .backgroundColor($r('app.color.ohos_id_color_background'))
    .alignItems(HorizontalAlign.Center)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}

@Reusable
@Component
struct ItemView {
  @State monthItem: Month = {
    month: '',
    num: 0,
    days: [],
    lunarDays: [],
    year: 0
  };
  private currentMonth: number = 0;
  private currentDay: number = 0;

  aboutToReuse(params: Record<string, Object>): void {
    hiTraceMeter.startTrace("reuse_" + (params.monthItem as Month).month, 1);
    this.monthItem = params.monthItem as Month;
    hiTraceMeter.finishTrace("reuse_" + (params.monthItem as Month).month, 1);
  }

  build() {
    Flex({ wrap: FlexWrap.Wrap }) {
      // 月份信息
      Text(this.monthItem.month)
        .fontSize($r('app.integer.highlyloadedcomponentrender_month_font_size'))
        .height($r('app.integer.highlyloadedcomponentrender_month_height'))
        .fontColor(Color.Black)
        .width($r('app.string.percent_100'))
        .textAlign(TextAlign.Start)
        .layoutWeight(1)
      ForEach(WEEK, (weekday: string) => {
        Text(weekday)
          .fontSize($r('app.integer.highlyloadedcomponentrender_week_font_size'))
          .width($r('app.integer.highlyloadedcomponentrender_week_width'))
          .height($r('app.integer.highlyloadedcomponentrender_week_height'))
          .fontColor(weekday === SUNDAY || weekday === SATURDAY ? Color.Red : Color.Black)
          .borderRadius($r('app.integer.highlyloadedcomponentrender_week_border_radius'))
          .textAlign(TextAlign.Center)
          .layoutWeight(1)
      }, (index: number): string => index.toString())

      // 日期信息
      ForEach(this.monthItem.days, (day: number, index: number) => {
        Text() {
          Span(day.toString() + "\n")
            .fontSize($r('app.integer.highlyloadedcomponentrender_day_font_size'))
          Span(this.monthItem.lunarDays[index] === "" ? '' : this.monthItem.lunarDays[index])
            .fontSize($r('app.integer.highlyloadedcomponentrender_day_lunar_font_size'))
        }
        .height($r('app.integer.highlyloadedcomponentrender_day_height'))
        .width($r('app.integer.highlyloadedcomponentrender_day_width'))
        .fontColor(day === this.currentDay && this.monthItem.num === this.currentMonth ? Color.White : Color.Black)
        .borderRadius($r('app.integer.highlyloadedcomponentrender_day_border_radius'))
        .textAlign(TextAlign.Center)
        .opacity(day === 0 ? 0 : 1) // 将日期数组中为0的都设置为不显示，即不显示上个月和下个月的内容
        .backgroundColor(day === this.currentDay && this.monthItem.num === this.currentMonth ?
        $r('app.color.ohos_id_color_palette9') : Color.Transparent)
        .layoutWeight(1)
      }, (index: number): string => index.toString())
    }
    .alignSelf(ItemAlign.Start)
    .backgroundColor(Color.Transparent)
    .margin({
      top: $r('app.integer.highlyloadedcomponentrender_month_margin_top')
    })
    .width($r('app.integer.highlyloadedcomponentrender_month_width'))
  }
}