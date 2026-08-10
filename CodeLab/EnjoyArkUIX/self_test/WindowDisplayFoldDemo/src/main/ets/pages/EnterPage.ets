/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
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

import { buttonSchemes } from '../common/TestData'
import deviceInfo from '@ohos.deviceInfo'
import common from '@ohos.app.ability.common'
import { display } from '@kit.ArkUI'

let context = getContext(this) as common.UIAbilityContext
const TAG: string = '[DisplayFold][EnterPage] '
const WAIT_READY_MS_100: number = 100

@Component
struct TestButtonItem {
  @State showDetail: boolean = false
  @State detailText: string = ''
  @Prop label: string = ''
  @Prop description: string = ''
  @Prop itemWidth: Length = 160
  @Prop bgColor: ResourceColor = '#f0f0f0'
  @Prop fontColor: ResourceColor = 'rgba(8, 8, 10, 1.00)'
  onRunTest: () => void = () => {
  }

  @Builder
  detailPopupBuilder() {
    Column() {
      Text(this.detailText)
        .fontSize(12)
        .fontColor('#e6e6e6')
        .lineHeight(20)
        .textAlign(TextAlign.Start)
    }
    .aspectRatio(10 / 3)
    .constraintSize({ minWidth: 80, maxWidth: 260 })
    .backgroundColor('#ff6e6d6d')
    .borderRadius(8)
    .shadow({ radius: 6, color: 'rgba(0,0,0,0.35)' })
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .hitTestBehavior(HitTestMode.Block)
    .padding(10)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Row() {
          Text(this.label)
            .fontSize(11)
            .layoutWeight(1)
            .fontColor(this.fontColor)
            .textAlign(TextAlign.Start)

          if (this.description !== '') {
            Column() {
              SymbolGlyph($r('sys.symbol.exclamationmark'))
                .fontSize(14)
            }
            .width(24)
            .height(24)
            .margin({ left: 4, right: 4 })
            .backgroundColor('#e8f8f7')
            .border({ width: 1, color: '#8fd6d0' })
            .borderRadius(18)
            .shadow({ radius: 3, color: 'rgba(0,0,0,0.12)' })
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.detailText = this.description
              this.showDetail = true
            })
            .bindPopup(this.showDetail, {
              builder: this.detailPopupBuilder,
              placement: Placement.Bottom,
              onStateChange: (event): void => {
                if (!event.isVisible) {
                  this.showDetail = false
                }
              }
            })
          }
        }
        .width('100%')
        .height('100%')
        .alignItems(VerticalAlign.Center)
        .padding({ left: 6, right: 6 })
        .onClick(() => {
          this.onRunTest()
        })
      }
      .width(this.itemWidth)
      .height(50)
      .borderRadius(8)
      .backgroundColor(this.bgColor)
      .border({ width: 1, color: 'rgba(0,0,0,0.15)' })
      .margin({
        left: 4,
        right: 4,
        top: 4,
        bottom: 4
      })
    }
  }
}

@Entry
@Component
struct EnterPage {
  @State info: string = ''
  @State isRunning: boolean = false
  private logIndex: number = 0
  private platform: string = ''
  private scrollerForLog: Scroller = new Scroller()

  aboutToAppear(): void {
    this.platform = deviceInfo.osFullName.split(' ')[0]
  }

  appendLog(msg: string): void {
    console.info(TAG + msg)
    this.logIndex++
    this.info = this.info + '[' + this.logIndex + '] ' + msg + '\n'
    if (this.info.length > 50000) {
      this.info = this.info.substring(0, 50000)
    }
    setTimeout(async () => {
      this.scrollerForLog.scrollEdge(Edge.Bottom)
    }, WAIT_READY_MS_100)
  }

  wrapTest(action: () => void): () => void {
    return () => {
      if (this.isRunning) {
        this.appendLog(' 测试执行中，请稍候...\n')
        return
      }
      this.isRunning = true
      this.info = ''
      this.logIndex = 0
      setTimeout(() => {
        try {
          action()
        } catch (e) {
          this.appendLog('❌ 执行异常: ' + JSON.stringify(e))
          this.appendLog('  ✗ FAIL')
        }
        this.isRunning = false
      }, 300)
    }
  }

  jsonFormat(data: string): string {
    try {
      let parsedData: Object = JSON.parse(data) as Object
      return JSON.stringify(parsedData, null, 2)
    } catch (error) {
      console.error(TAG + 'jsonFormat failed: ' + JSON.stringify(error))
      return data
    }
  }

  build() {
    Stack() {
      Row() {
        Column() {
          Row() {
          }
          .size({ width: '100%', height: 20 })

          Row() {
            Text('Display 测试')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
          }
          .size({ width: '95%', height: 40 })
          .margin({ top: 10 })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Row() {
            Text('系统: ' + this.platform)
              .fontSize(12)
              .fontColor(Color.Gray)
          }
          .width('96%').padding({ left: 5, right: 5 })
          .justifyContent(FlexAlign.SpaceBetween)

          Column() {
            Scroll(this.scrollerForLog) {
              Text(this.info.length > 0 ? this.info : '等待测试结果...')
                .fontSize(12)
                .width('100%')
                .textAlign(TextAlign.Start)
                .id('com.example.displayfold:id/ArkUIX_Display_EnterPage_Text_0100')
            }
            .scrollBar(BarState.Auto)
          }
          .size({ width: '95%', height: '20%' })
          .border({ width: 1, color: Color.Gray })
          .borderRadius(5)
          .padding(5)
          .margin({ top: 5 })

          Divider().size({ width: '100%', height: 2 }).backgroundColor(Color.Black).margin({ top: 8, bottom: 8 })

          Column() {
            Scroll() {
              Column({ space: 4 }) {
                Text('▌ Display.rotation 测试')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width('100%')
                  .margin({ top: 10 })
                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'Display.rotation',
                    description: '旋转手机，屏幕方向改变后，点击按钮获取值',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    itemWidth: 300,
                    onRunTest: this.wrapTest(() => {
                      try {
                        this.appendLog('用例开始：开始获取当前屏幕方向')
                        let displayClass: display.Display = display.getDefaultDisplaySync()
                        let rotation: number = displayClass.rotation
                        let res: boolean = (rotation === 0) || (rotation === 1) || (rotation === 2) || (rotation === 3)
                        this.appendLog('Display.rotation is ： ' + rotation)
                        this.appendLog(res ? '  ✓ PASS ' : '  ✗ FAIL ')
                        this.appendLog('用例结束')
                      } catch (error) {
                        this.appendLog('catch error for ' + JSON.stringify(error))
                      }
                    })
                  })
                    .id('com.example.displayfold:id/ArkUIX_Display_EnterPage_TestButtonItem_0100')
                }

                Text('▌ getFoldStatus 测试')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width('100%')
                  .margin({ top: 10 })
                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'getFoldStatus',
                    description: '折叠屏设备，改变设备折叠状态后，点击按钮获取值',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    itemWidth: 300,
                    onRunTest: this.wrapTest(() => {
                      try {
                        this.appendLog('用例开始：开始获取当前设备折叠状态')
                        let foldStatus: display.FoldStatus = display.getFoldStatus()
                        this.appendLog('foldStatus is ： ' + foldStatus)
                        let isValidFoldStatus: boolean = foldStatus === display.FoldStatus.FOLD_STATUS_UNKNOWN ||
                          foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED ||
                          foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED ||
                          foldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED
                        this.appendLog(isValidFoldStatus ? '  ✓ PASS' : '  ✗ FAIL')
                        this.appendLog('用例结束')
                      } catch (error) {
                        this.appendLog('catch error for ' + JSON.stringify(error))
                      }
                    })
                  })
                    .id('com.example.displayfold:id/ArkUIX_Display_EnterPage_TestButtonItem_0200')
                }

                Text('▌ getAllDisplays 测试')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width('100%')
                  .margin({ top: 10 })
                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'getAllDisplays_0100',
                    description: 'Callback 接口调用',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => {
                      try {
                        this.appendLog('Callback用例开始：开始获取当前设备的屏幕属性信息')
                        display.getAllDisplays((err: BusinessError, data: Array<display.Display>) => {
                          if (err && err.code !== 0) {
                            this.appendLog('getAllDisplays failed. Code: ' + err.code + ', message: ' + err.message)
                            return
                          }
                          this.appendLog('AllDisplays data is:\n' + this.jsonFormat(JSON.stringify(data)))
                          this.appendLog('  ✓ PASS')
                          this.appendLog('Callback用例结束')
                        })
                      } catch (error) {
                        this.appendLog('catch error for ' + JSON.stringify(error))
                        this.appendLog('  ✗ FAIL')
                      }
                    })
                  })
                    .id('com.example.displayfold:id/ArkUIX_Display_EnterPage_TestButtonItem_0300')
                  TestButtonItem({
                    label: 'getAllDisplays_0200',
                    description: 'Promise 接口调用',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(async () => {
                      try {
                        this.appendLog('Promise用例开始：开始获取当前设备的屏幕属性信息')
                        await display.getAllDisplays().then((data: Array<display.Display>) => {
                          this.appendLog('AllDisplays data is:\n' + this.jsonFormat(JSON.stringify(data)))
                          this.appendLog('  ✓ PASS')
                        }).catch((err: BusinessError) => {
                          this.appendLog('getAllDisplays failed. Code: ' + err.code + ', message: ' + err.message)
                          this.appendLog('  ✗ FAIL')
                        })
                        this.appendLog('Promise用例结束')
                      } catch (error) {
                        this.appendLog('catch error for ' + JSON.stringify(error))
                      }
                    })
                  })
                    .id('com.example.displayfold:id/ArkUIX_Display_EnterPage_TestButtonItem_0400')
                }

                Text('▌ getLiveCreaseRegion 测试')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width('100%')
                  .margin({ top: 10 })
                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'getLiveCreaseRegion',
                    description: '折叠屏设备，处于各种（折叠）状态下调用接口获取',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    itemWidth: 300,
                    onRunTest: this.wrapTest(() => {
                      try {
                        this.appendLog('用例开始：开始获取当前设备的实时折痕区域')
                        let liveCreaseRegion: display.FoldCreaseRegion =
                          display.getDefaultDisplaySync().getLiveCreaseRegion()
                        this.appendLog(
                          'liveCreaseRegion data is:\n' + this.jsonFormat(JSON.stringify(liveCreaseRegion)))
                        this.appendLog('  ✓ PASS')
                        this.appendLog('用例结束')
                      } catch (error) {
                        this.appendLog('catch error for ' + JSON.stringify(error))
                        this.appendLog('  ✗ FAIL')
                      }
                    })
                  })
                    .id('com.example.displayfold:id/ArkUIX_Display_EnterPage_TestButtonItem_0500')
                }
              }
              .width('100%').padding({ left: 10 })
            }
            .scrollBar(BarState.Auto)
          }
          .layoutWeight(1)

          Row() {
          }
          .size({ width: '100%', height: 10 })
        }
        .width('100%')
      }
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}
