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

@Entry
@Component
struct Index {
  // 跳转到图片格式选择器页面
  navigateToImageFormatSelector() {
    this.getUIContext().getRouter().pushUrl({
      url: 'pages/PixelMapDrawableDescriptor_1',
      params: {}
    }).then(() => {
      console.log('跳转到PixelMapDrawableDescriptor_1页面');
    }).catch((err: Error) => {
      console.error('跳转失败:', err);
    });
  }

  // 跳转到LayeredDrawable测试页面
  navigateToLayeredDrawableTest() {
    this.getUIContext().getRouter().pushUrl({
      url: 'pages/LayeredDrawableDescriptor_2',
      params: {}
    }).then(() => {
      console.log('跳转到LayeredDrawableDescriptor_2页面');
    }).catch((err: Error) => {
      console.error('跳转失败:', err);
    });
  }

  // 跳转到动画Drawable测试页面
  navigateToAnimatedDrawableTest() {
    this.getUIContext().getRouter().pushUrl({
      url: 'pages/AnimatedDrawableDescriptor_3',
      params: {}
    }).then(() => {
      console.log('跳转到动画AnimatedDrawableDescriptor_3页面');
    }).catch((err: Error) => {
      console.error('跳转失败:', err);
    });
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          Button('PixelMapDrawableDescriptor')
            .width('80%')
            .height(50)
            .fontSize(18)
            .fontColor(Color.White)
            .backgroundColor(Color.Blue)
            .borderRadius(10)
            .onClick(() => {
              this.navigateToImageFormatSelector();
            })
            .margin({ bottom: 15 })

          // 跳转按钮2 - LayeredDrawable测试
          Button('LayeredDrawableDescriptor')
            .width('80%')
            .height(50)
            .fontSize(18)
            .fontColor(Color.White)
            .backgroundColor(Color.Green)
            .borderRadius(10)
            .onClick(() => {
              this.navigateToLayeredDrawableTest();
            })
            .margin({ bottom: 15 })

          // 跳转按钮3 - 动画Drawable测试
          Button('动画Drawable测试')
            .width('80%')
            .height(50)
            .fontSize(18)
            .fontColor(Color.White)
            .backgroundColor(Color.Orange)
            .borderRadius(10)
            .onClick(() => {
              this.navigateToAnimatedDrawableTest();
            })
            .margin({ bottom: 15 })
        }.width('100%')
      }.scrollBar(BarState.Off)
    }.height('100%')
  }
}
