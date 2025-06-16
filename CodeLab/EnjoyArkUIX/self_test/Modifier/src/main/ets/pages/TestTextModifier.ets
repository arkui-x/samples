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
import { TextModifier } from '@ohos.arkui.modifier';
import { LengthMetrics } from '@kit.ArkUI';

const URI: string = '组件Text123！@#()+_'

class MyModifier extends TextModifier {
  applyNormalAttribute(instance: TextModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .textAlign(TextAlign.Center)
      .textOverflow({ 'overflow': TextOverflow.None })
      .maxLines(5)
      .lineHeight(25)
      .decoration({
        type: TextDecorationType.Underline,
        color: Color.Red,
        style: TextDecorationStyle.WAVY,
      })
      .baselineOffset(2)
      .letterSpacing(3)
      .minFontSize(0)
      .maxFontSize(50)
      .textCase(TextCase.Normal)
      .fontColor(Color.Black)
      .fontSize(15)
      .fontStyle(FontStyle.Italic)
      .fontWeight(FontWeight.Bold)
      .fontFamily('HarmonyOS Sans')
      .copyOption(CopyOptions.InApp)
      .draggable(true)
      .font({
        'size': 15,
        'weight': FontWeight.Bold,
        'family': 'HarmonyOS Sans',
        'style': FontStyle.Italic,
      })
      .textShadow({
        radius: 10,
        color: Color.Pink,
        offsetX: 5,
        offsetY: 5
      })
      .heightAdaptivePolicy(TextHeightAdaptivePolicy.MAX_LINES_FIRST)
      .textIndent(10)
      .wordBreak(WordBreak.NORMAL)
      .selection(0, 0)
      .fontFeature("\"ss01\" on")
      .lineSpacing(LengthMetrics.vp(4))
      .lineBreakStrategy(LineBreakStrategy.GREEDY)
      .textSelectable(TextSelectableMode.SELECTABLE_UNFOCUSABLE)
      .editMenuOptions({
        onCreateMenu: (menuItems: Array<TextMenuItem>) => {
          return null
        },
        onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
          return null
        }
      })
      .minFontScale(0.5)
      .maxFontScale(2)
      .halfLeading(true)
      .selectedBackgroundColor('#ff70a4db')
  }
}

@Entry
@Component
struct TestTextModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  @State value: string = URI
  @State decFlag: boolean = true
  @State index: number = 1

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
            Text(this.value)
              .attributeModifier(this.modifier as MyModifier)
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


      Column() {
        Scroll() {
          Column({ space: 2 }) {
            Counter() {
              Text(this.index.toString())
            }
            .width("60%")
            .height(30)
            .enableDec(this.decFlag)
            .onInc(() => {
              this.decFlag = true
              this.index++
              this.value += URI
            })
            .onDec(() => {
              this.index--
              if (this.value.startsWith(URI)) {
                this.value = this.value.substring(URI.length)
              }
              if (this.index == 0) {
                this.decFlag = false
              }
            })

            Row() {
            }.size({ width: '100%', height: 20 })
          }
        }.scrollBar(BarState.Off)
      }.size({ width: '100%', height: '40%' })
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}