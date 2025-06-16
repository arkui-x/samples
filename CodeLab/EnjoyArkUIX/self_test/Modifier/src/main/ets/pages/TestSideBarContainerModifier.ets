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
import { SideBarContainerModifier } from '@ohos.arkui.modifier';

class MyModifier extends SideBarContainerModifier {
  applyNormalAttribute(instance: SideBarContainerModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .showSideBar(true)
      .controlButton({
        icons: {
          hidden: $r('app.media.icon'),
          shown: $r('app.media.icon'),
          switching: $r('app.media.icon')
        }
      })
      .showControlButton(true)
      .sideBarWidth(150)
      .minSideBarWidth(50)
      .maxSideBarWidth(300)
      .autoHide(false)
      .sideBarPosition(SideBarPosition.End)
      .divider({
        strokeWidth: '1vp',
        color: Color.Gray,
        startMargin: '4vp',
        endMargin: '4vp'
      })
      .minContentWidth(1)
      .size({ width: '90%', height: '80%' })
      .margin({ top: 10, bottom: 10 })
  }
}

@Entry
@Component
struct TestSideBarContainerModifier {
  @State title: string = ''
  @State arr: number[] = [1, 2, 3]
  @State current: number = 1
  @State modifier: MyModifier = new MyModifier()

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })

      SideBarContainer(SideBarContainerType.Embed) {
        Column() {
          ForEach(this.arr, (item: number) => {
            Column({ space: 5 }) {
              Image(this.current === item ? $r("app.media.my_image") : $r("app.media.icon"))
                .width(64)
                .height(64)
              Text("Index0" + item)
                .fontSize(25)
                .fontColor(this.current === item ? '#0A59F7' : '#999')
                .fontFamily('source-sans-pro,cursive,sans-serif')
            }
            .onClick(() => {
              this.current = item
            })
          }, (item: string) => item)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .backgroundColor('#19000000')

        Column() {
          Text('SideBarContainer子组件').fontSize(25)
        }
        .margin({ top: 100, left: 20, right: 30 })
      }
      .attributeModifier(this.modifier)
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}