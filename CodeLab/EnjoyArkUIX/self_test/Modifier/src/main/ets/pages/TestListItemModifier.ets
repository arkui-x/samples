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
import { ListItemModifier } from '@ohos.arkui.modifier';

class MyModifier extends ListItemModifier {
  applyNormalAttribute(instance: ListItemModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .selectable(true)
      .selected(true)
      .transition({ type: TransitionType.Delete, opacity: 0 })
  }
}

@Entry
@Component
struct TestListItemModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  @State arr: number[] = [0, 1, 2, 3, 4]
  @State enterEndDeleteAreaString: string = "not enterEndDeleteArea"
  @State exitEndDeleteAreaString: string = "not exitEndDeleteArea"

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })


      List({ space: 10 }) {
        ForEach(this.arr, (item: number) => {
          if (item === 0) {
            ListItem() {
              Text("item" + item)
                .width('100%')
                .height(100)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .borderRadius(10)
                .backgroundColor(0xFFFFFF)
            }
            .attributeModifier(this.modifier)
          } else {
            ListItem() {
              Text("item" + item)
                .width('100%')
                .height(100)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .borderRadius(10)
                .backgroundColor(0xFFFFFF)
            }
          }
        }, (item: string) => item)
      }
      .size({ width: '98%', height: '80%' })
      .contentStartOffset(10)
      .contentEndOffset(10)
      .margin({ top: 10, bottom: 10 })
      .borderRadius(10)
      .backgroundColor(0xDCDCDC)
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}