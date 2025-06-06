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

import { CustomCalendarPickerDialog } from './CustomCalendarPickerDialog';
import { DateModel } from '../components/DateModel';
import { getRealTimeDate } from '../components/GetDate';
import { AppRouter } from 'routermodule';
import promptAction from '@ohos.promptAction';

/**
 * 自定义日历选择器
 * 通过Date对象获取当前年月日等具体时间数据，用于日历数据的显示
 * 通过CustomDialogController类显示自定义弹窗，自定义弹窗内容显示为自定义日历
 * 点击主页面当前时间，弹出自定义日历，可以选择日历时间，主页面的时间随之改变
 */

const ELEMENTS_MARGIN_L = 24;
const ELEMENTS_MARGIN_M = 8;
const TRANSITION_DURATION = 200;

@AppRouter({ name: "customcalendarpickerdialog/CalendarView" })
@Component
export struct CalendarView {
  private week: string[] = ['日', '一', '二', '三', '四', '五', '六']; // 设置日历周，从周日开始
  @State currentMonth: number = 1; // 当前月份
  @State currentDay: number = 1; // 当前日
  @State currentYear: number = 1; // 当前年分
  @StorageLink('selectedDate') dateModel: DateModel = new DateModel(0, 0, 0, 0); // 初始化dateModel数据
  @State readyCloseDialog: boolean = false;

  // 获取当前日期
  aboutToAppear(): void {
    let dateModel: DateModel = getRealTimeDate(); // 获取当前年月日信息
    this.currentMonth = dateModel.month; // 获取当前月份
    this.currentDay = dateModel.day; // 获取当前日
    this.currentYear = dateModel.year; // 获取当前年份
  }

  // TODO: 知识点：通过CustomDialogController类显示自定义弹窗
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomCalendarPickerDialog({
      currentMonth: this.currentMonth,
      currentDay: this.currentDay,
      currentYear: this.currentYear,
      cancel: this.onCancel,
      readyCloseDialog: this.readyCloseDialog
    }),
    alignment: DialogAlignment.Bottom, // 自定义弹窗底端对齐
    customStyle: true, // 弹窗样式自定义
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      this.readyCloseDialog = true
      setTimeout(() => {
        this.readyCloseDialog = false
      }, TRANSITION_DURATION)
    },
  })

  // 点击遮障层退出时的回调
  onCancel() {
  }

  // 应用主界面
  @Builder
  calendarMainView() {
    Column({ space: ELEMENTS_MARGIN_L }) {
      // 出发地和目的地显示
      Row() {
        Text($r('app.string.customcalendarpickerdialog_departure'))
          .fontSize($r('app.string.ohos_id_text_size_headline'))
        Image($r("app.media.customcalendarpickerdialog_train_transport_icon"))
          .height($r('app.integer.customcalendarpickerdialog_train_image_size'))
          .width($r('app.integer.customcalendarpickerdialog_train_image_size'))
        Text($r('app.string.customcalendarpickerdialog_destination'))
          .fontSize($r('app.string.ohos_id_text_size_headline'))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      // 当前日期显示
      Row({ space: ELEMENTS_MARGIN_M }) {
        Text(`${this.dateModel.month}月${this.dateModel.day}日`)
          .fontSize($r('app.string.ohos_id_text_size_headline'))
        Text(`星期${this.week[this.dateModel.week]}`)
          .fontSize($r('app.string.ohos_id_text_size_body1'))
      }
      .id('calender_click')
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .onClick(() => {
        // 点击当前日期后打开自定义弹窗显示日历
        this.dialogController.open()
      })

      // 查询车票按钮显示
      Button($r('app.string.customcalendarpickerdialog_check_ticket'))
        .fontSize($r('app.string.ohos_id_text_size_headline'))
        .height($r('app.integer.customcalendarpickerdialog_check_button_height'))
        .width('100%')
        .type(ButtonType.Normal)
        .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
        .onClick(() => {
          // 点击检查车票按钮后显示提示文本框
          promptAction.showToast({
            message: $r('app.string.customcalendarpickerdialog_button_text')
          });
        })
    }
    .backgroundColor($r('app.color.ohos_id_color_background'))
    .padding($r('app.integer.customcalendarpickerdialog_card_padding'))
    .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
  }

  build() {
    Column() {
      this.calendarMainView()
    }
    .backgroundColor($r('app.color.ohos_id_color_sub_background'))
    .width('100%')
    .height('100%')
    .padding($r('app.string.ohos_id_corner_radius_default_m'))
  }
}
