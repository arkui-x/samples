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
import { CommonItemSelect } from '../component/CommonItemSelect'
import { VideoModifier } from '@ohos.arkui.modifier'

class MyModifier extends VideoModifier {
  applyNormalAttribute(instance: VideoModifier): void {
    super.applyNormalAttribute?.(instance)
    instance
      .autoPlay(true)
      .objectFit(ImageFit.Cover)
      .loop(true)
      .width('90%')
      .height(250)
  }

  setMuted(index: number): void {
    switch (index) {
      case 1:
        this.muted(true)
        break
      default:
        this.muted(false)
        break
    }
  }

  setControls(index: number): void {
    switch (index) {
      case 1:
        this.controls(true)
        break
      default:
        this.controls(false)
        break
    }
  }
}

@Entry
@Component
struct TestVideoModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  controller: VideoController = new VideoController()

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
            Video({
              src: $r('app.media.video_test'),
              currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X,
              controller: this.controller
            })
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

      Divider().size({ width: '100%', height: 3 }).backgroundColor(Color.Black).margin({ top: 20, bottom: 20 })

      Column() {
        Scroll() {
          Column({ space: 2 }) {
            CommonItemSelect({
              name: '静音',
              selects: ['不静音', '静音'],
              callback: (index) => {
                (this.modifier as MyModifier).setMuted(index)
              }
            })

            CommonItemSelect({
              name: '控制栏显示',
              selects: ['不显示', '显示'],
              callback: (index) => {
                (this.modifier as MyModifier).setControls(index)
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