/*
 * Copyright (c) 2025 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { RouterModule } from 'RouterModule';

// 自执行函数，将builder注册到RouterModule中，在首次引用时触发
harInit();

export function harInit() {
  if (!RouterModule.getBuilder('HarA_Builder')) {
    let builder: WrappedBuilder<[Object]> = wrapBuilder(harBuilder);
    RouterModule.registerBuilder('HarA_Builder', builder);
  }
}

@Builder
export function harBuilder(values: Object) {
  NavDestination() {
    Column() {
      Button() {
        Text($r('app.string.navigation_router_har2'))
          .fontSize(16)
          .fontColor(Color.White)
      }
      .onClick(() => {
        RouterModule.push('HapA_Router', 'HarB_Builder');
      })
      .height(40)
      .width('88%')
      .backgroundColor('#007DFF')
      .borderRadius(20)
      .id('gotohar2')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
  .title('Har1')
}