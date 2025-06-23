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
import { ImageAnimatorModifier } from '@ohos.arkui.modifier';

class MyModifier extends ImageAnimatorModifier {
  applyNormalAttribute(instance: ImageAnimatorModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .images([
        {
          src: $r('app.media.image_animator_1')
        },
        {
          src: $r('app.media.image_animator_2')
        },
        {
          src: $r('app.media.image_animator_3')
        },
        {
          src: $r('app.media.image_animator_4')
        },
        {
          src: $r('app.media.image_animator_5')
        },
        {
          src: $r('app.media.image_animator_6')
        },
        {
          src: $r('app.media.image_animator_7')
        },
        {
          src: $r('app.media.image_animator_8')
        },
        {
          src: $r('app.media.image_animator_9')
        },
        {
          src: $r('app.media.image_animator_10')
        }
      ])
      .state(AnimationStatus.Running)
      .duration(2000)
      .reverse(true)
      .fixedSize(true)
      .fillMode(FillMode.None)
      .iterations(-1)
      .width(340)
      .height(240)
  }
}

@Entry
@Component
struct TestImageAnimatorModifier {
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
            ImageAnimator()
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
