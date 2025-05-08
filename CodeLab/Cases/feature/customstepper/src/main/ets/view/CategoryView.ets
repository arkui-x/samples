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

import { SubmitInfoWrapper } from '../common/DataModel';
import { FooterView } from './FooterView';
import { promptAction } from '@kit.ArkUI';

@Component
export struct CategoryView {
  @State checkedIndex: number | undefined = undefined; // 被选中项的index
  currentIndex: number = 0; // 当前页面的索引（在Swiper中的）
  lastIndex: number | undefined = undefined; // 最后一个页面的索引
  controller: SwiperController | undefined = undefined; // Swiper的Controller，用以控制页面的前进后退
  submitInfo: SubmitInfoWrapper | undefined = undefined; // 要提交的信息
  categoryArray: string[] = // 类别信息（供用户选择）
    getContext(this).resourceManager.getStringArrayValueSync($r("app.strarray.stepper_category_array").id);
  readonly group: string = "category"; // Radio的group属性
  readonly ITEM_SPACE: number = 5; // Radio每个选项的间隔

  build() {
    Column() {
      Scroll() {
        Column({ space: this.ITEM_SPACE }) {
          ForEach(this.categoryArray, (item: string, index: number) => {
            Row() {
              Radio({ value: index.toString(), group: this.group })
                .checked(this.checkedIndex === index)
                .onChange((isChecked: boolean) => {
                  this.checkedIndex = index;
                  if (isChecked && this.submitInfo) {
                    this.submitInfo.category = index;
                  }
                })
                .id('option')
              Text(item)
                .layoutWeight(1)
                .fontSize($r("app.integer.stepper_category_font_size"))
                .onClick(() => {
                  this.checkedIndex = index;
                  if (this.submitInfo) {
                    this.submitInfo.category = this.checkedIndex;
                  }
                })
            }
          })
        }
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .width('100%')
      .align(Alignment.Top)

      FooterView({
        currentIndex: this.currentIndex,
        lastIndex: this.lastIndex,
        controller: this.controller,
        nextCb: () => { // TODO 知识点：定义页面较验的回调，只有函数返回true时，才能切换到下一页，否则提示用户存在未填写的数据
          let verified: boolean = this.submitInfo !== undefined && this.submitInfo.category !== undefined;
          if (!verified) {
            promptAction.showToast({ message: $r("app.string.stepper_info_not_filled") });
          }
          return verified;
        }
      })
    }
    .height('100%')
    .width('100%')
    .margin({ top: $r("sys.float.ohos_id_card_margin_start") })
  }
}