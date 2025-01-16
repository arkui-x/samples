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

import { Logger } from '../utils/Logger';
import { XcomponentNapiObject } from 'libxcomponent_napi.so'

@Entry
@Component
struct TestSurface {
  @State angleArray: Array<number> = new Array<number>();
  @State nativeContext: XcomponentNapiObject = null;
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.All });

  async aboutToAppear() {
    Logger.info('aboutToAppear');
    this.angleArray[0] = 30;
    this.angleArray[1] = 45;
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          Text($r('app.string.EntryAbility_desc'))
            .fontSize($r('app.float.head_font_24'))
            .lineHeight($r('app.float.wh_value_33'))
            .fontFamily('HarmonyHeiTi-Bold')
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_color_182431'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
            .margin({ top: $r('app.float.wh_value_13'), bottom: $r('app.float.wh_value_15') })
          Text('X:' + this.angleArray[0].toString()
            + '° ' + 'Y:' + this.angleArray[1].toString() + '°')
            .fontSize($r('app.float.head_font_24'))
            .lineHeight($r('app.float.wh_value_33'))
            .fontFamily('HarmonyHeiTi-Bold')
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_color_182431'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
            .margin({ top: $r('app.float.wh_value_13'), bottom: $r('app.float.wh_value_15') })
          Column() {
            XComponent({
              id: 'xcomponent_napi',
              type: 'surface',
              libraryname: 'xcomponent_napi',
            })
              .width($r('app.float.wh_value_360'))
              .height($r('app.float.wh_value_360'))
              .id('xComponent')
              .backgroundColor(Color.White)
              .onLoad((context: XcomponentNapiObject) => {
                Logger.info('onLoad');
                this.nativeContext = context;
              })
              .onDestroy(() => {
                Logger.info('onDestroy');
              })
          }
          .justifyContent(FlexAlign.SpaceAround)
          .alignItems(HorizontalAlign.Center)
          .gesture(
            PanGesture(this.panOption)
              .onActionStart(() => {
                Logger.info('Gesture onActionStart');
              })
              .onActionUpdate((event: GestureEvent) => {
                this.angleArray = this.nativeContext.updateAngle(event.offsetX, event.offsetY);
                Logger.info('Gesture onActionUpdate : offSet ' + event.offsetX + ',' + event.offsetY);
              })
              .onActionEnd(() => {
                Logger.info('Gesture onActionEnd');
              })
          )
        }
        .width('100%')
      }
      .scrollBar(BarState.Off)
    }
    .height('100%')
  }
}