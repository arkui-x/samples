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

import router from '@ohos.router';
import { TitleBar } from '../component/TitleBar';
import Logger from '../utils/Logger';
import { TextAreaModifier } from '@ohos.arkui.modifier';
import { LengthMetrics } from '@kit.ArkUI';

class MyModifier extends TextAreaModifier {
  applyNormalAttribute(instance: TextAreaModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .placeholderColor(Color.Green)
      .placeholderFont({ size: 16, weight: 400 })
      .textAlign(TextAlign.Center)
      .caretColor(Color.Blue)
      .fontColor('#182431')
      .fontSize(16)
      .fontStyle(FontStyle.Italic)
      .fontWeight(FontWeight.Bold)
      .fontFamily('HarmonyOS Sans')
      .inputFilter('[0-9]', (filterValue: string) => {
      })
      .copyOption(CopyOptions.InApp)
      .maxLength(40)
      .showCounter(true)
      .style(TextContentStyle.DEFAULT)
      .enableKeyboardOnFocus(false)
      .selectionMenuHidden(true)
      .maxLines(2)
      .type(TextAreaType.NORMAL)
      .enterKeyType(EnterKeyType.Done)
      .lineHeight(25)
      .decoration({
        type: TextDecorationType.Underline,
        color: Color.Red,
        style: TextDecorationStyle.WAVY,
      })
      .letterSpacing(3)
      .fontFeature("\"ss01\" on")
      .wordBreak(WordBreak.BREAK_WORD)
      .selectedBackgroundColor('#ff70a4db')
      .caretStyle({ width: 10, color: Color.Blue })
      .textIndent(10)
      .textOverflow(TextOverflow.None)
      .minFontSize(0)
      .maxFontSize(50)
      .heightAdaptivePolicy(TextHeightAdaptivePolicy.MAX_LINES_FIRST)
      .lineSpacing(LengthMetrics.vp(4))
      .lineBreakStrategy(LineBreakStrategy.GREEDY)
      .editMenuOptions({
        onCreateMenu: (menuItems: Array<TextMenuItem>) => {
          return null
        },
        onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
          return null
        }
      })
  }
}

@Entry
@Component
struct TestTextAreaModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  @State text: string = ''

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })

      Column() {
        Scroll() {
          Column() {
            TextArea({
              text: this.text,
              placeholder: '当前无文本输入',
            })
              .attributeModifier(this.modifier)
              .onChange((value: string) => {
                this.text = value
              })
          }
        }.scrollBar(BarState.Off)
      }
      .size({ width: '98%', height: '40%' })
      .border({
        width: 3,
        color: Color.Pink,
        radius: 30,
        style: BorderStyle.Solid
      })
      .margin({ top: 10, bottom: 10 })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}