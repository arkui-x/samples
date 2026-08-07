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

import { buttonSchemes, ExpectedResult } from '../common/TestData';
import common from '@ohos.app.ability.common';
import deviceInfo from '@ohos.deviceInfo';
import fs from '@ohos.file.fs';
import fileUri from '@ohos.file.fileuri';

let context = getContext(this) as common.UIAbilityContext
const TAG: string = '[fileuri][EnterPage] '
const TEST_DIR_PATH: string = context.filesDir + '/TestDir'
const TEST_FILE_PATH: string = TEST_DIR_PATH + '/test.txt'
const TEST_FILE_URI_1: string = 'file://' + TEST_FILE_PATH
const TEST_FILE_URI_2: string = 'file://' + '/TestDir' + '/test.txt'
const LONG_STRING: string = '/' + 'a'.repeat(500)
const LONG_STRING_PATH: string = '/' + 'a'.repeat(500) + '/test.txt'
const LONG_STRING_NAME: string = '/' + 'a'.repeat(500) + 'test.txt'
const TEST_RELATIVE_PATH: string = '..' + '/TestDir' + '/test.txt'
const TEST_PROJECT_ID: string = 'com.example.enjoyarkuix'

const EXP_ARKUIX_FILEURI_GETURIFROMPATH_0100: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/ABCD/abcd/%E4%B8%AD%E6%96%87/12345/test.txt',
  'file://' + TEST_PROJECT_ID + '/ABCD/abcd/%E4%B8%AD%E6%96%87/12345/test.txt',
  'file://' + TEST_PROJECT_ID + '/ABCD/abcd/%E4%B8%AD%E6%96%87/12345/test.txt'
)
const EXP_ARKUIX_FILEURI_GETURIFROMPATH_0200: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/AB!%40%40%23%24%25%5E%26*()-%3D/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB!%40%40%23%24%25%5E%26*()-%3D/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB!%40%40%23%24%25%5E%26*()-%3D/test.txt'
)
const EXP_ARKUIX_FILEURI_GETURIFROMPATH_0300: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/AB%EF%BC%81%40%23%EF%BF%A5%25%E2%80%A6%E2%80%A6%26/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB%EF%BC%81%40%23%EF%BF%A5%25%E2%80%A6%E2%80%A6%26/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB%EF%BC%81%40%23%EF%BF%A5%25%E2%80%A6%E2%80%A6%26/test.txt'
)
const EXP_ARKUIX_FILEURI_GETURIFROMPATH_0400: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/AB%5C%5C%20%20Csd2w/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB%5C%5C%20%20Csd2w/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB%5C%5C%20%20Csd2w/test.txt'
)
const EXP_ARKUIX_FILEURI_GETURIFROMPATH_0500: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '',
  'file://' + TEST_PROJECT_ID + '',
  'file://' + TEST_PROJECT_ID + ''
)
const EXP_ARKUIX_FILEURI_GETURIFROMPATH_0600: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/' + 'a'.repeat(500),
  'file://' + TEST_PROJECT_ID + '/' + 'a'.repeat(500),
  'file://' + TEST_PROJECT_ID + '/' + 'a'.repeat(500)
)
const EXP_ARKUIX_FILEURI_GETURIFROMPATH_0700: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/TestDir/test.txt',
  'file://' + TEST_PROJECT_ID + '/TestDir/test.txt',
  'file://' + TEST_PROJECT_ID + '/TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_GETURIFROMPATH_0800: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/data/storage/el2/base/haps/entry/files/TestDir/test.txt',
  'file://' + TEST_PROJECT_ID + '/data/user/0/' + TEST_PROJECT_ID + '/files/files/TestDir/test.txt',
  'file://' + TEST_PROJECT_ID + '' + context.filesDir + '/TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_GETURIFROMPATH_0900: ExpectedResult = new ExpectedResult(
  'file:///data/storage/el2/base/haps/entry/files/TestDir/test.txt',
  'file:///data/user/0/' + TEST_PROJECT_ID + '/files/files/TestDir/test.txt',
  'file://' + context.filesDir + '/TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_GETURIFROMPATH_1000: ExpectedResult = new ExpectedResult(
  'file:///TestDir/test.txt',
  'file:///TestDir/test.txt',
  'file:///TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_PATH_0100: ExpectedResult = new ExpectedResult(
  '/ABCD/abcd/中文/12345/test.txt',
  '/ABCD/abcd/中文/12345/test.txt',
  '/ABCD/abcd/中文/12345/test.txt'
)
const EXP_ARKUIX_FILEURI_PATH_0200: ExpectedResult = new ExpectedResult(
  '/AB!@@#$%^&*()-=/test.txt',
  '/AB!@@#$%^&*()-=/test.txt',
  '/AB!@@#$%^&*()-=/test.txt'
)
const EXP_ARKUIX_FILEURI_PATH_0300: ExpectedResult = new ExpectedResult(
  '/AB！@#￥%……&/test.txt',
  '/AB！@#￥%……&/test.txt',
  '/AB！@#￥%……&/test.txt'
)
const EXP_ARKUIX_FILEURI_PATH_0400: ExpectedResult = new ExpectedResult(
  '/AB\\\\  Csd2w/test.txt',
  '/AB\\\\  Csd2w/test.txt',
  '/AB\\\\  Csd2w/test.txt'
)
const EXP_ARKUIX_FILEURI_PATH_0500: ExpectedResult = new ExpectedResult('', '', '')
const EXP_ARKUIX_FILEURI_PATH_0600: ExpectedResult = new ExpectedResult(
  LONG_STRING,
  LONG_STRING,
  LONG_STRING
)
const EXP_ARKUIX_FILEURI_PATH_0700: ExpectedResult = new ExpectedResult(
  '/TestDir/test.txt',
  '/TestDir/test.txt',
  '/TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_PATH_0800: ExpectedResult = new ExpectedResult(
  '/data/storage/el2/base/haps/entry/files/TestDir/test.txt',
  '/data/user/0/' + TEST_PROJECT_ID + '/files/files/TestDir/test.txt',
  context.filesDir + '/TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_PATH_0900: ExpectedResult = new ExpectedResult(
  '/data/storage/el2/base/haps/entry/files/TestDir/test.txt',
  '/data/user/0/' + TEST_PROJECT_ID + '/files/files/TestDir/test.txt',
  context.filesDir + '/TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_PATH_1000: ExpectedResult = new ExpectedResult(
  '/TestDir/test.txt',
  '/TestDir/test.txt',
  '/TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_PATH_1100: ExpectedResult = new ExpectedResult('', '', '')
const EXP_ARKUIX_FILEURI_NAME_0100: ExpectedResult = new ExpectedResult(
  'test.txt',
  'test.txt',
  'test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_0200: ExpectedResult = new ExpectedResult(
  'test.txt',
  'test.txt',
  'test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_0300: ExpectedResult = new ExpectedResult(
  'test.txt',
  'test.txt',
  'test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_0400: ExpectedResult = new ExpectedResult(
  'test.txt',
  'test.txt',
  'test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_0500: ExpectedResult = new ExpectedResult('', '', '')
const EXP_ARKUIX_FILEURI_NAME_0600: ExpectedResult = new ExpectedResult(
  'test.txt',
  'test.txt',
  'test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_0700: ExpectedResult = new ExpectedResult(
  'test.txt',
  'test.txt',
  'test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_0800: ExpectedResult = new ExpectedResult(
  'test.txt',
  'test.txt',
  'test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_0900: ExpectedResult = new ExpectedResult(
  'test.txt',
  'test.txt',
  'test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_1000: ExpectedResult = new ExpectedResult(
  'test.txt',
  'test.txt',
  'test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_1100: ExpectedResult = new ExpectedResult(
  'TestDir',
  'TestDir',
  'TestDir'
)
const EXP_ARKUIX_FILEURI_NAME_1200: ExpectedResult = new ExpectedResult(
  'ABCDabcd中文12345test.txt',
  'ABCDabcd中文12345test.txt',
  'ABCDabcd中文12345test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_1300: ExpectedResult = new ExpectedResult(
  'AB!@@#$%^&*()-=testAB！@#￥%……&test.txt',
  'AB!@@#$%^&*()-=testAB！@#￥%……&test.txt',
  'AB!@@#$%^&*()-=testAB！@#￥%……&test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_1400: ExpectedResult = new ExpectedResult(
  'a'.repeat(500) + 'test.txt',
  'a'.repeat(500) + 'test.txt',
  'a'.repeat(500) + 'test.txt'
)
const EXP_ARKUIX_FILEURI_NAME_1500: ExpectedResult = new ExpectedResult(
  'te  st.txt',
  'te  st.txt',
  'te  st.txt'
)
const EXP_ARKUIX_FILEURI_NAME_1600: ExpectedResult = new ExpectedResult(
  'te\\st.txt',
  'te\\st.txt',
  'te\\st.txt'
)
const EXP_ARKUIX_FILEURI_NAME_1700: ExpectedResult = new ExpectedResult(
  'st.txt',
  'st.txt',
  'st.txt'
)
const EXP_ARKUIX_FILEURI_NAME_1800: ExpectedResult = new ExpectedResult(
  'test.txt.txt.txt.txt',
  'test.txt.txt.txt.txt',
  'test.txt.txt.txt.txt'
)
const EXP_ARKUIX_FILEURI_NAME_2000: ExpectedResult = new ExpectedResult('', '', '')
const EXP_ARKUIX_FILEURI_TOSTRING_0100: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/ABCD/abcd/%E4%B8%AD%E6%96%87/12345/test.txt',
  'file://' + TEST_PROJECT_ID + '/ABCD/abcd/%E4%B8%AD%E6%96%87/12345/test.txt',
  'file://' + TEST_PROJECT_ID + '/ABCD/abcd/%E4%B8%AD%E6%96%87/12345/test.txt'
)
const EXP_ARKUIX_FILEURI_TOSTRING_0200: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/AB!%40%40%23%24%25%5E%26*()-%3D/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB!%40%40%23%24%25%5E%26*()-%3D/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB!%40%40%23%24%25%5E%26*()-%3D/test.txt'
)
const EXP_ARKUIX_FILEURI_TOSTRING_0300: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/AB%EF%BC%81%40%23%EF%BF%A5%25%E2%80%A6%E2%80%A6%26/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB%EF%BC%81%40%23%EF%BF%A5%25%E2%80%A6%E2%80%A6%26/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB%EF%BC%81%40%23%EF%BF%A5%25%E2%80%A6%E2%80%A6%26/test.txt'
)
const EXP_ARKUIX_FILEURI_TOSTRING_0400: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/AB%5C%5C%20%20Csd2w/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB%5C%5C%20%20Csd2w/test.txt',
  'file://' + TEST_PROJECT_ID + '/AB%5C%5C%20%20Csd2w/test.txt'
)
const EXP_ARKUIX_FILEURI_TOSTRING_0500: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '',
  'file://' + TEST_PROJECT_ID + '',
  'file://' + TEST_PROJECT_ID + ''
)
const EXP_ARKUIX_FILEURI_TOSTRING_0600: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '' + LONG_STRING,
  'file://' + TEST_PROJECT_ID + '' + LONG_STRING,
  'file://' + TEST_PROJECT_ID + '' + LONG_STRING
)
const EXP_ARKUIX_FILEURI_TOSTRING_0700: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/TestDir/test.txt',
  'file://' + TEST_PROJECT_ID + '/TestDir/test.txt',
  'file://' + TEST_PROJECT_ID + '/TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_TOSTRING_0800: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/data/storage/el2/base/haps/entry/files/TestDir/test.txt',
  'file://' + TEST_PROJECT_ID + '/data/user/0/' + TEST_PROJECT_ID + '/files/files/TestDir/test.txt',
  'file://' + TEST_PROJECT_ID + '' + context.filesDir + '/TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_TOSTRING_0900: ExpectedResult = new ExpectedResult(
  'file:///data/storage/el2/base/haps/entry/files/TestDir/test.txt',
  'file:///data/user/0/' + TEST_PROJECT_ID + '/files/files/TestDir/test.txt',
  'file://' + context.filesDir + '/TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_TOSTRING_1000: ExpectedResult = new ExpectedResult(
  'file:///TestDir/test.txt',
  'file:///TestDir/test.txt',
  'file:///TestDir/test.txt'
)
const EXP_ARKUIX_FILEURI_TOSTRING_1100: ExpectedResult = new ExpectedResult('', '', '')
const EXP_ARKUIX_FILEURI_GETFULLDIRECTORYURI_0100: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/data/storage/el2/base/haps/entry/files/TestDir11',
  'file://' + TEST_PROJECT_ID + '/data/user/0/' + TEST_PROJECT_ID + '/files/files/TestDir11',
  'file://' + TEST_PROJECT_ID + '' + context.filesDir + '/TestDir11'
)
const EXP_ARKUIX_FILEURI_GETFULLDIRECTORYURI_0300: ExpectedResult = new ExpectedResult(
  'file://' + TEST_PROJECT_ID + '/data/storage/el2/base/haps/entry/files/TestDir13',
  'file://' + TEST_PROJECT_ID + '/data/user/0/' + TEST_PROJECT_ID + '/files/files/TestDir13',
  'file://' + TEST_PROJECT_ID + '' + context.filesDir + '/TestDir13'
)

@Component
struct TestButtonItem {
  @State showDetail: boolean = false
  @State detailText: string = ''
  @Prop label: string = ''
  @Prop description: string = ''
  @Prop itemWidth: Length = 160
  @Prop bgColor: ResourceColor = '#f0f0f0'
  @Prop fontColor: ResourceColor = 'rgba(8, 8, 10, 1.00)'
  private onRunTest: () => void = () => {
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
    console.info(TAG + 'context.filesDir is ' + context.filesDir)
  }

  build() {
    Stack() {
      Row() {
        Column() {
          Row() {
          }
          .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Row_0010')
          .size({ width: '100%', height: 20 })

          Row() {
            Text('FileUri 测试')
              .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Text_0010')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
          }
          .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Row_0020')
          .size({ width: '95%', height: 40 })
          .margin({ top: 10 })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Row() {
            Button('清空日志')
              .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Button_0010')
              .fontSize(14)
              .size({ width: '30%', height: 32 })
              .onClick(() => {
                this.info = ''
                this.logIndex = 0
              })

            Text('系统: ' + this.platform)
              .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Text_0020')
              .fontSize(12)
              .fontColor(Color.Gray)
          }
          .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Row_0030')
          .width('96%').padding({ left: 5, right: 5 })
          .justifyContent(FlexAlign.SpaceBetween)

          Column() {
            Scroll(this.scrollerForLog) {
              Text(this.info.length > 0 ? this.info : '等待测试结果...')
                .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Text_0030')
                .fontSize(12)
                .width('100%')
                .textAlign(TextAlign.Start)
            }
            .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Scroll_0010')
            .scrollBar(BarState.Off)
          }
          .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Column_0010')
          .size({ width: '95%', height: '20%' })
          .border({ width: 1, color: Color.Gray })
          .borderRadius(5)
          .padding(5)
          .margin({ top: 5 })

          Divider()
            .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Divider_0010')
            .size({ width: '100%', height: 2 }).backgroundColor(Color.Black).margin({ top: 8, bottom: 8 })

          Column() {
            Scroll() {
              Column({ space: 4 }) {
                Text('▌ getUriFromPath 测试')
                  .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Text_0040')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width('100%')
                  .margin({ top: 5 })
                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_0100',
                    description: 'Test getUriFromPath of API function, value is \'/ABCD/abcd/中文/12345/test.txt\'',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPath('0100', '/ABCD/abcd/中文/12345/test.txt',
                      EXP_ARKUIX_FILEURI_GETURIFROMPATH_0100))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0010')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_0200',
                    description: 'Test getUriFromPath of API function, value is \'/AB!@@#$%^&*()-=/test.txt\'',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPath('0200', '/AB!@@#$%^&*()-=/test.txt',
                      EXP_ARKUIX_FILEURI_GETURIFROMPATH_0200))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0020')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_0300',
                    description: 'Test getUriFromPath of API function, value is \'/AB！@#￥%……&/test.txt\'',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPath('0300', '/AB！@#￥%……&/test.txt',
                      EXP_ARKUIX_FILEURI_GETURIFROMPATH_0300))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0030')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_0400',
                    description: 'Test getUriFromPath of API function, value is \'/AB\\\\  Csd2w/test.txt\'',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPath('0400', '/AB\\\\  Csd2w/test.txt',
                      EXP_ARKUIX_FILEURI_GETURIFROMPATH_0400))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0040')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_0500',
                    description: 'Test getUriFromPath of API function, value is 空字符串',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPath('0500', '',
                      EXP_ARKUIX_FILEURI_GETURIFROMPATH_0500)),
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0050')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_0600',
                    description: 'Test getUriFromPath of API function, value is 长字符串',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPath('0600', LONG_STRING,
                      EXP_ARKUIX_FILEURI_GETURIFROMPATH_0600))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0060')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_0700',
                    description: 'Test getUriFromPath of API function, value is \'/TestDir/test.txt\'',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPath('0700', '/TestDir/test.txt',
                      EXP_ARKUIX_FILEURI_GETURIFROMPATH_0700))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0070')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_0800',
                    description: 'Test getUriFromPath of API function, value is 沙箱路径 +  + "/TestDir/test.txt"',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPath('0800', TEST_FILE_PATH,
                      EXP_ARKUIX_FILEURI_GETURIFROMPATH_0800))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0080')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_0900',
                    description: 'Test getUriFromPath of API function, value is \'file://{沙箱路径}/TestDir/test.txt\'',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPath('0900', TEST_FILE_URI_1,
                      EXP_ARKUIX_FILEURI_GETURIFROMPATH_0900))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0090')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_1000',
                    description: 'Test getUriFromPath of API function, value is \'file:///TestDir/test.txt\'',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPath('1000', TEST_FILE_URI_2,
                      EXP_ARKUIX_FILEURI_GETURIFROMPATH_1000))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0100')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_1100',
                    description: 'Test getUriFromPath of API function, value is null',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPathNull('1100', null))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0110')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_1200',
                    description: 'Test getUriFromPath of API function, value is undefined',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPathNull('1200', undefined))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0120')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getUriFromPath_1300',
                    description: 'Test getUriFromPath of API function, value is \'../TestDir/test.txt\'',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetUriFromPathRelativePath('1300', TEST_RELATIVE_PATH))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0570')
                }
                .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Flex_0010')

                Text('▌ FileUri.path 测试')
                  .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Text_0050')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width('100%')
                  .margin({ top: 10 })
                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_path_0100',
                    description: 'Test path of FileUri, value is \'/ABCD/abcd/中文/12345/test.txt\'',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testPath('0100', '/ABCD/abcd/中文/12345/test.txt',
                      EXP_ARKUIX_FILEURI_PATH_0100))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0130')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_path_0200',
                    description: 'Test path of FileUri, value is \'/AB!@@#$%^&*()-=/test.txt\'',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testPath('0200', '/AB!@@#$%^&*()-=/test.txt',
                      EXP_ARKUIX_FILEURI_PATH_0200))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0140')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_path_0300',
                    description: 'Test path of FileUri, value is \'/AB！@#￥%……&/test.txt\'',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testPath('0300', '/AB！@#￥%……&/test.txt',
                      EXP_ARKUIX_FILEURI_PATH_0300))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0150')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_path_0400',
                    description: 'Test path of FileUri, value is \'/AB\\\\  Csd2w/test.txt\'',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testPath('0400', '/AB\\\\  Csd2w/test.txt',
                      EXP_ARKUIX_FILEURI_PATH_0400))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0160')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_path_0500',
                    description: 'Test path of FileUri, value is 空字符串',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testPath('0500', '', EXP_ARKUIX_FILEURI_PATH_0500))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0170')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_path_0600',
                    description: 'Test path of FileUri, value is 长字符串',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testPath('0600', LONG_STRING, EXP_ARKUIX_FILEURI_PATH_0600))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0180')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_path_0700',
                    description: 'Test path of FileUri, value is \'/TestDir/test.txt\'',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testPath('0700', '/TestDir/test.txt',
                      EXP_ARKUIX_FILEURI_PATH_0700))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0190')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_path_0800',
                    description: 'Test path of FileUri, value is 沙箱路径 +  + "/TestDir/test.txt"',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testPath('0800', TEST_FILE_PATH,
                      EXP_ARKUIX_FILEURI_PATH_0800))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0200')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_path_0900',
                    description: 'Test path of FileUri, value is \'file://{沙箱路径}/TestDir/test.txt\'',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testPath('0900', TEST_FILE_URI_1,
                      EXP_ARKUIX_FILEURI_PATH_0900))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0210')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_path_1000',
                    description: 'Test path of FileUri, value is \'file:///TestDir/test.txt\'',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testPath('1000', TEST_FILE_URI_2,
                      EXP_ARKUIX_FILEURI_PATH_1000))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0220')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_path_1100',
                    description: 'Test path of FileUri, value is \'../TestDir/test.txt\'',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testPath('1100', TEST_RELATIVE_PATH,
                      EXP_ARKUIX_FILEURI_PATH_1100))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0580')
                }
                .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Flex_0020')

                Text('▌ FileUri.name 测试')
                  .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Text_0060')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width('100%')
                  .margin({ top: 10 })
                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_0100',
                    description: 'Test name of FileUri, test value is \'/ABCD/abcd/中文/12345/test.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('0100', '/ABCD/abcd/中文/12345/test.txt',
                      EXP_ARKUIX_FILEURI_NAME_0100))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0230')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_0200',
                    description: 'Test name of FileUri, test value is \'/AB!@@#$%^&*()-=/test.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('0200', '/AB!@@#$%^&*()-=/test.txt',
                      EXP_ARKUIX_FILEURI_NAME_0200))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0240')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_0300',
                    description: 'Test name of FileUri, test value is \'/AB！@#￥%……&/test.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('0300', '/AB！@#￥%……&/test.txt',
                      EXP_ARKUIX_FILEURI_NAME_0300))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0250')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_0400',
                    description: 'Test name of FileUri, test value is \'/AB\\\\  Csd2w/test.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('0400', '/AB\\\\  Csd2w/test.txt',
                      EXP_ARKUIX_FILEURI_NAME_0400))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0260')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_0500',
                    description: 'Test name of FileUri, test value is 空字符串',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('0500', '', EXP_ARKUIX_FILEURI_NAME_0500))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0270')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_0600',
                    description: 'Test name of FileUri, test value is 长字符串',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('0600', LONG_STRING_PATH,
                      EXP_ARKUIX_FILEURI_NAME_0600))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0280')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_0700',
                    description: 'Test name of FileUri, test value is \'/TestDir/test.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('0700', '/TestDir/test.txt',
                      EXP_ARKUIX_FILEURI_NAME_0700))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0290')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_0800',
                    description: 'Test name of FileUri, test value is 沙箱路径 + "/TestDir/test.txt"',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('0800', TEST_FILE_PATH, EXP_ARKUIX_FILEURI_NAME_0800))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0300')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_0900',
                    description: 'Test name of FileUri, test value is \'file://{沙箱路径}/TestDir/test.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('0900', TEST_FILE_URI_1, EXP_ARKUIX_FILEURI_NAME_0900))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0310')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_1000',
                    description: 'Test name of FileUri, test value is \'file:///TestDir/test.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('1000', TEST_FILE_URI_2, EXP_ARKUIX_FILEURI_NAME_1000))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0320')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_1100',
                    description: 'Test name of FileUri, test value is dir not file',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('1100', TEST_DIR_PATH, EXP_ARKUIX_FILEURI_NAME_1100))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0330')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_1200',
                    description: 'Test name of FileUri, test name is \'ABCDabcd中文12345test.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('1200', '/TestDir/ABCDabcd中文12345test.txt',
                      EXP_ARKUIX_FILEURI_NAME_1200))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0340')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_1300',
                    description: 'Test name of FileUri, test name is \'AB!@@#$%^&*()-=testAB！@#￥%……&test.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('1300',
                      '/TestDir/AB!@@#$%^&*()-=testAB！@#￥%……&test.txt',
                      EXP_ARKUIX_FILEURI_NAME_1300))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0350')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_1400',
                    description: 'Test name of FileUri, test name is (\'a\'.repeat(500) + \'test.txt\')',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('1400', TEST_DIR_PATH + LONG_STRING_NAME,
                      EXP_ARKUIX_FILEURI_NAME_1400))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0360')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_1500',
                    description: 'Test name of FileUri, test name is \'te  st.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('1500', TEST_DIR_PATH + '/te  st.txt',
                      EXP_ARKUIX_FILEURI_NAME_1500))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0370')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_1600',
                    description: 'Test name of FileUri, test name is \'te\\st.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('1600', TEST_DIR_PATH + '/te\\st.txt',
                      EXP_ARKUIX_FILEURI_NAME_1600))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0380')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_1700',
                    description: 'Test name of FileUri, test name is \'te/st.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('1700', TEST_DIR_PATH + '/te/st.txt',
                      EXP_ARKUIX_FILEURI_NAME_1700))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0390')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_1800',
                    description: 'Test name of FileUri, test name is \'test.txt.txt.txt.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('1800', TEST_DIR_PATH + '/test.txt.txt.txt.txt',
                      EXP_ARKUIX_FILEURI_NAME_1800))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0400')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_1900',
                    description: 'Test name of FileUri, test name is Common File Extensions',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testNameExtensions())
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0410')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_name_2000',
                    description: 'Test name of FileUri, test dir is \'../TestDir/test.txt\'',
                    bgColor: buttonSchemes[2].bgColor,
                    fontColor: buttonSchemes[2].fontColor,
                    onRunTest: this.wrapTest(() => this.testName('2000', TEST_RELATIVE_PATH,
                      EXP_ARKUIX_FILEURI_NAME_2000))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0590')
                }
                .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Flex_0030')

                Text('▌ FileUri.toString 测试')
                  .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Text_0070')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width('100%')
                  .margin({ top: 10 })
                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_toString_0100',
                    description: 'Test toString of FileUri function, value is \'/ABCD/abcd/中文/12345/test.txt\'',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    onRunTest: this.wrapTest(() => this.testToString('0100', '/ABCD/abcd/中文/12345/test.txt',
                      EXP_ARKUIX_FILEURI_TOSTRING_0100))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0420')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_toString_0200',
                    description: 'Test toString of FileUri function, value is \'/AB!@@#$%^&*()-=/test.txt\'',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    onRunTest: this.wrapTest(() => this.testToString('0200', '/AB!@@#$%^&*()-=/test.txt',
                      EXP_ARKUIX_FILEURI_TOSTRING_0200))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0430')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_toString_0300',
                    description: 'Test toString of FileUri function, value is \'/AB！@#￥%……&/test.txt\'',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    onRunTest: this.wrapTest(() => this.testToString('0300', '/AB！@#￥%……&/test.txt',
                      EXP_ARKUIX_FILEURI_TOSTRING_0300))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0440')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_toString_0400',
                    description: 'Test toString of FileUri function, value is \'/AB\\\\  Csd2w/test.txt\'',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    onRunTest: this.wrapTest(() => this.testToString('0400', '/AB\\\\  Csd2w/test.txt',
                      EXP_ARKUIX_FILEURI_TOSTRING_0400))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0450')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_toString_0500',
                    description: 'Test toString of FileUri function, value is 空字符串',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    onRunTest: this.wrapTest(() => this.testToString('0500', '',
                      EXP_ARKUIX_FILEURI_TOSTRING_0500))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0460')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_toString_0600',
                    description: 'Test toString of FileUri function, value is 长字符串',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    onRunTest: this.wrapTest(() => this.testToString('0600', LONG_STRING,
                      EXP_ARKUIX_FILEURI_TOSTRING_0600))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0470')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_toString_0700',
                    description: 'Test toString of FileUri function, value is \'/TestDir/test.txt\'',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    onRunTest: this.wrapTest(() => this.testToString('0700', '/TestDir/test.txt',
                      EXP_ARKUIX_FILEURI_TOSTRING_0700))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0480')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_toString_0800',
                    description: 'Test toString of FileUri function, value is 沙箱路径 +  + "/TestDir/test.txt"',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    onRunTest: this.wrapTest(() => this.testToString('0800', TEST_FILE_PATH,
                      EXP_ARKUIX_FILEURI_TOSTRING_0800))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0490')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_toString_0900',
                    description: 'Test toString of FileUri function, value is \'file://{沙箱路径}/TestDir/test.txt\'',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    onRunTest: this.wrapTest(() => this.testToString('0900', TEST_FILE_URI_1,
                      EXP_ARKUIX_FILEURI_TOSTRING_0900))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0500')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_toString_1000',
                    description: 'Test toString of FileUri function, value is \'file:///TestDir/test.txt\'',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    onRunTest: this.wrapTest(() => this.testToString('1000', TEST_FILE_URI_2,
                      EXP_ARKUIX_FILEURI_TOSTRING_1000))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0510')
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_toString_1100',
                    description: 'Test toString of FileUri function, value is \'../TestDir/test.txt\'',
                    bgColor: buttonSchemes[3].bgColor,
                    fontColor: buttonSchemes[3].fontColor,
                    onRunTest: this.wrapTest(() => this.testToString('1100', TEST_RELATIVE_PATH,
                      EXP_ARKUIX_FILEURI_TOSTRING_1100))
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0600')
                }
                .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Flex_0040')

                Text('▌ FileUri.getFullDirectoryUri 测试')
                  .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Text_0080')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width('100%')
                  .margin({ top: 10 })
                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getFullDirectoryUri_0100',
                    description: 'Test getFullDirectoryUri of FileUri function, value is exists dir',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetFullDirectoryUriExistsDir('0100')),
                    itemWidth: 300
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0520')
                }
                .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Flex_0050')

                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getFullDirectoryUri_0200',
                    description: 'Test getFullDirectoryUri of FileUri function, value is non-exists dir',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(
                      () => this.testExpectError('0200', context.filesDir + '/TestDir12', 'getFullDirectoryUri')),
                    itemWidth: 300
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0530')
                }
                .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Flex_0060')

                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getFullDirectoryUri_0300',
                    description: 'Test getFullDirectoryUri of FileUri function, value is exists file',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(() => this.testGetFullDirectoryUriExistsFile('0300')),
                    itemWidth: 300
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0540')
                }
                .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Flex_0070')

                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: 'ArkUIX_FileUri_getFullDirectoryUri_0400',
                    description: 'Test getFullDirectoryUri of FileUri function, value is non-exists file',
                    bgColor: buttonSchemes[0].bgColor,
                    fontColor: buttonSchemes[0].fontColor,
                    onRunTest: this.wrapTest(
                      () => this.testExpectError('0400', context.filesDir + '/TestDir14' + '/test.txt',
                        'getFullDirectoryUri')),
                    itemWidth: 300
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0550')
                }
                .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Flex_0080')

                Text('▌ FileUri + File I/O 测试')
                  .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Text_0090')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .width('100%')
                  .margin({ top: 10 })
                Flex({ wrap: FlexWrap.Wrap }) {
                  TestButtonItem({
                    label: '测试文件流fs操作',
                    description: '',
                    bgColor: buttonSchemes[1].bgColor,
                    fontColor: buttonSchemes[1].fontColor,
                    onRunTest: this.wrapTest(() => this.testFileUriFileIO()),
                    itemWidth: 300
                  })
                    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_TestButtonItem_0560')
                }
                .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Flex_0090')

              }
              .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Column_0020')
              .width('100%').padding({ left: 10 })
            }
            .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Scroll_0020')
            .scrollBar(BarState.Auto)
          }
          .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Column_0030')
          .layoutWeight(1)

          Row() {
          }
          .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Row_0040')
          .size({ width: '100%', height: 10 })
        }
        .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Column_0040')
        .width('100%')
      }
      .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Row_0050')
      .height('100%')
    }
    .id('' + TEST_PROJECT_ID + ':id/ArkUIX_FileUri_EnterPage_Stack_0010')
    .width('100%')
    .height('100%')
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

  getExpectedValue(exp: ExpectedResult): string {
    if (this.platform.includes('iOS')) {
      return exp.resultForiOS
    } else if (this.platform.includes('Android')) {
      return exp.resultForAndroid
    }
    return exp.resultForOH
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
    }, 100)
  }

  testGetUriFromPath(testNo: string, input: string, exp: ExpectedResult): void {
    try {
      let uri = fileUri.getUriFromPath(input)
      let expected = this.getExpectedValue(exp)
      this.appendLog('getUriFromPath-' + testNo + ' input: ' + input)
      this.appendLog('  → result: ' + uri)
      if (uri === expected) {
        if (expected.length > 230) {
          this.appendLog('  ✓ PASS ')
        } else {
          this.appendLog('  ✓ PASS (期望: ' + expected + ')')
        }
      } else {
        if (expected.length > 230) {
          this.appendLog('  ✗ FAIL ')
        } else {
          this.appendLog('  ✗ FAIL (期望: ' + expected + ', 实际: ' + uri + ')')
        }
      }
    } catch (e) {
      this.appendLog('getUriFromPath-' + testNo + ' 抛出异常: ' + JSON.stringify(e))
      this.appendLog('  ✗ FAIL')
    }
  }

  testGetUriFromPathNull(testNo: string, input: string | null | undefined): void {
    try {
      let uri = fileUri.getUriFromPath(input)
      this.appendLog('getUriFromPath-' + testNo + ' input: ' + input + ' → ' + uri + ' (未抛出异常)')
    } catch (e) {
      let errStr = JSON.stringify(e)
      if (errStr.includes('401')) {
        this.appendLog('getUriFromPath-' + testNo + ' ✓ PASS, 捕获预期异常 code=401')
        this.appendLog(' ✓ PASS, 捕获预期异常 code=401')
      } else {
        this.appendLog('getUriFromPath-' + testNo + ' 抛出异常: ' + errStr)
        this.appendLog('  ✗ FAIL')
      }
    }
  }

  testGetUriFromPathRelativePath(testNo: string, input: string | null | undefined): void {
    try {
      let uri = fileUri.getUriFromPath(input)
      this.appendLog('getUriFromPath-' + testNo + ' input: ' + input + ' → ' + uri + ' (未抛出异常)')
    } catch (e) {
      let errStr = JSON.stringify(e)
      if (errStr.includes('401')) {
        this.appendLog('getUriFromPath-' + testNo + ' ✓ PASS, 捕获预期异常 code=401')
        this.appendLog(' ✓ PASS, 捕获预期异常 code=401')
      } else {
        this.appendLog('getUriFromPath-' + testNo + ' 抛出异常: ' + errStr)
        this.appendLog('  ✗ FAIL')
      }
    }
  }

  testPath(testNo: string, input: string, exp: ExpectedResult): void {
    try {
      let fileUriObject = new fileUri.FileUri(input)
      let path = fileUriObject.path
      let expected = this.getExpectedValue(exp)
      this.appendLog('path-' + testNo + ' input: ' + input)
      this.appendLog('  → result: ' + path)
      if (path === expected) {
        if (expected.length > 230) {
          this.appendLog('  ✓ PASS ')
        } else {
          this.appendLog('  ✓ PASS (期望: ' + expected + ')')
        }
      } else {
        if (expected.length > 230) {
          this.appendLog('  ✗ FAIL ')
        } else {
          this.appendLog('  ✗ FAIL (期望: ' + expected + ', 实际: ' + path + ')')
        }
      }
    } catch (e) {
      this.appendLog('path-' + testNo + ' 抛出异常: ' + JSON.stringify(e))
      this.appendLog('  ✗ FAIL')
    }
  }

  testName(testNo: string, input: string, exp: ExpectedResult): void {
    try {
      let fileUriObject = new fileUri.FileUri(input)
      let name = fileUriObject.name
      let expected = this.getExpectedValue(exp)
      this.appendLog('name-' + testNo + ' input: ' + (input === '' ? '空字符串' : input))
      this.appendLog('  → result: ' + name)
      if (name === expected) {
        if (expected.length > 230) {
          this.appendLog('  ✓ PASS ')
        } else {
          this.appendLog('  ✓ PASS (期望: ' + (expected === '' ? '空字符串' : expected) + ')')
        }
      } else {
        if (expected.length > 230) {
          this.appendLog('  ✗ FAIL ')
        } else {
          this.appendLog('  ✗ FAIL (期望: ' + (expected === '' ? '空字符串' : expected) + ', 实际: ' + name + ')')
        }
      }
    } catch (e) {
      this.appendLog('name-' + testNo + ' 抛出异常: ' + JSON.stringify(e))
      this.appendLog('  ✗ FAIL')
    }
  }

  testNameExtensions(): void {
    this.appendLog('name-1900 通用扩展名测试 START')
    const exts =
      ['txt', 'pdf', 'docx', 'xlsx', 'jpg', 'png', 'mp3', 'mp4', 'zip', 'exe', 'html', 'cpp', 'py', 'json', 'log']
    let allPass = true
    for (let ext of exts) {
      let path = TEST_DIR_PATH + '/test.' + ext
      try {
        let fileUriObject = new fileUri.FileUri(path)
        let name = fileUriObject.name
        let expected = 'test.' + ext
        if (name !== expected) {
          allPass = false
          this.appendLog('  ✗ test.' + ext + ' → ' + name + ' (期望: ' + expected + ')')
        }
      } catch (e) {
        allPass = false
        this.appendLog('  ✗ test.' + ext + ' 抛出异常')
        this.appendLog('  ✗ FAIL')
      }
    }
    if (allPass) {
      this.appendLog('name-1900 ✓ PASS (全部' + exts.length + '种扩展名通过)')
    } else {
      this.appendLog('name-1900 ✗ FAIL')
    }
    this.appendLog('name-1900 END')
  }

  testToString(testNo: string, input: string, exp: ExpectedResult): void {
    try {
      let fileUriObject = new fileUri.FileUri(input)
      let res = fileUriObject.toString()
      let expected = this.getExpectedValue(exp)
      this.appendLog('toString-' + testNo + ' input: ' + input)
      this.appendLog('  → result: ' + res)
      if (res === expected) {
        if (expected.length > 230) {
          this.appendLog('  ✓ PASS ')
        } else {
          this.appendLog('  ✓ PASS (期望: ' + expected + ')')
        }
      } else {
        if (expected.length > 230) {
          this.appendLog('  ✗ FAIL ')
        } else {
          this.appendLog('  ✗ FAIL (期望: ' + expected + ', 实际: ' + res + ')')
        }
      }
    } catch (e) {
      this.appendLog('toString-' + testNo + ' 抛出异常: ' + JSON.stringify(e))
      this.appendLog('  ✗ FAIL')
    }
  }

  testGetFullDirectoryUriExistsDir(testNo: string): void {
    let testValue = context.filesDir + '/TestDir11'
    try {
      fs.mkdirSync(testValue)
      let fileUriObject = new fileUri.FileUri(testValue)
      let fullDirectoryUri = fileUriObject.getFullDirectoryUri()
      this.appendLog('getFullDirectoryUri-' + testNo + ' input: ' + testValue)
      this.appendLog('  → result: ' + fullDirectoryUri)
      let expected = this.getExpectedValue(EXP_ARKUIX_FILEURI_GETFULLDIRECTORYURI_0100)
      if (fullDirectoryUri === expected) {
        this.appendLog('  ✓ PASS')
      } else {
        this.appendLog('  ✗ FAIL (期望: ' + expected + ')')
      }
    } catch (e) {
      this.appendLog('getFullDirectoryUri-' + testNo + ' 抛出异常: ' + JSON.stringify(e))
      this.appendLog('  ✗ FAIL')
    } finally {
      fs.rmdirSync(testValue)
    }
  }

  testGetFullDirectoryUriExistsFile(testNo: string): void {
    let testValue = context.filesDir + '/TestDir13' + '/test.txt'
    let testFile: fs.File | undefined = undefined
    try {
      fs.mkdirSync(context.filesDir + '/TestDir13')
      testFile = fs.openSync(testValue, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
      let fileUriObject = new fileUri.FileUri(testValue)
      let fullDirectoryUri = fileUriObject.getFullDirectoryUri()
      this.appendLog('getFullDirectoryUri-' + testNo + ' input: ' + testValue)
      this.appendLog('  → result: ' + fullDirectoryUri)
      let expected = this.getExpectedValue(EXP_ARKUIX_FILEURI_GETFULLDIRECTORYURI_0300)
      if (fullDirectoryUri === expected) {
        this.appendLog('  ✓ PASS')
      } else {
        this.appendLog('  ✗ FAIL (期望: ' + expected + ')')
      }
    } catch (e) {
      this.appendLog('getFullDirectoryUri-' + testNo + ' 抛出异常: ' + JSON.stringify(e))
      this.appendLog('  ✗ FAIL')
    } finally {
      if (testFile != undefined) {
        fs.closeSync(testFile)
      }
      fs.unlinkSync(testValue)
      fs.rmdirSync(context.filesDir + '/TestDir13')
    }
  }

  testExpectError(testNo: string, input: string, method: string): void {
    this.appendLog(method + '-' + testNo + ' 期望异常测试 input: ' + input)
    try {
      let fileUriObject = new fileUri.FileUri(input)
      let result = (method === 'getFullDirectoryUri') ? fileUriObject.getFullDirectoryUri() : ''
      this.appendLog('  → 未抛出异常, result: ' + result + ' ✗ FAIL')
    } catch (e) {
      let errStr = JSON.stringify(e)
      if (errStr.includes('13900002')) {
        this.appendLog('  ✓ PASS, 捕获预期异常 code=13900002')
      } else {
        this.appendLog('  → 异常: ' + errStr)
        this.appendLog('  ✗ FAIL')
      }
    }
  }

  testFileUriFileIO(): void {
    this.appendLog('文件流操作 FileUri I/O 测试 START')
    let context = getContext(this) as common.UIAbilityContext
    const testDirPath = context.filesDir + '/fileioDir'
    const testFilePath = testDirPath + '/fileio.txt'
    const testFileInfo = 'Hello, FileUri! This is a test file for FileUri I/O operations.'
    let testFile: fs.File | undefined = undefined
    let fileUriForTestDirPath: fileUri.FileUri = new fileUri.FileUri('')
    let fileUriForTestFilePath: fileUri.FileUri = new fileUri.FileUri('')

    try {
      fileUriForTestDirPath = new fileUri.FileUri(testDirPath)
      fs.mkdirSync(fileUriForTestDirPath.path)
      this.appendLog('  ✓ 创建目录成功: ' + fileUriForTestDirPath.path)

      fileUriForTestFilePath = new fileUri.FileUri(testFilePath)
      testFile = fs.openSync(fileUriForTestFilePath.path, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)

      let accessResult = fs.accessSync(fileUriForTestFilePath.path)
      this.appendLog('  ✓ 文件存在性检查: ' + accessResult)

      fs.writeSync(testFile.fd, testFileInfo)
      this.appendLog('  ✓ 写入文件成功')

      let readText = fs.readTextSync(fileUriForTestFilePath.path)
      this.appendLog('  ✓ 读取文件: "' + readText + '"')

      if (readText === testFileInfo) {
        this.appendLog('  ✓ PASS (读写内容一致)')
      } else {
        this.appendLog('  ✗ FAIL (内容不匹配)')
      }
    } catch (e) {
      this.appendLog('  ✗ 异常: ' + JSON.stringify(e))
      this.appendLog('  ✗ FAIL')
    } finally {
      if (testFile != undefined) {
        fs.closeSync(testFile)
      }
      fs.unlinkSync(fileUriForTestFilePath.path)
      fs.rmdirSync(fileUriForTestDirPath.path)
    }
    this.appendLog('文件流操作 FileUri I/O 测试 END')
  }
}
