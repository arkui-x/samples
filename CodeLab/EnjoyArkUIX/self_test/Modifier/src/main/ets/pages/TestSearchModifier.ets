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

import router from '@ohos.router'
import { TitleBar } from '../component/TitleBar'
import Logger from '../utils/Logger'
import { SearchModifier } from '@ohos.arkui.modifier';

class MyModifier extends SearchModifier {
  applyNormalAttribute(instance: SearchModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .searchButton('搜索', { fontSize: 14, fontColor: Color.Red })
      .placeholderColor(Color.Green)
      .placeholderFont({ size: 14, weight: 400 })
      .textFont({ size: 14, weight: 400 })
      .textAlign(TextAlign.Center)
      .copyOption(CopyOptions.None)
      .searchIcon({
        src: $r('app.media.icon'),
        size: 30
      })
      .cancelButton({
        style: CancelButtonStyle.CONSTANT,
        icon: {
          src: $r('app.media.icon'),
          size: 30
        }
      })
      .fontColor(Color.Orange)
      .caretStyle({ width: 3, color: Color.Black })
      .enableKeyboardOnFocus(false)
      .selectionMenuHidden(true)
      .type(SearchType.NORMAL)
      // .maxLength(7)
      .enterKeyType(EnterKeyType.Search)
      .lineHeight(16)
      .decoration({ type: TextDecorationType.LineThrough, color: Color.Red })
      .letterSpacing(5)
      .fontFeature("\"ss01\" on")
      .selectedBackgroundColor(Color.Gray)
      .inputFilter('[0-9]', (filterValue: string) => {
      })
      .textIndent(3)
      .minFontSize(1)
      .maxFontSize(50)
      .editMenuOptions({
        onCreateMenu: (menuItems: Array<TextMenuItem>) => {
          return null
        },
        onMenuItemClick: (menuItem: TextMenuItem, textRange: TextRange) => {
          return null
        }
      })
    instance
      .margin(10)
      .border({ width: 1 })
      .height(60)
  }
}

@Entry
@Component
struct TestSearchModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  controller: SearchController = new SearchController()
  @State inputValue: string = ""
  @State height1: string | number = '80%'
  @State supportAvoidance: boolean = true

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
            Search({ controller: this.controller, value: this.inputValue })
              .attributeModifier(this.modifier)
              .onChange((value: string) => {
                this.inputValue = value
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