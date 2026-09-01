/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import common from '@ohos.app.ability.common';
import image from '@ohos.multimedia.image';
import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State message: string = 'Test native api: 2 + 3 = ?';
  @State message2: string = 'Click me';
  @State message3: string = 'NativeUvLoop result';
  @State imagePackerResult: string = 'ImagePacker C-API is ready';

  private getOutputPath(fileName: string): string {
    const context = getContext(this) as common.UIAbilityContext;
    return context.filesDir + '/' + fileName;
  }

  private packRawPixelMap(fileName: string, mimeType: string): void {
    const path = this.getOutputPath(fileName);
    const code = testNapi.packRawPixelMap(path, mimeType, 90);
    this.imagePackerResult = code === 0 ? 'Saved: ' + path : 'Raw PixelMap failed: ' + code;
  }

  private async packNapiPixelMap(fileName: string, mimeType: string): Promise<void> {
    const pixels = new Uint8Array([
      255, 0, 0, 255,
      0, 255, 0, 255,
      0, 0, 255, 255,
      255, 255, 255, 255
    ]);
    const options: image.InitializationOptions = {
      editable: false,
      pixelFormat: image.PixelMapFormat.RGBA_8888,
      size: { width: 2, height: 2 }
    };
    const pixelMap = await image.createPixelMap(pixels.buffer, options);
    const path = this.getOutputPath(fileName);
    try {
      const code = testNapi.packNapiPixelMap(pixelMap, path, mimeType, 90);
      this.imagePackerResult = code === 0 ? 'Saved: ' + path : 'NAPI PixelMap failed: ' + code;
    } finally {
      await pixelMap.release();
    }
  }

  build() {
    Scroll() {
      Column() {
        Text(this.message)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin(15)
          .onClick(() => {
            this.message = "Test native api: 2 + 3 = " + testNapi.add(2, 3);
            console.log("Test NAPI 2 + 3 = " + testNapi.add(2, 3));
          })
        Text(this.message2)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin(15)
          .onClick(() => {
            this.message2 = testNapi.nativeCallArkTS((a: string) => {
              return a + " world!";
            });
            console.log(this.message2);
          })
        Text(this.message3)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin(15)
        Button('NativeUvLoop execute click me')
          .width('95%')
          .height(50)
          .fontSize(20)
          .margin(20)
          .onClick(() => {
            if (testNapi.nativeUvLoop() == 0) {
              this.message3 = "NativeUvLoop successful"
            } else {
              this.message3 = "NativeUvLoop failed"
            }
            console.log(this.message3);
          })

        Text('ImagePacker Native C-API')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 24, bottom: 8 })
        Row() {
          Button('Raw JPEG')
            .onClick(() => this.packRawPixelMap('raw-pixelmap.jpg', 'image/jpeg'))
          Button('Raw PNG')
            .onClick(() => this.packRawPixelMap('raw-pixelmap.png', 'image/png'))
        }
        .width('95%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .margin(8)
        Row() {
          Button('NAPI JPEG')
            .onClick(() => this.packNapiPixelMap('napi-pixelmap.jpg', 'image/jpeg'))
          Button('NAPI PNG')
            .onClick(() => this.packNapiPixelMap('napi-pixelmap.png', 'image/png'))
        }
        .width('95%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .margin(8)
        Text(this.imagePackerResult)
          .fontSize(16)
          .width('90%')
          .margin(12)
      }
      .width('100%')
    }
    .height('100%')
  }
}
