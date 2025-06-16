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
import { ImageModifier, matrix4 } from "@kit.ArkUI"

class MyModifier1 extends ImageModifier {
  applyNormalAttribute(instance: ImageModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .alt($r('app.media.app_icon'))
      .imageMatrix(
        matrix4.identity()
          .translate({ x: -400, y: -750 })
          .scale({ x: 0.5, y: 0.5 })
          .rotate({
            x: 2,
            y: 0.5,
            z: 3,
            centerX: 10,
            centerY: 10,
            angle: -10
          })
      )
      .interpolation(ImageInterpolation.High)
      .fitOriginalSize(true)
      .autoResize(true)
      .syncLoad(true)
      .copyOption(CopyOptions.None)
    instance
      .size({ width: 110, height: 110 })
      .border({ width: 1 })
      .margin({ right: 10 })
      .size({ width: 110, height: 110 })
  }

  public setObjectFit(index: number): void {
    switch (index) {
      case 1:
        this.objectFit(ImageFit.Cover)
        break
      case 2:
        this.objectFit(ImageFit.Contain)
        break
      case 3:
        this.objectFit(ImageFit.Fill)
        break
      case 4:
        this.objectFit(ImageFit.ScaleDown)
        break
      case 5:
        this.objectFit(ImageFit.Auto)
        break
      default:
        this.objectFit(ImageFit.None)
        break
    }
  }

  public setRenderMode(index: number): void {
    switch (index) {
      case 1:
        this.renderMode(ImageRenderMode.Template)
        break
      default:
        this.renderMode(ImageRenderMode.Original)
    }
  }
}

class MyModifier2 extends ImageModifier {
  applyNormalAttribute(instance: ImageModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .size({ width: 110, height: 110 })
      .border({ width: 1 })
      .objectFit(ImageFit.ScaleDown)
  }

  public setObjectRepeat(index: number): void {
    switch (index) {
      case 1:
        this.objectRepeat(ImageRepeat.X)
        break
      case 2:
        this.objectRepeat(ImageRepeat.Y)
        break
      case 3:
        this.objectRepeat(ImageRepeat.XY)
        break
      default:
        this.objectRepeat(ImageRepeat.NoRepeat)
        break
    }
  }
}

class MyModifier3 extends ImageModifier {
  applyNormalAttribute(instance: ImageModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .sourceSize({ height: 110, width: 110 })
      .matchTextDirection(true)
      .resizable({
        slice: {
          left: 10,
          right: 10,
          top: 10,
          bottom: 10
        }
      })
    instance
      .size({ width: 110, height: 110 })
      .border({ width: 1 })
      .margin({ right: 10 })
  }
}

class MyModifier4 extends ImageModifier {
  applyNormalAttribute(instance: ImageModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .colorFilter(
        new ColorFilter([0.5, 0, 0.5, 0, 0,
          0, 0.5, 0.5, 0, 0,
          0.5, 0, 0.5, 0, 0,
          0, 0, 0.5, 0, 0])
      )
    instance
      .size({ width: 110, height: 110 })
      .border({ width: 1 })
  }

  public setFillColor(index: number): void {
    switch (index) {
      case 1:
        this.fillColor(Color.Blue)
        break
      case 2:
        this.fillColor(Color.Green)
        break
      case 3:
        this.fillColor(Color.Orange)
        break
      default:
        this.fillColor(Color.Pink)
        break
    }
  }
}

@Entry
@Component
struct TestImageModifier {
  @State title: string = ''
  @State modifier1: ImageModifier = new MyModifier1()
  @State modifier2: ImageModifier = new MyModifier2()
  @State modifier3: ImageModifier = new MyModifier3()
  @State modifier4: ImageModifier = new MyModifier4()
  @State imageHeight: number = 110;
  @State imageWidth: number = 110;
  @State objectFit: ImageFit = ImageFit.None;
  @State RenderMode: ImageRenderMode = ImageRenderMode.Original;
  @State RepeatMode: ImageRepeat = ImageRepeat.NoRepeat;

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
            Row() {
              Image($r('app.media.test_image'))
                .attributeModifier(this.modifier1 as MyModifier1)
              Image($r('app.media.ic_unselect_universal'))
                .attributeModifier(this.modifier2 as MyModifier2)
            }
            .margin({ bottom: 5 })

            Row() {
              Image($r('app.media.icon'))
                .attributeModifier(this.modifier3 as MyModifier3)
              Image($r('app.media.img_love'))
                .attributeModifier(this.modifier4 as MyModifier4)
            }
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
              name: 'objectFit',
              selects: ['None', 'Cover', 'Contain', 'Fill', 'ScaleDown', 'Auto'],
              callback: (index) => {
                (this.modifier1 as MyModifier1).setObjectFit(index)
              }
            })

            CommonItemSelect({
              name: 'objectRepeat',
              selects: ['NoRepeat', 'X', 'Y', 'XY'],
              callback: (index) => {
                (this.modifier2 as MyModifier2).setObjectRepeat(index)
              }
            })

            CommonItemSelect({
              name: 'renderMode',
              selects: ['Original', 'Template'],
              callback: (index) => {
                (this.modifier1 as MyModifier1).setRenderMode(index)
              }
            })

            CommonItemSelect({
              name: 'fillColor',
              selects: ['Pink', 'Blue', 'Green', 'Orange'],
              callback: (index) => {
                (this.modifier4 as MyModifier4).setFillColor(index)
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