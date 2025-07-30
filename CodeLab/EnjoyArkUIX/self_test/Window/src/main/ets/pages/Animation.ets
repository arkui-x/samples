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
import { TitleBar } from './TitleBar';

@Entry
@Component
struct BtnAlignExample {
  @State widthSize: number = 200;
  @State heightSize: number = 100;
  @State flag1: boolean = true;
  @State flag2: boolean = true;
  @State flag3: boolean = true;
  @State flag4: boolean = true;
  @State flag5: boolean = true;
  @State flag6: boolean = true;
  @State flag7: boolean = true;
  @State flag8: boolean = true;
  @State flag9: boolean = true;
  @State flag10: boolean = true;
  @State iconInfo: string = 'icon.png';
  @State colorInfo: string = "#FF8C00";
  @State colorInfo2: string = "#ffffffff";
  @State radiusV: number = 6;
  @State offsetV: number = 8;
  @State radiusV2: number = 6;
  @State offsetV2: number = 8;
  @State shadowColor: string = "#FF0033";
  @State radius: number = 0;
  @State fontSize: number = 20;
  @State shadowColor2: string = "#FF0033";
  @State radius2: number = 0;
  @State fontSize2: number = 20;
  @State fontWeight: FontWeight = FontWeight.Lighter;
  @State fontWeight2: FontWeight = FontWeight.Lighter;
  @State offsetY: number = 0;
  @State offsetY2: number = 0;

  build() {
    Row() {
      Column() {
        TitleBar({ title: $r('app.string.Animation_title') })
          .width('100%')
        Text('Button Animation').fontSize(20).fontColor('#182431')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 20 })
        Row() {
          Column() {
            Button('底板阴影(颜色)')
              .borderRadius(8)
              .width("80%")
              .height(50)
              .margin({ top: 10 })
              .shadow({ radius: 20, offsetX: 8, color: this.shadowColor })
              .onClick((event: ClickEvent) => {
                if (this.flag10) {
                  this.shadowColor = "#0000CD"
                } else {
                  this.shadowColor = "#FF0033"
                }
                this.flag10 = !this.flag10
              })
              .animation({
                duration: 3000, // 动画时长
                curve: Curve.Linear, // 动画曲线
                delay: 500, // 动画延迟
                iterations: 1, // 播放次数
                playMode: PlayMode.Normal, // 动画模式
              }) // 对Button组件的宽高属性进行动画配置
          }
          .width("50%")

          Column() {
            Button('底板阴影(距离)')
              .width("70%")
              .height(50)
              .margin({ top: 10 })
              .shadow({ radius: 20, offsetX: this.offsetV, color: "#fff8071b" })
              .onClick((event: ClickEvent) => {
                animateTo({
                  duration: 3000,
                  curve: Curve.EaseOut,
                  iterations: 1,
                  playMode: PlayMode.Normal,
                  onFinish: () => {
                    console.info('play end')
                  }
                }, () => {
                  if (this.flag7) {
                    this.offsetV = 30;
                  } else {
                    this.offsetV = 6;
                  }
                })
                this.flag7 = !this.flag7
              })
          }
          .width("50%")
        }
        .margin({ bottom: 20 })

        Row() {
          Column() {
            Button('底板阴影(角度)')
              .borderRadius(8)
              .width("90%")
              .height(50)
              .margin({ top: 10 })
              .shadow({ radius: 20, offsetX: 20, offsetY: this.offsetY, color: "#fff3001d" })
              .onClick((event: ClickEvent) => {
                if (this.flag8) {
                  this.offsetY = 20;
                } else {
                  this.offsetY = -20;
                }
                this.flag8 = !this.flag8
              })
              .animation({
                duration: 3000, // 动画时长
                curve: Curve.Linear, // 动画曲线
                delay: 500, // 动画延迟
                iterations: 1, // 播放次数
                playMode: PlayMode.Normal, // 动画模式
              }) // 对Button组件的宽高属性进行动画配置
          }
          .width("50%")
        }
        .margin({ bottom: 20 })

        Row() {
          Column() {
            Button('底板阴影(模糊值)')
              .borderRadius(8)
              .width("90%")
              .height(50)
              .margin({ top: 10 })
              .shadow({ radius: this.radiusV, offsetX: 6, color: "#ff0b1803" })
              .onClick((event: ClickEvent) => {
                if (this.flag4) {
                  this.radiusV = 30;
                } else {
                  this.radiusV = 8;
                }
                this.flag4 = !this.flag4
              })
              .animation({
                duration: 3000, // 动画时长
                curve: Curve.Linear, // 动画曲线
                delay: 500, // 动画延迟
                iterations: 1, // 播放次数
                playMode: PlayMode.Normal, // 动画模式
              }) // 对Button组件的宽高属性进行动画配置
          }
          .width("50%")

          Column() {
            Button({ type: ButtonType.Normal, stateEffect: true }) {
              Text('组合动效')
                .fontColor(this.colorInfo2)
                .fontWeight(this.fontWeight2).fontSize(this.fontSize2)
            }
            .shadow({ radius: this.radiusV2, offsetX: this.offsetV2, offsetY: this.offsetY2, color: this.shadowColor2 })
            .borderRadius(this.radius2)
            .width("90%")
            .height(50)
            .margin({ top: 10 })
            .onClick((event: ClickEvent) => {
              animateTo({
                duration: 2000,
                curve: Curve.EaseOut,
                iterations: 1,
                playMode: PlayMode.Normal,
                onFinish: () => {
                  console.info('play end')
                }
              }, () => {
                if (this.flag6) {
                  this.colorInfo2 = "#00CD00";
                  this.fontWeight2 = FontWeight.Bolder
                  this.fontSize2 = 40
                  this.offsetV2 = 10;
                  this.radiusV2 = 12;
                  this.offsetY2 = 20;
                  this.shadowColor2 = "#0000CD"
                  this.radius2 = 24
                } else {
                  this.offsetY2 = -20;
                  this.colorInfo2 = "#ffffffff";
                  this.fontWeight2 = FontWeight.Lighter
                  this.fontSize2 = 20
                  this.offsetV2 = 6;
                  this.radiusV2 = 8;
                  this.shadowColor2 = "#FF0033"
                  this.radius2 = 0
                }
              })
              this.flag6 = !this.flag6
            })
          }
          .width("50%")
        }
        .margin({ bottom: 20 })

        Row() {
          Column() {
          }


          Column() {
            Button() {
              Text('字体颜色').fontColor(this.colorInfo)
            }
            .borderRadius(8)
            .width("90%")
            .height(50)
            .margin({ top: 10 })
            .onClick((event: ClickEvent) => {
              if (this.flag1) {
                animateTo({
                  duration: 2000,
                  curve: Curve.EaseOut,
                  iterations: 1,
                  playMode: PlayMode.Normal,
                  onFinish: () => {
                    console.info('play end')
                  }
                }, () => {
                  this.colorInfo = "#00CD00";
                })
              } else {
                animateTo({
                  duration: 2000,
                  curve: Curve.EaseOut,
                  iterations: 1,
                  playMode: PlayMode.Normal,
                  onFinish: () => {
                    console.info('play end')
                  }
                }, () => {
                  this.colorInfo = "#FF8C00";
                })
              }
              this.flag1 = !this.flag1
            })
          }
          .width("50%")
        }
        .margin({ bottom: 15 })

        Row() {
          Column() {
            Button() {
              Text('字体字重').fontWeight(this.fontWeight)
                .fontSize(20)
            }
            .borderRadius(8)
            .width("90%")
            .height(50)
            .margin({ top: 10 })
            .onClick((event: ClickEvent) => {
              if (this.flag2) {
                animateTo({
                  duration: 2000,
                  curve: Curve.EaseOut,
                  iterations: 1,
                  playMode: PlayMode.Normal,
                  onFinish: () => {
                    console.info('play end')
                  }
                }, () => {
                  this.fontWeight = FontWeight.Bolder
                })
              } else {
                animateTo({
                  duration: 2000,
                  curve: Curve.EaseOut,
                  iterations: 1,
                  playMode: PlayMode.Normal,
                  onFinish: () => {
                    console.info('play end')
                  }
                }, () => {
                  this.fontWeight = FontWeight.Lighter
                })
              }
              this.flag2 = !this.flag2
            })
          }
          .width("50%")

          Column() {
            Button("clean and back")
              .margin({ top: 20 })
              .height(50)
              .width("100")
              .onClick(() => {
                this.colorInfo = "#FF8C00";
                this.fontWeight = FontWeight.Lighter
                this.fontSize = 20
                this.offsetV = 6;
                this.radiusV = 8;
                this.shadowColor = "#FF0033"
                this.radius = 0
                this.offsetY = 0
                this.offsetY2 = 0
                this.colorInfo2 = "#ffffffff";
                this.fontWeight2 = FontWeight.Lighter
                this.fontSize2 = 20
                this.offsetV2 = 6;
                this.radiusV2 = 8;
                this.shadowColor2 = "#FF0033"
                this.radius2 = 0
                this.flag1 = true
                this.flag2 = true
                this.flag3 = true
                this.flag4 = true
                this.flag5 = true
                this.flag6 = true
                this.flag7 = true
                this.flag8 = true
                this.flag9 = true
                this.flag10 = true
                router.pushUrl({ url: 'pages/EnterPage' })
              })
          }
          .width("50%")
        }

        Button() {
          Text('字体大小').fontSize(this.fontSize)
        }
        .borderRadius(8)
        .width("90%")
        .height(200)
        .margin({ top: 10 })
        .onClick((event: ClickEvent) => {
          if (this.flag3) {
            animateTo({
              duration: 2000,
              curve: Curve.Linear,
              iterations: 1,
              playMode: PlayMode.Normal,
              onFinish: () => {
                console.info('play end')
              }
            }, () => {
              this.fontSize = 50
            })
          } else {
            animateTo({
              duration: 2000,
              curve: Curve.Linear,
              iterations: 1,
              playMode: PlayMode.Normal,
              onFinish: () => {
                console.info('play end')
              }
            }, () => {
              this.fontSize = 20
            })
          }
          this.flag3 = !this.flag3
        })

      }.width('100%')
    }.height('100%')
  }
}