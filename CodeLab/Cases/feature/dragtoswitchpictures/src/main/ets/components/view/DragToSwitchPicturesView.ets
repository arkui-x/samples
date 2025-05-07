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

import { CONFIGURATION } from '../common/Constants';


@Component
export struct DecorationComparisonView {
  @State dragRefOffset: number = 0; // 用来记录每次图标拖动的距离
  @State imageWidth: number = 160; // 用来记录每次图标拖动完成后左侧Image的width宽度
  @State leftImageWidth: number = 160; // 用来记录每次图标拖动时左侧Image的实时width宽度
  @State rightImageWidth: number = 160; // 用来记录每次图标拖动时右侧Image的实时width宽度

  build() {
    Row() {
      /**
       * 创建三个Stack组件，用来展示装修前后对比图，第一个和第三个Stack分别存放装修前的图片和装修后的图片，zIndex设置为1。
       * 第二个Stack存放按钮的图片，zIndex设置为2，这样按钮的图片就会覆盖在两张装修图片之上。
       */
      Stack() {
        Row() {
          Image($r("app.media.dragtoswitchpictures_before_decoration"))
            .width($r('app.integer.dragtoswitchpictures_decoration_width'))// Image的width固定，Row的宽度变化，通过裁剪实现布局效果。
            .height($r('app.integer.dragtoswitchpictures_decoration_height'))
            .draggable(false) // 设置Image不能拖动，不然长按Image会被拖动。
        }
        .width(this.leftImageWidth) // 将左侧Row的width设置为leftImageWidth，这样左侧Row的width随leftImageWidth的变化而变化。
        .zIndex(CONFIGURATION.ZINDEX1) // z序设为1，为了使水印浮在装修图片上。
        .clip(true) // clip属性设置为true，裁剪超出Row宽度的图片。
        .borderRadius({
          topLeft: $r('app.integer.dragtoswitchpictures_borderradius'),
          bottomLeft: $r('app.integer.dragtoswitchpictures_borderradius')
        }) // 将Row的左上角和左下角弧度设为10实现效果。


        Text($r('app.string.dragtoswitchpictures_before_decoration'))
          .width($r('app.integer.dragtoswitchpictures_decoration_text_width'))
          .height($r('app.integer.dragtoswitchpictures_decoration_text_height'))
          .textAlign(TextAlign.Center)
          .fontSize($r('app.integer.dragtoswitchpictures_decoration_text_fontsize'))
          .fontColor($r('app.color.dragtoswitchpictures_before_text_fontcolor'))
          .backgroundColor($r('app.color.dragtoswitchpictures_before_text_backgroundcolor'))
          .borderRadius($r('app.integer.dragtoswitchpictures_decoration_text_borderradius'))
          .margin({
            top: $r('app.integer.dragtoswitchpictures_margin_length'),
            left: $r('app.integer.dragtoswitchpictures_margin_length')
          })
          .zIndex(CONFIGURATION.ZINDEX2) // z序设为2，为了使水印浮在装修图片上。
      }
      // TODO: 知识点：Z序控制，同一容器中兄弟组件显示层级关系。zIndex值越大，显示层级越高，即zIndex值大的组件会覆盖在zIndex值小的组件上方。
      .zIndex(CONFIGURATION.ZINDEX1) // z序设为1，为了使按钮图片浮在装修图片上。
      .width(this.leftImageWidth) // 将左侧Stack的width设置为leftImageWidth，这样左侧Stack的width随leftImageWidth的变化而变化。
      .clip(true)
      .alignContent(Alignment.TopStart)
      .id('left_picture')

      Column() {
        Image($r("app.media.dragtoswitchpictures_drag_button"))
          .width($r('app.integer.dragtoswitchpictures_drag_button_image_width'))
          .height($r('app.integer.dragtoswitchpictures_decoration_height'))
          .id('drag_switch')
          .draggable(false)
          .gesture(// TODO: 知识点：拖动手势事件设置一个手指，滑动的最小距离设置为1vp，实现滑动时按钮跟手动效。
            PanGesture({ fingers: CONFIGURATION.PANGESTURE_FINGERS, distance: CONFIGURATION.PANGESTURE_DISTANCE })
              .onActionStart(() => {
                this.dragRefOffset = CONFIGURATION.INIT_VALUE; // 每次拖动开始时将图标拖动的距离初始化。
              })// TODO: 性能知识点: 该函数是系统高频回调函数，避免在函数中进行冗余或耗时操作，例如应该减少或避免在函数打印日志，会有较大的性能损耗。
              .onActionUpdate((event: GestureEvent) => {
                // 通过监听GestureEvent事件，实时监听图标拖动距离
                this.dragRefOffset = event.offsetX;
                this.leftImageWidth = this.imageWidth + this.dragRefOffset;
                this.rightImageWidth = CONFIGURATION.IMAGE_FULL_SIZE - this.leftImageWidth;
                if (this.leftImageWidth >= CONFIGURATION.LEFT_IMAGE_RIGHT_LIMIT_SIZE) { // 当leftImageWidth大于等于310vp时，设置左右Image为固定值，实现停止滑动效果。
                  this.leftImageWidth = CONFIGURATION.LEFT_IMAGE_RIGHT_LIMIT_SIZE;
                  this.rightImageWidth = CONFIGURATION.RIGHT_IMAGE_RIGHT_LIMIT_SIZE;
                } else if (this.leftImageWidth <= CONFIGURATION.LEFT_IMAGE_LEFT_LIMIT_SIZE) { // 当leftImageWidth小于等于30vp时，设置左右Image为固定值，实现停止滑动效果。
                  this.leftImageWidth = CONFIGURATION.LEFT_IMAGE_LEFT_LIMIT_SIZE;
                  this.rightImageWidth = CONFIGURATION.RIGHT_IMAGE_LEFT_LIMIT_SIZE;
                }
              })
              .onActionEnd((event: GestureEvent) => {
                if (this.leftImageWidth <= CONFIGURATION.LEFT_IMAGE_LEFT_LIMIT_SIZE) {
                  this.leftImageWidth = CONFIGURATION.LEFT_IMAGE_LEFT_LIMIT_SIZE;
                  this.rightImageWidth = CONFIGURATION.RIGHT_IMAGE_LEFT_LIMIT_SIZE;
                  this.imageWidth = CONFIGURATION.LEFT_IMAGE_LEFT_LIMIT_SIZE;
                } else if (this.leftImageWidth >= CONFIGURATION.LEFT_IMAGE_RIGHT_LIMIT_SIZE) {
                  this.leftImageWidth = CONFIGURATION.LEFT_IMAGE_RIGHT_LIMIT_SIZE;
                  this.rightImageWidth = CONFIGURATION.RIGHT_IMAGE_RIGHT_LIMIT_SIZE;
                  this.imageWidth = CONFIGURATION.LEFT_IMAGE_RIGHT_LIMIT_SIZE;
                } else {
                  this.leftImageWidth = this.imageWidth + this.dragRefOffset; // 滑动结束时leftImageWidth等于左边原有Width+拖动距离。
                  this.rightImageWidth = CONFIGURATION.IMAGE_FULL_SIZE - this.leftImageWidth; // 滑动结束时rightImageWidth等于340-leftImageWidth。
                  this.imageWidth = this.leftImageWidth; // 滑动结束时ImageWidth等于leftImageWidth。
                }
              })
          )
      }
      .width($r('app.integer.dragtoswitchpictures_drag_button_stack_width'))
      .zIndex(CONFIGURATION.ZINDEX2) // z序设为2，为了使按钮图片浮在装修图片上。

      Stack() {
        Row() {
          Image($r("app.media.dragtoswitchpictures_after_decoration"))
            .width($r('app.integer.dragtoswitchpictures_decoration_width'))
            .height($r('app.integer.dragtoswitchpictures_decoration_height'))
            .draggable(false)
        }
        .width(this.rightImageWidth)
        .clip(true)
        .zIndex(CONFIGURATION.ZINDEX1) // z序设为1，为了使水印浮在装修图片上。
        // TODO: 知识点：左边Row使用clip时从右边开始裁剪，加了Direction.Rtl后，元素从右到左布局，右边Row使用clip时从左边开始裁剪，这是实现滑动改变视图内容大小的关键。
        .direction(Direction.Rtl)
        .borderRadius({
          topRight: $r('app.integer.dragtoswitchpictures_borderradius'),
          bottomRight: $r('app.integer.dragtoswitchpictures_borderradius')
        }) // 将Row的右上角和右下角弧度设为10实现效果。


        Text($r('app.string.dragtoswitchpictures_after_decoration'))
          .width($r('app.integer.dragtoswitchpictures_decoration_text_width'))
          .height($r('app.integer.dragtoswitchpictures_decoration_text_height'))
          .textAlign(TextAlign.Center)
          .fontSize($r('app.integer.dragtoswitchpictures_decoration_text_fontsize'))
          .fontColor($r('app.color.dragtoswitchpictures_after_text_fontcolor'))
          .backgroundColor($r('app.color.dragtoswitchpictures_after_text_backgroundcolor'))
          .borderRadius($r('app.integer.dragtoswitchpictures_decoration_text_borderradius'))
          .margin({
            top: $r('app.integer.dragtoswitchpictures_margin_length'),
            right: $r('app.integer.dragtoswitchpictures_margin_length')
          })
          .zIndex(CONFIGURATION.ZINDEX2) // z序设为2，为了使水印浮在装修图片上。
      }
      .zIndex(CONFIGURATION.ZINDEX1) // z序设为1，为了使按钮图片浮在装修图片上。
      .clip(true)
      .width(this.rightImageWidth)
      .alignContent(Alignment.TopEnd)
      .id('right_picture')
    }
    .margin({ top: $r('app.integer.dragtoswitchpictures_margin_length') })
    .justifyContent(FlexAlign.Center)
    .width($r('app.string.dragtoswitchpictures_full_size'))
  }
}