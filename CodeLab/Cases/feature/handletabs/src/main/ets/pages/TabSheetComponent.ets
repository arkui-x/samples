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

import { STYLE_CONFIGURATION } from '../model/constantsData';
import { promptAction } from '@kit.ArkUI';

const MAX_SHEET_COUNT = 6; // 最大页签数量
const HIDE_CLOSE_SHEET_COUNT = 4; // 隐藏关闭按钮时页签数量

@Component
export struct TabSheets {
  @Link tabArray: Array<number>; // 控制页签渲染的数组
  @Link @Watch('onFocusIndexChange') focusIndex: number; // Tabs组件当前显示的页签下标
  controller: TabsController = new TabsController(); // Tabs控制器
  @State middleIndex: number = this.focusIndex; // 中间变量
  private toastDuration: number = 2000; // toast弹窗时长

  /**
   * 更新中间变量
   */
  onFocusIndexChange() {
    this.middleIndex = this.focusIndex;
  }

  build() {
    Row({ space: STYLE_CONFIGURATION.TAB_BAR_ITEM_GUTTER }) {
      // 性能知识点：此处为横向列表，列表项确定且数量较少，使用了ForEach，在列表项多的情况下，推荐使用LazyForeEach
      ForEach(this.tabArray, (item: number, index: number) => {
        Row({ space: STYLE_CONFIGURATION.TAB_BAR_CONTENT_GUTTER }) {
          Image($r('app.media.handle_tabs_ic_public_worldclock_filled'))
            .width(STYLE_CONFIGURATION.ICON_SIZE)
            .aspectRatio(1)
          Text($r('app.string.handletabs_handle_tabs_new_sheet'))
            .textOverflow({ overflow: TextOverflow.Clip })
            .maxLines(1)
            .flexShrink(1)
          /**
           * 场景1：页签数量小于HIDE_CLOSE_SHEET_COUNT时，所有页签都显示关闭图标。
           * 场景2：页签数量大于HIDE_CLOSE_SHEET_COUNT时，只有获焦页签显示关闭图标。
           */
          Stack() {
            if (this.tabArray.length < HIDE_CLOSE_SHEET_COUNT || this.middleIndex === index) {
              Image($r('app.media.handle_tabs_ic_public_cancel_filled'))
                .id('tabs_cancel')
                .width(STYLE_CONFIGURATION.BIG_ICON_SIZE)
                .aspectRatio(1)
                .padding(STYLE_CONFIGURATION.BIG_ICON_PADDING)
                .margin(this.tabArray.length === MAX_SHEET_COUNT ? { right: STYLE_CONFIGURATION.IMAGE_MARGIN } : 0)
                .onClick(() => {
                  // 关闭页签
                  if (this.tabArray.length > 1) {
                    this.tabArray.splice(index, 1);
                    if (this.tabArray[index] === undefined) {
                      this.focusIndex = index - 1;
                    } else if (this.tabArray[index] !== undefined && this.focusIndex !== index) {
                      this.focusIndex -= 1;
                    }
                  }
                })
            }
          }
        }
        .flexShrink(1)
        .padding({
          left: $r('sys.float.ohos_id_elements_margin_horizontal_m'),
          right: $r('sys.float.ohos_id_elements_margin_horizontal_m')
        })
        .borderRadius($r('sys.float.ohos_id_corner_radius_default_xs'))
        .height('100%')
        .backgroundColor(this.middleIndex === index ? $r('sys.color.ohos_id_color_background') :
        $r('sys.color.ohos_id_color_sub_background'))
        .onClick(() => {
          this.controller.changeIndex(index);
          this.focusIndex = index;
        })

        // 性能知识点：if条件变更时，会导致if嵌套子组件所在的父组件接节点刷新，使用Stack容器可以减少刷新范围
        Stack() {
          if (this.middleIndex !== index && this.middleIndex - 1 !== index) {
            Divider()
              .vertical(true)
              .strokeWidth(STYLE_CONFIGURATION.SEPARATOR_STROKE_WIDTH)
              .height('50%')
              .lineCap(LineCapStyle.Round)
          }
        }
      })

      Image($r('app.media.handle_tabs_ic_public_add_filled'))
        .id('tabs_filled')
        .width(STYLE_CONFIGURATION.BIG_ICON_SIZE)
        .aspectRatio(1)
        .padding(STYLE_CONFIGURATION.BIG_ICON_PADDING)
        .onClick(() => {
          // 新增页签
          if (this.tabArray.length < MAX_SHEET_COUNT) {
            this.tabArray.push(this.tabArray.length);
            const newTabIndex: number = this.tabArray.length - 1;
            this.middleIndex = newTabIndex;
            animateTo({ duration: 200 }, () => {
              this.focusIndex = newTabIndex;
            })
          } else {
            promptAction.showToast({
              message: $r("app.string.handletabs_handle_toast"),
              duration: this.toastDuration
            });
          }
        })
    }
    .padding(STYLE_CONFIGURATION.TAB_SHEET_PADDING)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .width('100%')
    .height(STYLE_CONFIGURATION.TAB_BAR_HEIGHT)
  }
}