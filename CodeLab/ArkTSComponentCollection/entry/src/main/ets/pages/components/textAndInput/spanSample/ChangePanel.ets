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

import { CommonItemSlider, CommonItemSelect, CommonItemColorSelect } from '../../../../common/AttributeModificationTool'
import { selectData } from '../../ComponentData'
import { getStringArrayData } from '../../../../data/ResourceDataHandle'

@Component
export struct ChangePanel {
  @Link letterSpacing: number
  @Link decoration: TextDecorationType
  @Link decorationColor: Color
  @Link lineHeight: number

  build() {
    Column() {
      CommonItemSlider({
        changeValue: $letterSpacing,
        min: 0,
        max: 12,
        name: $r('app.string.span_letter_spacing'),
        testId:'Slider1'
      })

      CommonItemSlider({
        changeValue: $lineHeight,
        min: 0,
        max: 100,
        name: $r('app.string.span_line_height'),
        testId:'Slider2'
      })

      CommonItemSelect({
        name: $r('app.string.span_decoration_type'),
        selects: getStringArrayData(selectData),
        callback: (index) => {
          switch (index) {
            case 1:
              this.decoration = TextDecorationType.LineThrough
              break
            case 2:
              this.decoration = TextDecorationType.Underline
              break
            case 3:
              this.decoration = TextDecorationType.Overline
              break
            default:
              this.decoration = TextDecorationType.None
          }
        }
      })

      CommonItemColorSelect({
        name: $r('app.string.span_decoration_color'),
        selectColor: $decorationColor
      })
    }
  }
}