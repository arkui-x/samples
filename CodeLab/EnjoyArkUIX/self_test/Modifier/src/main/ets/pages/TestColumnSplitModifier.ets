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

import { ColumnSplitModifier } from '@ohos.arkui.modifier';

class MyModifier extends ColumnSplitModifier {
  applyNormalAttribute(instance: ColumnSplitModifier): void {
    instance
      .divider({
        startMargin: 3,
        endMargin: 3
      })
      .borderWidth(1)
      .resizeable(true)
      .clip(true)
      .width('100%')
      .height('100%')
      .margin({ top: 10, bottom: 10 })
  }
}

@Entry
@Component
struct TestColumnSplitModifier {
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
      ColumnSplit() {
        Text('1').width('100%').height(50).backgroundColor(Color.Blue).textAlign(TextAlign.Center)
        Text('2').width('100%').height(50).backgroundColor(Color.Red).textAlign(TextAlign.Center)
        Text('3').width('100%').height(50).backgroundColor(Color.Yellow).textAlign(TextAlign.Center)
        Text('4').width('100%').height(50).backgroundColor(Color.Green).textAlign(TextAlign.Center)
        Text('5').width('100%').height(50).backgroundColor(Color.Pink).textAlign(TextAlign.Center)
      }.attributeModifier(this.modifier)
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}