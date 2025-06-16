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
import { SymbolGlyphModifier } from '@kit.ArkUI';

class MyModifier extends SymbolGlyphModifier {
  applyNormalAttribute(instance: SymbolGlyphModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .fontColor([Color.Black, Color.Red, Color.White])
      .fontSize(96)
      .fontWeight(FontWeight.Bold)
      .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
      .effectStrategy(SymbolEffectStrategy.HIERARCHICAL)
      .symbolEffect(new HierarchicalSymbolEffect(EffectFillStyle.ITERATIVE), true)
  }
}

@Entry
@Component
struct TestSymbolGlyphModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()

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
            SymbolGlyph($r('sys.symbol.ohos_folder_badge_plus'))
              .attributeModifier(this.modifier)
            SymbolGlyph($r('sys.symbol.ohos_wifi'))
              .attributeModifier(this.modifier)
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
