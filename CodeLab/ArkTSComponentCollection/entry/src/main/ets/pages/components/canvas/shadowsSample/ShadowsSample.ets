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

import { TitleBar } from '../../../../common/TitleBar';

interface ShowBtnType {
  name: Resource,
  func: Function
}

@Extend(Text)
function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, top: 5 })
}

@Extend(Column)
function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .padding(15)
  .margin({ top: 5, bottom: 5 })
}

@Extend(Button)
function sampleButton() {
  .fontSize(20)
  .size({ width: '95%', height: 45 })
  .margin({ top: 15 })
}

@Entry
@Component
struct methodsSample {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private Btns: ShowBtnType[] = [
    {
      name: $r('app.string.canvas_shadowBlur'),
      func: () => {
        this.context.shadowBlur = 30;
        this.context.shadowColor = 'rgb(0,0,0)';
        this.context.fillStyle = 'rgb(255,0,0)';
        this.context.fillRect(20, 20, 100, 80);
      },
    },
    {
      name: $r('app.string.canvas_shadowColor'),
      func: () => {
        this.context.shadowBlur = 30;
        this.context.shadowColor = 'rgb(0,0,255)';
        this.context.fillStyle = 'rgb(255,0,0)';
        this.context.fillRect(160, 30, 100, 100);
      },
    },
    {
      name: $r('app.string.canvas_shadowOffsetX'),
      func: () => {
        this.context.shadowBlur = 10;
        this.context.shadowOffsetX = 20;
        this.context.shadowOffsetY = 0;
        this.context.shadowColor = 'rgb(0,0,0)';
        this.context.fillStyle = 'rgb(255,0,0)';
        this.context.fillRect(30, 70, 100, 80);
      },
    },
    {
      name: $r('app.string.canvas_shadowOffsetY'),
      func: () => {
        this.context.shadowBlur = 10;
        this.context.shadowOffsetX = 0;
        this.context.shadowOffsetY = 20;
        this.context.shadowColor = 'rgba(0, 95, 255, 1.00)';
        this.context.fillStyle = 'rgba(130, 255, 0, 1.00)';
        this.context.fillRect(140, 40, 100, 100);
      },
    },
  ];

  build() {
    Row() {
      Column() {
        TitleBar({ title: $r('app.string.canvas_component_shadow') })

        Text($r('app.string.canvas_canvasZone'))
          .leftTitleStyle()
        Column() {
          Canvas(this.context)
            .backgroundColor($r('app.color.canvas_background'))
            .width('100%')
            .height('100%')
        }
        .cardStyle()
        .size({ width: '100%', height: '30%' })

        Text($r('app.string.canvas_attributesOperations'))
          .leftTitleStyle();
        Column() {
          Scroll() {
            Column({ space: 2 }) {
              ForEach(this.Btns, (item: ShowBtnType) => {
                Button(item.name, { type: ButtonType.Capsule, stateEffect: true })
                  .sampleButton()
                  .onClick(() => {
                    item.func();
                  });
              });
            }
          }.scrollBar(BarState.Off)
        }
        .cardStyle()
        .size({ width: '100%', height: '40%' })

        Text($r('app.string.canvas_clearEffects'))
          .leftTitleStyle()
        Column() {
          Scroll() {
            Column() {
              Button($r('app.string.canvas_clearRect'))
                .fontSize(20)
                .size({ width: '95%', height: 45 })
                .onClick(() => {
                  this.context.restore();
                  this.context.fillRect(0, 0, this.context.width, this.context.height);
                  this.context.resetTransform();
                  this.context.clearRect(0, 0, this.context.width, this.context.height);
                })
            }
          }.scrollBar(BarState.Off)
        }
        .cardStyle()
        .size({ width: '100%', height: '15%' })
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor($r('app.color.background_light_gray'))
  }
}
