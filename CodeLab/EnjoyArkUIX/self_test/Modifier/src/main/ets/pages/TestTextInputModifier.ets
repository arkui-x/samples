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
import { TextInputModifier } from '@ohos.arkui.modifier';

class MyModifier1 extends TextInputModifier {
  applyNormalAttribute(instance: TextInputModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .type(InputType.Password)
      .placeholderColor(Color.Green)
      .placeholderFont({ size: 16, weight: 400 })
      .enterKeyType(EnterKeyType.Done)
      .caretColor(Color.Blue)
      .maxLength(40)
      .fontColor('#182431')
      .fontSize(16)
      .fontStyle(FontStyle.Italic)
      .fontWeight(FontWeight.Bold)
      .fontFamily('HarmonyOS Sans')
      .inputFilter('[0-9]', (filterValue: string) => {
      })
      .copyOption(CopyOptions.InApp)
      .showPasswordIcon(true)
      .style(TextInputStyle.Default)
      .textAlign(TextAlign.Center)
      .selectedBackgroundColor('#ff70a4db')
      .caretStyle({ width: 10, color: Color.Blue })
      .caretPosition(3)
      .showError('Error')
      .showUnderline(true)
      .passwordIcon({
        onIconSrc: $r('app.media.password_on'),
        offIconSrc: $r('app.media.password_off')
      })
      .enableKeyboardOnFocus(false)
      .selectionMenuHidden(true)
      .maxLines(2)
      .cancelButton({
        style: CancelButtonStyle.INPUT,
        icon: {
          size: 15,
          color: Color.Black,
          src: $r('app.media.icon')
        }
      })
      .selectAll(false)
      .showPassword(true)
      .size({ width: '80%' })
  }
}

class MyModifier2 extends TextInputModifier {
  applyNormalAttribute(instance: TextInputModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .type(InputType.Normal)
      .placeholderColor(Color.Green)
      .placeholderFont({ size: 16, weight: 400 })
      .enterKeyType(EnterKeyType.Done)
      .caretColor(Color.Blue)
      .maxLength(40)
      .fontColor('#182431')
      .fontSize(16)
      .fontStyle(FontStyle.Italic)
      .fontWeight(FontWeight.Bold)
      .fontFamily('HarmonyOS Sans')
      .inputFilter('[0-9]', (filterValue: string) => {
      })
      .copyOption(CopyOptions.InApp)
      .style(TextInputStyle.Default)
      .textAlign(TextAlign.Center)
      .selectedBackgroundColor('#ff70a4db')
      .caretStyle({ width: 10, color: Color.Blue })
      .caretPosition(3)
      .showError('Error')
      .showUnderline(true)
      .enableKeyboardOnFocus(false)
      .selectionMenuHidden(true)
      .maxLines(2)
      .cancelButton({
        style: CancelButtonStyle.INPUT,
        icon: {
          size: 15,
          color: Color.Black,
          src: $r('app.media.icon')
        }
      })
      .selectAll(false)
      .showCounter(true, { thresholdPercentage: 2, highlightBorder: true })
      .underlineColor({
        normal: Color.Orange,
        typing: Color.Green,
        error: Color.Red,
        disable: Color.Gray
      })
      .lineHeight(25)
      .decoration({
        type: TextDecorationType.Underline,
        color: Color.Red,
        style: TextDecorationStyle.WAVY,
      })
      .letterSpacing(3)
      .fontFeature("\"ss01\" on")
      .wordBreak(WordBreak.NORMAL)
      .textOverflow(TextOverflow.None)
      .textIndent(10)
      .minFontSize(0)
      .maxFontSize(50)
      .lineBreakStrategy(LineBreakStrategy.GREEDY)
      .editMenuOptions({
        onCreateMenu: (menuItems: Array<TextMenuItem>) => {
          return null
        },
        onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
          return null
        }
      })
      .enablePreviewText(true)
      .size({ width: '80%' })
  }
}

@Entry
@Component
struct TestTextInputModifier {
  @State title: string = ''
  @State modifier1: MyModifier1 = new MyModifier1()
  @State modifier2: MyModifier2 = new MyModifier2()
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
            TextInput({ text: this.text })
              .attributeModifier(this.modifier1)
              .onChange((value: string) => {
                this.text = value;
              })

            TextInput({ text: this.text })
              .attributeModifier(this.modifier2)
              .onChange((value: string) => {
                this.text = value;
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