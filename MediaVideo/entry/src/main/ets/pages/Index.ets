/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import media from '@ohos.multimedia.media';
import { BusinessError } from '@ohos.base'
import common from '@ohos.app.ability.common';

@Entry
@Component
struct MediaVideo {
  @State flag1: boolean = true;
  @State flag2: boolean = false;
  @State flag3: boolean = false;
  @State flag4: boolean = false;
  avPlayer?: media.AVPlayer;
  surfaceId: string = '';
  private xComponentController: XComponentController = new XComponentController();

  checkNull(): boolean {
    if (this.avPlayer == undefined) {
      console.log('Invalid operation, please create AVPlayer')
      return true
    }
    return false;
  }

  async setFdSrc() {
    if (this.checkNull()) {
      return
    }
    try {
      let context = getContext(this) as common.UIAbilityContext;
      let fileDescriptor = await context.resourceManager.getRawFd('test1.mp4');
      let fileFd: number = JSON.parse(JSON.stringify(fileDescriptor))['fd']
      let fileOffset: number = JSON.parse(JSON.stringify(fileDescriptor))['offset']
      let avFileDescriptor: media.AVFileDescriptor =
        { fd: fileFd, offset: fileOffset, length: -1 };
      this.avPlayer!.fdSrc = avFileDescriptor;
    } catch (err) {
    }
  }

  async CreateAVPlayer() {
    try {
      this.flag1 = false
      this.flag2 = false
      this.flag3 = false
      this.flag4 = false
      this.avPlayer = await media.createAVPlayer()
      console.info('CreateAVPlayer success')
      setTimeout(async () => {
        if (!this.checkNull()) {
          try {
            let context = getContext(this) as common.UIAbilityContext;
            let fileDescriptor = await context.resourceManager.getRawFd('test.mp4');
            let fileFd: number = JSON.parse(JSON.stringify(fileDescriptor))['fd']
            let fileOffset: number = JSON.parse(JSON.stringify(fileDescriptor))['offset']
            let avFileDescriptor: media.AVFileDescriptor =
              { fd: fileFd, offset: fileOffset, length: -1 };
            this.avPlayer!.fdSrc = avFileDescriptor;
            setTimeout(() => {
              this.flag1 = false
              this.flag2 = true
              this.flag3 = false
              this.flag4 = false
            }, 500)
          } catch (err) {
            console.info('Set Url failed : ' + JSON.stringify(err))
          }
        }
      }, 500)
    } catch (err) {
      console.info('CreateAVPlayer failed : ' + JSON.stringify(err))
    }
  }

  SetSurfaceId() {
    if (this.checkNull()) {
      return
    }
    try {
      this.flag1 = false
      this.flag2 = false
      this.flag3 = false
      this.flag4 = false
      this.avPlayer!.surfaceId = this.surfaceId
      setTimeout(() => {
        if (!this.checkNull()) {
          this.avPlayer!.prepare().then(() => {
            console.info('Prepare success')
            setTimeout(() => {
              this.flag1 = false
              this.flag2 = false
              this.flag3 = true
              this.flag4 = false
            }, 500)
          }).catch((err: BusinessError) => {
            console.info('Prepare failed : ' + JSON.stringify(err))
          })
        }
      }, 500)
      console.info('Set SurfaceId success ,SurfaceId : ' + JSON.stringify(this.avPlayer!.surfaceId))
    } catch (err) {
      console.info('Set SurfaceId failed : ' + JSON.stringify(err))
    }
  }

  Play() {
    if (this.checkNull()) {
      return
    }
    this.flag1 = false
    this.flag2 = false
    this.flag3 = false
    this.flag4 = false
    this.avPlayer!.play().then(() => {
      this.flag1 = false
      this.flag2 = false
      this.flag3 = false
      this.flag4 = true
      console.info('Play success')
    }).catch((err: BusinessError) => {
      console.info('Play failed : ' + JSON.stringify(err))
    })
  }

  Release() {
    if (this.checkNull()) {
      return
    }
    this.flag1 = false
    this.flag2 = false
    this.flag3 = false
    this.flag4 = false
    this.avPlayer!.release().then(() => {
      console.info('Release success')
      setTimeout(() => {
        this.flag1 = true
        this.flag2 = false
        this.flag3 = false
        this.flag4 = false
      }, 500)
    }).catch((err: BusinessError) => {
      console.info('Release failed : ' + JSON.stringify(err))
    })
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          Text('MediaVideo')
            .fontSize($r('app.float.textFont'))
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: $r('app.float.marginData') })

          XComponent({
            id: 'xComponent',
            type: 'surface',
            controller: this.xComponentController
          }).onLoad(() => {
            this.surfaceId = this.xComponentController.getXComponentSurfaceId()
          })
            .size({ width: $r('app.float.xComponentWidth'), height: $r('app.float.xComponentHeight') })
            .margin({ bottom: $r('app.float.marginData') })

          Button($r('app.string.buttonText1'))
            .width('80%')
            .height($r('app.float.buttonHeightData'))
            .margin({ bottom: $r('app.float.marginData') })
            .enabled(this.flag1)
            .onClick(() => {
              this.CreateAVPlayer();
            })

          Button($r('app.string.buttonText2'))
            .width('80%')
            .height($r('app.float.buttonHeightData'))
            .margin({ bottom: $r('app.float.marginData') })
            .enabled(this.flag2)
            .onClick(() => {
              this.SetSurfaceId();
            })

          Button($r('app.string.buttonText3'))
            .width('80%')
            .height($r('app.float.buttonHeightData'))
            .margin({ bottom: $r('app.float.marginData') })
            .enabled(this.flag3)
            .onClick(() => {
              this.Play();
            })

          Button($r('app.string.buttonText4'))
            .width('80%')
            .height($r('app.float.buttonHeightData'))
            .margin({ bottom: $r('app.float.marginData') })
            .enabled(this.flag4)
            .onClick(() => {
              this.Release();
            })

        }
        .width('100%')
      }.scrollBar(BarState.Off)
    }
    .height('100%')
  }
}