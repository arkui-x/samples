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

const ANIMATION_DURATION = 200           // 弹窗动画时长
const Y_TRANSLATE_DISTANCE = 100         // 弹窗动画y轴移动距离

/**
 * 限制高度底部弹窗
 */
@CustomDialog
export struct LimitedHeightBottomDialog {
  controller: CustomDialogController;
  title: string | Resource = '';       // 标题
  maxScrollHeight: Length = '90%';     // 最大可滚动区域高度
  wrapBuilder?: WrappedBuilder<[]>;    // 自定义视图创建方式
  @Link showFlag: Visibility;          // 视图是否显示，用于底部弹窗出现与消失时的动效处理
  @StorageLink('bottomHeight') bottomHeight: number = 0; // 底部导航栏高度

  build() {
    Column() {
      RelativeContainer() {
        Text(this.title)
          .fontSize($r('app.integer.limited_height_bottom_dialog_dialog_title_font_size'))
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
            center: { anchor: '__container__', align: VerticalAlign.Center }
          })

        Image($r('app.media.limited_height_bottom_dialog_close'))
          .width($r('app.integer.limited_height_bottom_dialog_dialog_close_width'))
          .height($r('app.integer.limited_height_bottom_dialog_dialog_close_width'))
          .padding($r('app.integer.limited_height_bottom_dialog_dialog_close_padding'))
          .alignRules({
            right: { anchor: '__container__', align: HorizontalAlign.End },
            center: { anchor: '__container__', align: VerticalAlign.Center }
          })
          .offset({
            x: $r('app.integer.limited_height_bottom_dialog_dialog_close_x_offset')
          })
          .onClick(() => {
            this.closeDialog();
          })
          .id('close_image')
      }.width($r('app.string.limited_height_bottom_dialog_full_width'))
      .height($r('app.integer.limited_height_bottom_dialog_dialog_top_bar_height'))

      Scroll() {
        Column() {
          if (this.wrapBuilder) {
            // 创建自定义视图
            this.wrapBuilder.builder()
          }
        }.width($r('app.string.limited_height_bottom_dialog_full_width'))
        .padding({ bottom: this.bottomHeight + 'px' })
      }.width($r('app.string.limited_height_bottom_dialog_full_width'))
      // TODO：知识点：使用constraintSize方法可以设置约束尺寸，组件布局时，进行尺寸范围限制。这里设置Scroll组件的高度限制。
      .constraintSize({maxHeight: this.maxScrollHeight})
      .id('scroll')
    }.width($r('app.string.limited_height_bottom_dialog_full_width'))
    .backgroundColor($r('app.color.limited_height_bottom_dialog_background_color'))
    .borderRadius({
      topLeft: $r('app.integer.limited_height_bottom_dialog_dialog_radius'),
      topRight: $r('app.integer.limited_height_bottom_dialog_dialog_radius')
    })
    .visibility(this.showFlag)
    .transition(TransitionEffect.OPACITY.animation({ duration: ANIMATION_DURATION })  // 弹窗出现与消失的动效
      .combine(TransitionEffect.translate({ y: Y_TRANSLATE_DISTANCE })),
      (transitionIn: boolean) => {
        if (!transitionIn) {
          this.controller.close();
        }
      }
    )
  }

  /**
   * 关闭弹窗
   */
  private closeDialog() {
    this.showFlag = Visibility.Hidden;
  }
}