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
import { LineModifier } from '@ohos.arkui.modifier';

class MyModifier extends LineModifier {
  applyNormalAttribute(instance: LineModifier): void {
    super.applyNormalAttribute?.(instance)
    instance
      .startPoint([30, 50])
      .endPoint([150, 250])
      .fill(Color.Black)
      .fillOpacity(0.5)
      .stroke(Color.Blue)
      .strokeDashArray([1, 2, 3])
      .strokeDashOffset(10)
      .strokeLineCap(LineCapStyle.Round)
      .strokeLineJoin(LineJoinStyle.Bevel)
      .strokeMiterLimit(5)
      .strokeOpacity(0.5)
      .strokeWidth(10)
      .antiAlias(true)
  }
}

@Entry
@Component
struct TestLineModifier {
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
          Line()
            .attributeModifier(this.modifier)
            .size({ width: '90%', height: '90%' })
        }.scrollBar(BarState.Off)
      }
      .size({ width: '98%', height: '80%' })
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