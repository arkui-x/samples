/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { SiteListDataSource } from "../model/SiteListDataSource";
import { promptAction } from "@kit.ArkUI";
import { PlatformInfo } from 'utils'

const BORDER_WIDTH = 0.5; // 边框宽度

@Observed
export class OptionsInterface {
  name: ResourceStr;
  options: Array<ResourceStr>;
  selectItem: Array<number>;

  constructor(name: ResourceStr, options: Array<ResourceStr>, selectItem: Array<number>) {
    this.name = name;
    this.options = options;
    this.selectItem = selectItem;
  }
}

/**
 * 功能描述：
 * 1.构建多重筛选的筛选条件。
 * 2.通过筛选条件筛选出来相关数据。
 *
 * 实现原理：
 * 1.得到筛选的数据后根据点击的筛选数据行数，使用has进行if判断看是否满足多重筛选的条件。
 *
 * @param {Array<OptionsInterface>} filterParam - 筛选数据（必需）
 * @param {boolean} isShow - 筛选卡片是否显示（必需）
 * @param {Array<string>} changData - 筛选出来的数据（必需）
 * @param {Array<number>} arrayListData - 选择的数据的行数index数组（必需）
 * @param {SiteListDataSource} siteList - 场地信息集合（必需）
 */
@Component
export struct FilterComponent {
  @State filterParam: Array<OptionsInterface> =
    [new OptionsInterface('停放时间', ['白天', '夜间', '全天'], []),
      new OptionsInterface('套餐类型', ['次套餐', '日套餐', '月套餐'], []),
      new OptionsInterface('是否支持充电', ['是'], [])]; // 筛选数据
  @Link isShow: boolean; // 筛选卡片是否显示
  @Link changData: Array<string>; // 筛选出来的数据
  @State arrayListData: Array<number> = []; // 选择的数据的行数index数组
  @Link siteList: SiteListDataSource; // 场地信息集合

  build() {
    Column() {
      if (PlatformInfo.isArkUIX()) {
        Row() {
          Row() {
            Text($r('app.string.multiple_screening_filter_component_national'))
              .fontSize($r('app.integer.multiple_screening_filter_component_filter_text'))
            Image($r('app.media.multiple_screening_ic_public_spinner'))
              .width($r('app.integer.multiple_screening_filter_component_filter_image'))
              .height($r('app.integer.multiple_screening_filter_component_filter_image'))
          }
          .width("47%")
          .onClick(() => {
            // 调用Toast显示提示:此样式仅为案例展示
            promptAction.showToast({ message: $r("app.string.multiple_screening_toast_tips") });
          })

          Row() {
            Text($r('app.string.multiple_screening_filter_component_sort'))
              .fontSize($r('app.integer.multiple_screening_filter_component_filter_text'))
            Image($r('app.media.multiple_screening_ic_public_spinner'))
              .width($r('app.integer.multiple_screening_filter_component_filter_image'))
              .height($r('app.integer.multiple_screening_filter_component_filter_image'))
          }
          .width("25%")
          .justifyContent(FlexAlign.End)
          .padding({ right: 0 })
          .onClick(() => {
            // 调用Toast显示提示:此样式仅为案例展示
            promptAction.showToast({ message: $r("app.string.multiple_screening_toast_tips") });
          })

          Row() {
            Text($r('app.string.multiple_screening_filter_component_filter'))
              .fontSize($r('app.integer.multiple_screening_filter_component_filter_text'))
            Image($r('app.media.multiple_screening_ic_public_spinner'))
              .width($r('app.integer.multiple_screening_filter_component_filter_image'))
              .height($r('app.integer.multiple_screening_filter_component_filter_image'))
          }
          .onClick(() => {
            this.isShow = !this.isShow;
          })
          .width("28%")
          .padding({
            left: $r('app.integer.multiple_screening_filter_component_padding_left'),
          })
        }
        .padding({
          left: $r('app.integer.multiple_screening_filter_component_padding_left'),
          right: $r('app.integer.multiple_screening_filter_component_padding_left'),
          top: $r('app.integer.multiple_screening_filter_component_padding_left'),
          bottom: $r('app.integer.multiple_screening_filter_component_padding_bottom')
        })
      } else {
        Row() {
          Row() {
            Text($r('app.string.multiple_screening_filter_component_national'))
              .fontSize($r('app.integer.multiple_screening_filter_component_filter_text'))
            Image($r('app.media.multiple_screening_ic_public_spinner'))
              .width($r('app.integer.multiple_screening_filter_component_filter_image'))
              .height($r('app.integer.multiple_screening_filter_component_filter_image'))
          }
          .width($r('app.string.multiple_screening_filter_component_national_width'))
          .onClick(() => {
            // 调用Toast显示提示:此样式仅为案例展示
            promptAction.showToast({ message: $r("app.string.multiple_screening_toast_tips") });
          })

          Row() {
            Text($r('app.string.multiple_screening_filter_component_sort'))
              .fontSize($r('app.integer.multiple_screening_filter_component_filter_text'))
            Image($r('app.media.multiple_screening_ic_public_spinner'))
              .width($r('app.integer.multiple_screening_filter_component_filter_image'))
              .height($r('app.integer.multiple_screening_filter_component_filter_image'))
          }
          .padding({ right: $r('app.integer.multiple_screening_filter_component_sort_padding') })
          .onClick(() => {
            // 调用Toast显示提示:此样式仅为案例展示
            promptAction.showToast({ message: $r("app.string.multiple_screening_toast_tips") });
          })

          Row() {
            Text($r('app.string.multiple_screening_filter_component_filter'))
              .fontSize($r('app.integer.multiple_screening_filter_component_filter_text'))
            Image($r('app.media.multiple_screening_ic_public_spinner'))
              .width($r('app.integer.multiple_screening_filter_component_filter_image'))
              .height($r('app.integer.multiple_screening_filter_component_filter_image'))
          }
          .onClick(() => {
            this.isShow = !this.isShow;
          })
        }
        .padding({
          left: $r('app.integer.multiple_screening_filter_component_padding_left'),
          right: $r('app.integer.multiple_screening_filter_component_padding_left'),
          top: $r('app.integer.multiple_screening_filter_component_padding_left'),
          bottom: $r('app.integer.multiple_screening_filter_component_padding_bottom')
        })
      }

      this.filterCard()
    }
    .id('filterComponent')
    .backgroundColor($r('app.color.multiple_screening_background_color'))

  }

  @Builder
  filterCard() {
    Column() {
      // 筛选数据
      ForEach(this.filterParam, (item: OptionsInterface, index: number) => {
        FilterData({
          item: item,
          listIndex: index,
          changData: this.changData,
          arrayListData: $arrayListData
        })
      })
      this.filterButton()
    }
    .height($r('app.integer.multiple_screening_filter_component_filter_card_height'))
    .backgroundColor($r('app.color.multiple_screening_background_color'))
    .width($r('app.string.multiple_screening_all_percentage'))
    .position({
      x: $r('app.integer.multiple_screening_filter_component_filter_card_position_x'),
      y: $r('app.integer.multiple_screening_filter_component_filter_card_position_y')
    })
    .visibility(this.isShow ? Visibility.Visible : Visibility.None)
  }

  @Builder
  filterButton() {
    Row() {
      Button($r('app.string.multiple_screening_filter_component_reset'))
        .height($r('app.integer.multiple_screening_filter_component_reset_height'))
        .width($r('app.integer.multiple_screening_filter_component_reset_width'))
        .backgroundColor(Color.White)
        .fontColor($r('app.color.multiple_screening_filter_component_reset_font'))
        .onClick(() => {
          this.filterParam.forEach(item => {
            item.selectItem = [];
            this.changData = [];
            this.arrayListData = [];
          })
          // 还原数据
          this.siteList.getInitalList()
        })
      Button($r('app.string.multiple_screening_filter_component_confirm'))
        .height($r('app.integer.multiple_screening_filter_component_reset_height'))
        .width($r('app.integer.multiple_screening_filter_component_reset_width'))
        .backgroundColor(Color.White)
        .fontColor($r('app.color.multiple_screening_filter_component_reset_font'))
        .onClick(() => {
          this.isShow = false;
          let arrayListData = new Set(this.arrayListData)
          if (arrayListData.has(0) && !arrayListData.has(1)) {
            // 仅选择停放时间
            this.siteList.timeMultiFilter(this.changData);
          } else if (!arrayListData.has(0) && arrayListData.has(1)) {
            // 仅选择套餐类型
            this.siteList.typeMultiFilter(this.changData);
          } else if (!arrayListData.has(0) && !arrayListData.has(1) && arrayListData.has(2)) {
            // 仅选择充电
            this.siteList.getInitalList();
          } else if (this.changData.length === 0) {
            // 未对数据进行选择
            this.siteList.getInitalList();
          } else {
            // 多重筛选
            this.siteList.multiFilter(this.changData);
          }
          if (this.siteList.totalCount() === 0) {
            this.siteList.getInitalList();
            promptAction.showToast({ message: $r('app.string.multiple_screening_filter_component_confirm_prompt') });
          }
        })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width($r('app.string.multiple_screening_filter_component_filter_button_width'))
  }
}

/**
 * 功能描述：
 * 1.构建多重筛选的筛选条件。
 * 2.将筛选数据以及数据行数进行上传
 *
 * 实现原理：
 * 1.将筛选条件push到一个空数据，使用includes查询筛选数据是否存在，如若存在就使用filter方法将数据进行清除。
 * 2.筛选数据分为三种类型，将类型index值push空数组，使用splice清除重复数据
 *
 * @param {OptionsInterface} item - 筛选数据（必需）
 * @param {number[]} selectArr - 每个类型的数据的index值数组（必需）
 * @param {number} listIndex - 筛选数据类型index值（必需）
 * @param {Array<string>} changData - 筛选出来的数据（必需）
 * @param {Array<number>} arrayListData - 选择的数据的行数index数组（必需）
 */
@Component
struct FilterData {
  @ObjectLink @Watch('onChange') item: OptionsInterface; // 筛选数据
  @State selectArr: number[] = []; // 每个类型的数据的index值数组
  private listIndex: number = 0; // 筛选数据类型index值
  @Link changData: Array<string>; // 筛选出来的数据
  @Link arrayListData: Array<number>; // 选择的数据的行数index数组

  onChange() {
    this.selectArr = this.item.selectItem;
  }

  build() {
    Column() {
      Text(this.item.name)
        .fontSize($r('app.integer.multiple_screening_filter_data_item_name_font'))
        .width($r('app.string.multiple_screening_filter_component_filter_button_width'))
        .height($r('app.integer.multiple_screening_filter_data_item_name_height'))

      Grid() {
        ForEach(this.item.options, (options: string, idx: number) => {
          GridItem() {
            Text(options)
              .textAlign(TextAlign.Center)
              .fontSize($r('app.integer.multiple_screening_filter_data_item_name_font'))
              .height($r('app.integer.multiple_screening_filter_data_options_height'))
              .width($r('app.string.multiple_screening_all_percentage'))
          }
          .onClick(() => {
            if (this.item.selectItem.includes(idx)) {
              let index = this.item.selectItem.indexOf(idx);
              let listIdx = this.changData.indexOf(options);
              // 删除已存在的筛选数据的index值
              this.item.selectItem.splice(index, 1);
              // 过滤出来没有重复数据的筛选值
              this.changData = this.changData.filter(i => i !== options);
              this.selectArr = this.item.selectItem;
              // 删除已选择的数据的行数index数组
              this.arrayListData.splice(listIdx, 1);
            } else {
              // 添加筛选数据的index值
              this.item.selectItem.push(idx);
              // 添加选中的数据
              this.changData.push(options);
              this.selectArr = this.item.selectItem;
              // 添加选择的数据的行数index数组
              this.arrayListData.push(this.listIndex);
            }
          })
          .backgroundColor(this.selectArr.includes(idx) ? $r('app.color.multiple_screening_filter_data_grid_color') :
          Color.White)
          .border({
            radius: $r('app.integer.multiple_screening_filter_data_grid_border_radius'),
            color: this.selectArr.includes(idx) ? $r('app.color.multiple_screening_info_card_site_discount_color') :
            $r('app.color.multiple_screening_filter_data_grid_border_color'),
            width: BORDER_WIDTH
          })
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsGap($r('app.integer.multiple_screening_filter_data_rows_gap'))
      .columnsGap($r('app.integer.multiple_screening_filter_data_rows_gap'))
      .margin({
        left: $r('app.integer.multiple_screening_filter_data_rows_gap'),
        right: $r('app.integer.multiple_screening_filter_data_rows_gap'),
        top: $r('app.integer.multiple_screening_filter_data_margin_top'),
        bottom: $r('app.integer.multiple_screening_filter_data_margin_top')
      })
      .layoutDirection(GridDirection.Row)
      .constraintSize({
        minHeight: $r('app.string.multiple_screening_filter_data_min_height'),
        maxHeight: $r('app.string.multiple_screening_filter_data_min_height') // grid会撑满maxHeight，先限定死高度
      })
    }
  }
}