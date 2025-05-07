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

import { Permissions } from '@kit.AbilityKit';
import { interactiveLiveness } from '@kit.VisionKit';
import { StartFacialRecognition } from '../components/StartFacialFecognition'
import { image } from '@kit.ImageKit';
import { arrayBufferToBase64, encryptMessagePromise } from '../components/Encode';
import { promptAction } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';
import { AppRouter } from 'routermodule';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { BusinessError } from '@kit.BasicServicesKit';

interface userInformation {
  title: string
  content: string
}

/**
 * 实现步骤
 * 活体检测：
 * 1.调用视觉服务API（VisionKit）的interactiveLiveness.startLivenessDetection实现活体检测功能
 * 2.调用视觉服务API（VisionKit）的interactiveLiveness.getInteractiveLivenessResult获取活体检测结果和图片数据
 * 加解密：
 * 1.活体检测获取到的图片数据通过image的packing接口压缩获取到图片的arraybuffer或者输入的string文字
 * 2.通过cipher实例对数据进行AES对称加解密返回Uint8Array类型的数据
 */
const promptActionDuration: number = 2000;

@AppRouter({ name: 'livedetectionandencryptiond/LiveDetectionAndEncryptionPage' })
@Component
export struct LiveDetectionAndEncryptionPage {
  @State uploadContent: string = ''; // 模拟接收上传的数据
  @State identifyIsShow: boolean = false;
  @State actionNumberValue: string = '3';
  @State isSilentMode: string = 'INTERACTIVE_MODE'; // 活体检测模式默认值
  @State routeMode: string = 'back'; // 活体检测完成后返回模式
  @State userInformationData: userInformation[] =
    [{ title: '证件类型', content: '居民身份证' }, { title: '证件号', content: '1****************0' },
      { title: '手机号', content: '181****8676' }, { title: '姓名', content: '王**' }];
  private array: Array<Permissions> = ['ohos.permission.CAMERA']; // 相机权限
  @State timeoutId: number = 1;

  // 每次页面显示查询活体检测结果，未进行活体检测imageData值为undefined不处理
  aboutToAppear() {
    this.timeoutId = setInterval(() => {
      // TODO: 活体检测窗口打开及关闭时不会触发自定义组件生命周期函数，所以此处需要使用定时器轮询检测结果
      this.getDetectionResult();
    }, 500);
  }

  aboutToDisappear(): void {
    // 页面销毁时关闭定时器
    clearInterval(this.timeoutId);
  }

  getDetectionResult() {
    StartFacialRecognition.getDetectionResultInfo().then((data: interactiveLiveness.InteractiveLivenessResult) => {
      if (data.mPixelMap !== undefined) {
        const imagePackerApi = image.createImagePacker();
        let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 60 };
        imagePackerApi.packing(data.mPixelMap, packOpts).then(async (data: ArrayBuffer) => {
          // data 为打包获取到的文件流，写入文件保存即可得到一张图片
          this.encodeAndUpload(arrayBufferToBase64(data));
        })
        promptAction.showToast({
          message: $r('app.string.decryption_image_prompt_action_success_message'),
          duration: promptActionDuration
        });
      } else {
        promptAction.showToast({
          message: $r('app.string.decryption_image_prompt_action_fail_message'),
          duration: promptActionDuration
        });
      }
      // 数据获取成功后关闭定时器
      clearInterval(this.timeoutId);
    })
      .catch((error: BusinessError) => {
        if (error.code !== 1008302000) {
          clearInterval(this.timeoutId);
        }
      })
  }

  /**
   * 模拟加密上传
   * @param encodeData 加密和上传的数据
   */
  encodeAndUpload(encodeData: string) {
    encryptMessagePromise(encodeData, cryptoFramework.CryptoMode.ENCRYPT_MODE)
      .then((res) => {
        let base = new util.Base64Helper();
        // 获取到的uint8array转换成字符串
        this.uploadContent = base.encodeToStringSync(res);
      })
  }

  // 人脸认证协议确认弹窗
  @Builder
  identifyPatterns() {
    Column({ space: 20 }) {
      Text($r('app.string.encryption_bind_sheet_title'))
        .fontSize($r('app.integer.identifyPatterns_title_font_size'))
        .fontWeight(FontWeight.Bold)
      Text() {
        Span($r('app.string.facial_recognition_bind_sheet_text1'))
          .fontColor(Color.Black)
        Span($r('app.string.facial_recognition_bind_sheet_text2'))
          .fontColor(Color.Blue)
          .padding({
            left: $r('app.integer.identifyPatterns_title_text_padding'),
            right: $r('app.integer.identifyPatterns_title_text_padding')
          })
        Span($r('app.string.facial_recognition_bind_sheet_text3'))
          .fontColor(Color.Black)
      }
      .margin({ top: $r('app.integer.identifyPatterns_title_margin_top') })
      .fontWeight(FontWeight.Medium)

      Button($r('app.string.facial_recognition_bind_sheet_agree'))
        .width('100%')
        .height($r('app.integer.identifyPatterns_title_margin_top'))
        .margin({ top: $r('app.integer.identifyPatterns_title_margin_top') })
        .onClick(() => {
          this.identifyIsShow = false;
          // 活体检测启动参数
          let routerOptions: interactiveLiveness.InteractiveLivenessConfig = {
            isSilentMode: this.isSilentMode as interactiveLiveness.DetectionMode,
            routeMode: this.routeMode as interactiveLiveness.RouteRedirectionMode,
            actionsNum: parseFloat(this.actionNumberValue.toString())
          };
          StartFacialRecognition.privateStartDetection(routerOptions, this.array);
        })
      Button($r('app.string.facial_recognition_bind_sheet_disagree'))
        .fontColor(Color.Black)
        .backgroundColor(Color.White)
        .border({ width: 1, color: Color.Gray })
        .width('100%')
        .height($r('app.integer.identifyPatterns_title_margin_top'))
        .onClick(() => {
          this.identifyIsShow = false;
        })
    }
    .alignItems(HorizontalAlign.Start)
    .margin({ top: $r('app.integer.identifyPatterns_margin_top') })
    .padding({
      left: $r('app.integer.identifyPatterns_title_font_size'),
      right: $r('app.integer.identifyPatterns_title_font_size')
    })
  }

  @Builder
  userInformationItem(data: userInformation) {
    Column({ space: 16 }) {
      Text(data.title)
        .fontSize($r('app.integer.userInformationItem_title_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .opacity(0.6)
      Text(data.content)
        .fontSize($r('app.integer.userInformationItem_content_text_font_size'))
        .fontWeight(FontWeight.Medium)
        .opacity(0.6)
      Divider()
        .color(Color.Black)
        .opacity(0.5)
    }
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      Text($r('app.string.facial_recognition_page_title'))
        .fontSize($r('app.integer.identifyPatterns_title_font_size'))
        .fontWeight(FontWeight.Bold)

      Column({ space: 14 }) {
        ForEach(this.userInformationData, (item: userInformation) => {
          this.userInformationItem(item)
        })
      }
      .margin({ top: $r('app.integer.identifyPatterns_margin_top') })

      Button($r('app.string.facial_recognition_login'))
        .width('100%')
        .height($r('app.integer.identifyPatterns_title_margin_top'))
        .margin({ top: $r('app.integer.identifyPatterns_title_font_size') })
        .bindSheet(this.identifyIsShow, this.identifyPatterns(), {
          height: '100%',
          onDisappear: () => {
            this.identifyIsShow = false;
          }
        })
        .onClick(() => {
          this.identifyIsShow = true;
          this.timeoutId = setInterval(() => {
            // TODO: 活体检测窗口打开及关闭时不会触发自定义组件生命周期函数，所以此处需要使用定时器轮询检测结果
            this.getDetectionResult();
          }, 500);
        })
    }
    .padding($r('app.integer.identifyPatterns_title_font_size'))
    .alignItems(HorizontalAlign.Start)
    .height('100%')
    .width('100%')
  }
}