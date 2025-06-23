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
import { AlphabetIndexerModifier } from '@ohos.arkui.modifier'

class MyModifier extends AlphabetIndexerModifier {
  applyNormalAttribute(instance: AlphabetIndexerModifier): void {
    instance
      .color(Color.Red)
      .selectedColor(Color.Green)// 选中项文本颜色
      .selectedBackgroundColor(Color.Pink)// 选中项背景颜色
      .popupColor(Color.Gray)// 弹出框文本颜色
      .popupBackground(0xD2B48C)// 弹出框背景颜色
      .usingPopup(true)// 是否显示弹出框
      .selectedFont({ size: 15, weight: FontWeight.Bold })// 选中项字体样式
      .popupFont({ size: 30, weight: FontWeight.Bolder })// 弹出框内容的字体样式
      .font({ size: 9, weight: FontWeight.Regular })
      .itemSize(50)// 每一项的尺寸大小
      .alignStyle(IndexerAlign.Left)// 弹出框在索引条右侧弹出
      .selected(3)
      .popupPosition({ x: 0, y: 0 })
      .popupSelectedColor(0x00FF00)
      .popupUnselectedColor(0x0000FF)
      .popupItemFont({ size: 30, style: FontStyle.Normal })
      .popupItemBackgroundColor(0xCCCCCC)
      .autoCollapse(true)// 开启或关闭自适应折叠模式
      .popupItemBorderRadius(20)
      .itemBorderRadius(15)
      .popupBackgroundBlurStyle(BlurStyle.Thick)
      .popupTitleBackground(Color.Orange)

    instance
      .height('80%')
  }
}

@Entry
@Component
struct TestAlphabetIndexerModifier {
  @State title: string = ''
  @State myModifier: AlphabetIndexerModifier = new MyModifier()
  value: string[] = ['#', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
    'H', 'I', 'J', 'K', 'L', 'M', 'N',
    'O', 'P', 'Q', 'R', 'S', 'T', 'U',
    'V', 'W', 'X', 'Y', 'Z'];
  arrayA: string[] = ['爱', '安', '按', '暗', '岸', '案', '昂', '熬', '傲', '奥']

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
            AlphabetIndexer({ arrayValue: this.value, selected: 0 })
              .attributeModifier(this.myModifier)
              .margin({
                top: 20,
                left: 20,
                right: 20,
                bottom: 20
              })
              .onRequestPopupData((index: number) => {
                if (this.value[index] == 'A') {
                  return this.arrayA;
                } else {
                  return [];
                }
              })
          }.width('100%')
        }.scrollBar(BarState.Off)
      }
      .backgroundColor('#ffa2a0a0')
      .size({ width: '98%', height: '80%' })
      .border({
        width: 3,
        color: Color.Pink,
        radius: 30,
        style: BorderStyle.Solid
      })
      .margin({ top: 10, bottom: 10 })

    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}