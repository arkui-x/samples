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

import storageStatistics from '@ohos.file.storageStatistics'
import fileIo from '@ohos.file.fs'
import { BusinessError } from '@ohos.base'
import { common } from '@kit.AbilityKit'

const TAG: string = '[FileStorageStatistics][EnterPage] '

@Entry
@Component
struct EnterPage {
  @State logs: string = ''
  @State logIndex: number = 0

  isNum(val: number): boolean {
    return typeof val === 'number' && isFinite(val)
  }

  isNegativeNum(val: number): boolean {
    return val < 0
  }

  addLog(msg: string) {
    this.logIndex++
    let logMsg = `【${this.logIndex}】 ${msg}`
    this.logs += logMsg + '\n'
    console.info(TAG + logMsg)
  }

  createCacheFile(): boolean {
    try {
      let context = getContext(this) as common.UIAbilityContext
      let cacheFile: string = context.cacheDir + '/cache.txt'
      if (fileIo.accessSync(cacheFile)) {
        fileIo.unlinkSync(cacheFile)
      }
      let file = fileIo.openSync(cacheFile, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY)
      try {
        fileIo.writeSync(file.fd, 'a'.repeat(5000))
      }finally {
        fileIo.closeSync(file)
      }
      this.addLog('cache.txt 创建成功 (5000byte)')
      return true
    } catch (e) {
      this.addLog('cache.txt 创建失败: ' + JSON.stringify(e))
      this.addLog('用例停止' + JSON.stringify(e))
      return false
    }
  }

  formatBytes(bytes: number): string {
    const KB = 1000
    const MB = KB * 1000
    const GB = MB * 1000
    if (bytes >= GB) {
      return (bytes / GB).toFixed(2) + ' GB'
    }
    if (bytes >= MB) {
      return (bytes / MB).toFixed(2) + ' MB'
    }
    return (bytes / KB).toFixed(2) + ' KB'
  }

  build() {
    Column() {
      Row() {
      }.size({ width: '100%', height: 20 })
      .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Row_0010')

      Row() {
        Text('FileStorageStatistics')
          .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Text_0010')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
      }
      .size({ width: '95%', height: 40 })
      .margin({ top: 10 })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Row_0020')

      Column() {
        Scroll() {
          Column() {
            Text(this.logs === '' ? '等待测试结果...' : this.logs)
              .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Text_0020')
              .fontSize(12)
              .width('100%')
              .textAlign(TextAlign.Start)
          }
          .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Column_0030')
        }
        .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Scroll_0010')
        .scrollBar(BarState.Off)
      }
      .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Column_0020')
      .size({ width: '95%', height: '20%' })
      .border({ width: 1, color: Color.Gray })
      .borderRadius(5)
      .padding(5)
      .margin({ top: 5 })

      Divider()
        .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Divider_0010')
        .size({ width: '100%', height: 2 })
        .backgroundColor(Color.Black)
        .margin({ top: 8, bottom: 8 })

      Column() {
        Column() {
          Text('getCurrentBundleStats')
            .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Text_0030')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Black)
            .width('100%')
            .textAlign(TextAlign.Start)
            .backgroundColor('#0EA5E9')
            .borderRadius({ topLeft: 10, topRight: 10 })
            .padding({
              left: 8,
              top: 8,
              bottom: 12,
              right: 8
            })
            .margin({ bottom: 10 })
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
            Button('Promise')
              .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Button_0010')
              .fontSize(14)
              .height(36)
              .borderRadius(18)
              .backgroundColor('#38BDF8')
              .fontColor(Color.Black)
              .margin({ right: 8, bottom: 8 })
              .padding({ left: 16, right: 16 })
              .onClick(() => {
                this.logs = ''
                this.logIndex = 0
                setTimeout(async () => {
                  this.addLog('INFO getCurrentBundleStats_0100 开始')
                  if (this.createCacheFile()) {
                    try {
                      let bundleStat: storageStatistics.BundleStats = await storageStatistics.getCurrentBundleStats()
                      this.addLog(`appSize: ${bundleStat.appSize} byte（约${this.formatBytes(bundleStat.appSize)}）`)
                      this.addLog(`cacheSize: ${bundleStat.cacheSize} byte（约${this.formatBytes(bundleStat.cacheSize)}）`)
                      this.addLog(`dataSize: ${bundleStat.dataSize} byte（约${this.formatBytes(bundleStat.dataSize)}）`)
                      let pass = bundleStat != null &&
                      this.isNum(bundleStat.appSize) && !this.isNegativeNum(bundleStat.appSize) &&
                      this.isNum(bundleStat.cacheSize) && !this.isNegativeNum(bundleStat.cacheSize) &&
                      this.isNum(bundleStat.dataSize) && !this.isNegativeNum(bundleStat.dataSize)
                      if (pass) {
                        this.addLog('✓ PASS ')
                      } else {
                        this.addLog(`✗ FAIL 断言失败: ${JSON.stringify(bundleStat)}`)
                      }
                    } catch (e) {
                      this.addLog(`✗ FAIL 异常: ${JSON.stringify(e)}`)
                    }
                  }
                  this.addLog('INFO getCurrentBundleStats_0100 结束')
                }, 300)
              })
            Button('Callback')
              .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Button_0020')
              .fontSize(14)
              .height(36)
              .borderRadius(18)
              .backgroundColor('#38BDF8')
              .fontColor(Color.Black)
              .margin({ right: 8, bottom: 8 })
              .padding({ left: 16, right: 16 })
              .onClick(() => {
                this.logs = ''
                this.logIndex = 0
                setTimeout(() => {
                  this.addLog('INFO getCurrentBundleStats_0200 开始')
                  if (this.createCacheFile()) {
                    try {
                      storageStatistics.getCurrentBundleStats((error: BusinessError,
                                                               bundleStat: storageStatistics.BundleStats) => {
                        if (error && error.code !== 0) {
                          this.addLog(`✗ FAIL error: ${JSON.stringify(error)}`)
                          this.addLog('INFO getCurrentBundleStats_0200 结束')
                          return
                        }
                        if (bundleStat == null) {
                          this.addLog('✗ FAIL bundleStat is null')
                          this.addLog('INFO getCurrentBundleStats_0200 结束')
                          return
                        }
                        this.addLog(`appSize: ${bundleStat.appSize} byte（约${this.formatBytes(bundleStat.appSize)}）`)
                        this.addLog(`cacheSize: ${bundleStat.cacheSize} byte（约${this.formatBytes(bundleStat.cacheSize)}）`)
                        this.addLog(`dataSize: ${bundleStat.dataSize} byte（约${this.formatBytes(bundleStat.dataSize)}）`)
                        let pass = this.isNum(bundleStat.appSize) && !this.isNegativeNum(bundleStat.appSize) &&
                        this.isNum(bundleStat.cacheSize) && !this.isNegativeNum(bundleStat.cacheSize) &&
                        this.isNum(bundleStat.dataSize) && !this.isNegativeNum(bundleStat.dataSize)
                        if (pass) {
                          this.addLog('✓ PASS ')
                        } else {
                          this.addLog(`✗ FAIL 断言失败: ${JSON.stringify(bundleStat)}`)
                        }
                        this.addLog('INFO getCurrentBundleStats_0200 结束')
                      })
                    } catch (e) {
                      this.addLog(`✗ FAIL 异常: ${JSON.stringify(e)}`)
                      this.addLog('INFO getCurrentBundleStats_0200 结束')
                    }
                  } else {
                    this.addLog('INFO getCurrentBundleStats_0200 结束')
                  }
                }, 300)
              })
          }
          .width('100%')
          .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Flex_0010')
        }
        .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Column_0050')
      }
      .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Column_0040')
      .width('100%')
      .backgroundColor('#E0F2FE')
      .borderRadius(10)
      .padding(8)
      .margin({ top: 8 })

      Column() {
        Text('getTotalSize')
          .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Text_0040')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .width('100%')
          .textAlign(TextAlign.Start)
          .backgroundColor('#10B981')
          .borderRadius({ topLeft: 10, topRight: 10 })
          .padding({
            left: 8,
            top: 8,
            bottom: 12,
            right: 8
          })
          .margin({ bottom: 10 })
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
          Button('Promise')
            .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Button_0030')
            .fontSize(12)
            .height(36)
            .borderRadius(18)
            .backgroundColor('#34D399')
            .fontColor(Color.Black)
            .margin({ right: 8, bottom: 8 })
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.logs = ''
              this.logIndex = 0
              setTimeout(async () => {
                this.addLog('INFO getTotalSize_0100 开始')
                try {
                  let number: number = await storageStatistics.getTotalSize()
                  this.addLog(`totalSize: ${number} bytes（约${this.formatBytes(number)}）`)
                  if (this.isNum(number)) {
                    this.addLog('✓ PASS ')
                  } else {
                    this.addLog('✗ FAIL getTotalSize_0100 断言失败')
                  }
                } catch (e) {
                  this.addLog(`✗ FAIL 异常: ${JSON.stringify(e)}`)
                }
                this.addLog('INFO getTotalSize_0100 结束')
              }, 300)
            })
          Button('Callback')
            .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Button_0040')
            .fontSize(12)
            .height(36)
            .borderRadius(18)
            .backgroundColor('#34D399')
            .fontColor(Color.Black)
            .margin({ right: 8, bottom: 8 })
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.logs = ''
              this.logIndex = 0
              setTimeout(() => {
                this.addLog('INFO getTotalSize_0200 开始')
                try {
                  storageStatistics.getTotalSize((error: BusinessError, number: number) => {
                    if (error && error.code !== 0) {
                      this.addLog(`✗ FAIL error: ${JSON.stringify(error)}`)
                      this.addLog('INFO getTotalSize_0200 结束')
                      return
                    }
                    this.addLog(`totalSize: ${number} bytes（约${this.formatBytes(number)}）`)
                    if (this.isNum(number)) {
                      this.addLog('✓ PASS ')
                    } else {
                      this.addLog('✗ FAIL 断言失败')
                    }
                    this.addLog('INFO getTotalSize_0200 结束')
                  })
                } catch (e) {
                  this.addLog(`✗ FAIL 异常: ${JSON.stringify(e)}`)
                  this.addLog('INFO getTotalSize_0200 结束')
                }
              }, 300)
            })
          Button('Sync')
            .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Button_0050')
            .fontSize(12)
            .height(36)
            .borderRadius(18)
            .backgroundColor('#34D399')
            .fontColor(Color.Black)
            .margin({ right: 8, bottom: 8 })
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.logs = ''
              this.logIndex = 0
              setTimeout(() => {
                this.addLog('INFO getTotalSizeSync_0100 开始')
                try {
                  let number: number = storageStatistics.getTotalSizeSync()
                  this.addLog(`totalSizeSync: ${number} bytes（约${this.formatBytes(number)}）`)
                  if (this.isNum(number)) {
                    this.addLog('✓ PASS ')
                  } else {
                    this.addLog('✗ FAIL 断言失败')
                  }
                } catch (e) {
                  this.addLog(`✗ FAIL 异常: ${JSON.stringify(e)}`)
                }
                this.addLog('INFO getTotalSizeSync_0100 结束')
              }, 300)
            })
        }.id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Flex_0020')
      }
      .width('100%')
      .backgroundColor('#D1FAE5')
      .borderRadius(10)
      .padding(8)
      .margin({ top: 8 })
      .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Column_0060')

      Column() {
        Text('getFreeSize')
          .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Text_0050')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .width('100%')
          .textAlign(TextAlign.Start)
          .backgroundColor('#EC4899')
          .borderRadius({ topLeft: 10, topRight: 10 })
          .padding({
            left: 8,
            top: 8,
            bottom: 12,
            right: 8
          })
          .margin({ bottom: 10 })
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
          Button('Promise')
            .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Button_0060')
            .fontSize(12)
            .height(36)
            .borderRadius(18)
            .backgroundColor('#F472B6')
            .fontColor(Color.Black)
            .margin({ right: 8, bottom: 8 })
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.logs = ''
              this.logIndex = 0
              setTimeout(async () => {
                this.addLog('INFO getFreeSize_0100 开始')
                try {
                  let number: number = await storageStatistics.getFreeSize()
                  this.addLog(`freeSize: ${number} bytes（约${this.formatBytes(number)}）`)
                  if (this.isNum(number)) {
                    this.addLog('✓ PASS ')
                  } else {
                    this.addLog('✗ FAIL 断言失败')
                  }
                } catch (e) {
                  this.addLog(`✗ FAIL 异常: ${JSON.stringify(e)}`)
                }
                this.addLog('INFO getFreeSize_0100 结束')
              }, 300)
            })
          Button('Callback')
            .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Button_0070')
            .fontSize(12)
            .height(36)
            .borderRadius(18)
            .backgroundColor('#F472B6')
            .fontColor(Color.Black)
            .margin({ right: 8, bottom: 8 })
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.logs = ''
              this.logIndex = 0
              setTimeout(() => {
                this.addLog('INFO getFreeSize_0200 开始')
                try {
                  storageStatistics.getFreeSize((error: BusinessError, number: number) => {
                    if (error && error.code !== 0) {
                      this.addLog(`✗ FAIL error: ${JSON.stringify(error)}`)
                      this.addLog('INFO getFreeSize_0200 结束')
                      return
                    }
                    this.addLog(`freeSize: ${number} bytes（约${this.formatBytes(number)}）`)
                    if (this.isNum(number)) {
                      this.addLog('✓ PASS ')
                    } else {
                      this.addLog('✗ FAIL 断言失败')
                    }
                    this.addLog('INFO getFreeSize_0200 结束')
                  })
                } catch (e) {
                  this.addLog(`✗ FAIL 异常: ${JSON.stringify(e)}`)
                  this.addLog('INFO getFreeSize_0200 结束')
                }
              }, 300)
            })
          Button('Sync')
            .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Button_0080')
            .fontSize(12)
            .height(36)
            .borderRadius(18)
            .backgroundColor('#F472B6')
            .fontColor(Color.Black)
            .margin({ right: 8, bottom: 8 })
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.logs = ''
              this.logIndex = 0
              setTimeout(() => {
                this.addLog('INFO getFreeSizeSync_0100 开始')
                try {
                  let number: number = storageStatistics.getFreeSizeSync()
                  this.addLog(`freeSizeSync: ${number} bytes（约${this.formatBytes(number)}）`)
                  if (this.isNum(number)) {
                    this.addLog('✓ PASS ')
                  } else {
                    this.addLog('✗ FAIL 断言失败')
                  }
                } catch (e) {
                  this.addLog(`✗ FAIL 异常: ${JSON.stringify(e)}`)
                }
                this.addLog('INFO getFreeSizeSync_0100 结束')
              }, 300)
            })
        }
        .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Flex_0030')
      }
      .width('100%')
      .backgroundColor('#FCE7F3')
      .borderRadius(10)
      .padding(8)
      .margin({ top: 8 })
      .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Column_0070')

      Column() {
        Text('Inode APIs')
          .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Text_0060')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .width('100%')
          .textAlign(TextAlign.Start)
          .backgroundColor('#F59E0B')
          .borderRadius({ topLeft: 10, topRight: 10 })
          .padding({
            left: 8,
            top: 8,
            bottom: 12,
            right: 8
          })
          .margin({ bottom: 10 })
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
          Button('FreeInodes')
            .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Button_0090')
            .fontSize(12)
            .height(36)
            .borderRadius(18)
            .backgroundColor('#FBBF24')
            .fontColor(Color.Black)
            .margin({ right: 8, bottom: 8 })
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.logs = ''
              this.logIndex = 0
              setTimeout(async () => {
                this.addLog('INFO getFreeInodes_0100 开始')
                try {
                  let freeInodes: number = await storageStatistics.getFreeInodes()
                  this.addLog(`freeInodes=${freeInodes}`)
                  if (this.isNum(freeInodes)) {
                    this.addLog('✓ PASS ')
                  } else {
                    this.addLog('✗ FAIL 断言失败')
                  }
                } catch (e) {
                  this.addLog(`✗ FAIL 异常: ${JSON.stringify(e)}`)
                }
                this.addLog('INFO getFreeInodes_0100 结束')
              }, 300)
            })
          Button('TotalInodes')
            .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Button_0100')
            .fontSize(12)
            .height(36)
            .borderRadius(18)
            .backgroundColor('#FBBF24')
            .fontColor(Color.Black)
            .margin({ right: 8, bottom: 8 })
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.logs = ''
              this.logIndex = 0
              setTimeout(async () => {
                this.addLog('INFO getTotalInodes_0100 开始')
                try {
                  let totalInodes: number = await storageStatistics.getTotalInodes()
                  this.addLog(`totalInodes=${totalInodes}`)
                  if (this.isNum(totalInodes)) {
                    this.addLog('✓ PASS ')
                  } else {
                    this.addLog('✗ FAIL 断言失败')
                  }
                } catch (e) {
                  this.addLog(`✗ FAIL 异常: ${JSON.stringify(e)}`)
                }
                this.addLog('INFO getTotalInodes_0100 结束')
              }, 300)
            })
          Button('BundleInodes')
            .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Button_0110')
            .fontSize(12)
            .height(36)
            .borderRadius(18)
            .backgroundColor('#FBBF24')
            .fontColor(Color.Black)
            .margin({ right: 8, bottom: 8 })
            .padding({ left: 16, right: 16 })
            .onClick(() => {
              this.logs = ''
              this.logIndex = 0
              setTimeout(async () => {
                this.addLog('INFO getCurrentBundleInodes_0100 开始')
                try {
                  let curInodes: number = await storageStatistics.getCurrentBundleInodes()
                  this.addLog(`curInodes=${curInodes}`)
                  if (this.isNum(curInodes)) {
                    this.addLog('✓ PASS ')
                  } else {
                    this.addLog('✗ FAIL 断言失败')
                  }
                } catch (e) {
                  this.addLog(`✗ FAIL 异常: ${JSON.stringify(e)}`)
                }
                this.addLog('INFO getCurrentBundleInodes_0100 结束')
              }, 300)
            })
        }.id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Flex_0040')
      }
      .width('100%')
      .backgroundColor('#FEF3C7')
      .borderRadius(10)
      .padding(8)
      .margin({ top: 8 })
      .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Column_0080')
    }
    .size({ width: '100%', height: '100%' })
    .id('com.example.filestoragestatistics:id/ArkUIX_FileStorageStatistics_EnterPage_EnterPage_Column_0010')
  }
}
