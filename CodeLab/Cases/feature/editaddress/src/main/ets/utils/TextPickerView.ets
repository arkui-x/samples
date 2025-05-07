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

import CommonConstants from '../common/CommonConstants';
import { Cascade } from '../model/Cascade';

const SPACE_THIRTY = 70; // 标题字体间距值

/**
 * 功能描述: 通过使用TextPicker滑动选择文本内容组件实现联动选择联动的内容，并回填到输入框。
 *
 * 实现原理：
 * 1. 通过传入的cascade读取联动数据传入TextPicker中。
 * 2. 当滑动选中TextPicker文本内容后，通过.onChange((value: string | string[])触发回调，点击确定，返回给调用者处理。
 *
 * @param {Array<Cascade>} cascade - 联动资源属性
 * @param {void} selectHandle - 点击确定逻辑
 * @param {void} cancelHandle - 点击取消逻辑
 * @param {number | number []} indexArr - 默认选中项在数组中的索引值
 * @param {string | Resource} title - TextPickerView标题
 */
@Component
export struct TextPickerView {
  // --------------必传属性---------------
  // 联动资源属性
  cascade: Array<Cascade> = [];
  // 确定逻辑
  selectHandle: (selectArr: number | number []) => void =
    (selectArr: number | number []) => {
    };
  // 取消逻辑
  cancelHandle: () => void =
    () => {
    };
  // 默认选中项在数组中的索引值
  indexArr: number | number [] = [0, 0, 0];
  // textPicker标题
  title: string | Resource = '';

  build() {
    Column() {
      Row({ space: SPACE_THIRTY }) {
        Text($r('app.string.editaddress_bind_sheet_cancel'))
          .fontColor($r('app.color.editaddress_font_color'))
          .fontSize(CommonConstants.HALF_FONTSIZE)
          .fontWeight(CommonConstants.HALF_FONT_WEIGHT)
          .padding({ bottom: CommonConstants.HALF_PADDING_BOTTOM, left: 50 })
          .onClick(() => {
            this.cancelHandle()
          })

        Text(this.title)
          .fontColor(Color.Black)
          .fontSize(CommonConstants.HALF_FONTSIZE_TITLE)
          .padding({ bottom: CommonConstants.HALF_PADDING_BOTTOM })

        Text($r('app.string.editaddress_bind_sheet_verify'))
          .fontColor($r('app.color.editaddress_halfModalLogin_font_color'))
          .fontSize(CommonConstants.HALF_FONTSIZE)
          .fontWeight(CommonConstants.HALF_FONT_WEIGHT)
          .padding({ bottom: CommonConstants.HALF_PADDING_BOTTOM })
          .onClick(() => {
            this.selectHandle(this.indexArr)
          })
          .id('verify')
      }
      .padding({ top: CommonConstants.PADDING_TOP })
      .backgroundColor($r('app.color.editaddress_bind_sheet_title_bgc'))
      .width(CommonConstants.FULL_PERCENT)

      TextPicker({
        range: this.cascade,
        selected: this.indexArr
      })
        /**
         * TODO:知识点：滑动选中TextPicker文本内容后，触发onChange()回调。当显示文本或图片加文本列表时，value值为选中项中的文本值，当显示图片列表时，value值为空。
         * index为当前选中项的索引值。多列的情况，index为数组类型。
         * TextPicker参考文档：
         * https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-basic-components-textpicker-V5
         */
        .onChange((value: string | string[], index: number | number[]) => {
          if (index instanceof Array) {
            this.indexArr = index;
          }
        })
        // 设置所有选项中除了最上、最下及选中项以外的文本颜色、字号、字体粗细。
        .textStyle({
          color: $r('app.color.editaddress_textStyle_font_color'),
          font: {
            size: $r('app.string.editaddress_textStyle_font_size'),
            weight: FontWeight.Regular
          }
        })
        // 设置选中项的文本颜色、字号、字体粗细。
        .selectedTextStyle({
          color: $r('app.color.editaddress_selectedTextStyle_font_color'),
          font: {
            size: $r('app.string.editaddress_selectedTextStyle_font_size'),
            weight: FontWeight.Medium
          }
        })
        .padding({ top: CommonConstants.PADDING })
        .id('chooseAddressPicker')
    }
  }
}