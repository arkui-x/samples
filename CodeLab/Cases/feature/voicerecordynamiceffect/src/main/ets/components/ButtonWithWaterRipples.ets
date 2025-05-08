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

/*
* 使用Foreach渲染出20个宽度相等，高度随机的Column。
* 当音频振幅传过来的时候，column高度会随之随机变化
*/
import { CommonConstants as Const } from '../common/CommonConstants';
import { VerifyModeEnum } from '../enums/VerifyModeEnum';

@Component
export struct ButtonWithWaterRipples {
  @Link columnX: number; // 矩形width
  @Link yMax: number; // 矩形height最大值
  @Link yMin: number; // 矩形height最小值
  @State arr: Array<number> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
  @Link waterRipplesBg: Resource;
  @Link mode: number;

  build() {
    Column() {
      Row({ space: Const.COLUMN_WIDTH }) {
        // TODO：高性能知识点：列表循环应使用懒加载，但是这里列表数量极少，且不存在滚动加载情况，故不使用懒加载
        ForEach(this.arr, (_: number) => {
          Column()
            .width(this.columnX)
            .height(Math.floor(Math.random() * (this.yMin - this.yMax + Const.OPACITY_TRUE) + this.yMax))
            .backgroundColor(Color.Gray)
            .borderRadius($r("app.integer.voice_record_dynamic_effect_radius_column"))
        }, (index: number) => index.toString())
      }
      .width($r("app.string.voice_record_dynamic_effect_width_full"))
      .height(this.mode === VerifyModeEnum.TEXT ? $r("app.string.voice_record_dynamic_effect_height_text") : $r("app.string.voice_record_dynamic_effect_height_full"))
      .justifyContent(FlexAlign.Center)

      if (this.mode === VerifyModeEnum.TEXT) {
        // 转文字
        Row() {
          Text(Const.VERIFY_TEXT)
            .width($r("app.string.voice_record_dynamic_effect_width_full"))
            .textAlign(TextAlign.Center)
        }
        .width($r("app.string.voice_record_dynamic_effect_width_full"))
        .height($r('app.string.voice_record_water_height'))
      }
    }
    .borderRadius(Const.BLANK_COLUMN)
    .backgroundColor(this.waterRipplesBg)
    .width($r("app.string.voice_record_dynamic_effect_width_half"))
    .height(Const.COLUMN_HEIGHT)
    .alignItems(HorizontalAlign.Center)
  }
}