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

import { ChangePanel } from './ChangePanel'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceAround)
}

@Entry
@Component
struct SpanSample {
  @State letterSpacing: number = 3
  @State decoration: TextDecorationType = TextDecorationType.None
  @State textCase: TextCase = TextCase.Normal
  @State decorationColor: Color = Color.Red
  @State lineHeight: number = 3

  build() {
    Column() {
      TitleBar({ title: $r('app.string.span_title') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.span_attribute') })
          Column() {
            Text() {
              Span($r('app.string.span_content_one'))
                .fontSize(20)
              Span($r('app.string.span_content_two'))
                .fontSize(20)
                .fontColor(Color.Red)
              Span($r('app.string.span_content_three'))
                .fontSize(20)
              Span($r('app.string.span_content_four'))
                .fontSize(24)
                .fontWeight(FontWeight.Bolder)
            }
          }
          .backgroundStyle()

          IntroductionTitle({ introduction: $r('app.string.span_decoration_and_letter_spacing') })
          Column() {
            Text() {
              Span($r('app.string.span_text_decoration'))
                .font({
                  size: 20
                })
                .height(50)
                .lineHeight(this.lineHeight)
                .decoration({
                  type: this.decoration,
                  color: this.decorationColor
                })

              Span($r('app.string.span_text_spacing'))
                .font({
                  size: 20
                })
                .letterSpacing(this.letterSpacing)
            }
            .height(100)
            .fontSize(50)

            ChangePanel({
              letterSpacing: $letterSpacing,
              decoration: $decoration,
              decorationColor: $decorationColor,
              lineHeight: $lineHeight
            })
          }
          .backgroundStyle()

          IntroductionTitle({ introduction: $r('app.string.span_inherits_text_attribute') })
          Column() {
            Text() {
              Span($r('app.string.span_does_not_inherit_text_attribute'))
                .fontSize(20)
                .height(50)

              Span($r('app.string.span_inherits_text_attribute'))
            }
            .height(70)
            .fontSize(10)
          }
          .backgroundStyle()
          .margin({ bottom: 80 })
        }
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen at least
      }
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}