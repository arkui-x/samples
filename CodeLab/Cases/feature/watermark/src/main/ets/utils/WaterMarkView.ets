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

import { TextModify } from '../model/DataType';
import { CommonConstants } from '../common/CommonConstants';
/**
 * 功能描述：
 * 1. 通过Canvas组件绘制水印视图效果。
 *
 * 实现原理：
 * 1. Canvas组件通过设置文本属性、偏移、角度等绘制水印效果，然后将水印组件通过overlay属性将水印作为浮层放置在页面中。
 *
 * @param {TextModify} [textModify] - 文本属性
 */

@Component
struct WaterMarkView {
  // -------------------对外暴露变量-----------------------
  textModify: TextModify =
    new TextModify(CommonConstants.TEXT_CONTENT1, CommonConstants.FONT_SIZE1, CommonConstants.FONT_COLOR1);
  // --------------------私有属性-------------------------
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  build() {
    Canvas(this.context)
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.Transparent)
      .onReady(() => {
        // TODO:知识点:通过canvas绘制水印
        this.context.fillStyle = this.textModify.fontColor;
        this.context.font = this.textModify.fontSize;
        this.context.textAlign = this.textModify.textAlign;
        this.context.textBaseline = this.textModify.textBaseline;
        // 120为每个水印文本的宽度
        for (let i = 0; i < this.context.width / 120; i++) {
          this.context.translate(120, 0);
          let j = 0;
          // 每个水印的高度
          for (; j < this.context.height / 120; j++) {
            // 旋转角度30
            this.context.rotate(-Math.PI / 180 * 30);
            // 文本纵轴和横轴偏移位置-60
            this.context.fillText(this.textModify.text, -60, -60);
            this.context.rotate(Math.PI / 180 * 30);
            this.context.translate(0, 120);
          }
          this.context.translate(0, -120 * j);
        }
      })
  }
}

@Builder
export function createWaterMarkView(textModify: TextModify) {
  WaterMarkView({
    textModify
  })
    .hitTestBehavior(HitTestMode.None) // 必须设置其触摸测试为None或者transparent，否则正常组件无法响应事件
}