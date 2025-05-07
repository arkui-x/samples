/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { image } from '@kit.ImageKit';
import CameraServiceUint from '../model/CameraServiceUint';

/**
 * 功能描述：
 * 1.使用Image构建每一帧图片渲染的场景，从而形成相机效果
 * 2.切换组件时清除不可见的页面信息，重新进入组件时重新进入相机
 *
 * 实现原理：
 * 1.在初始相机模块时，调用onImageArrival()，将处理的width和height作为size，创建PixelMap，通过在Image中传入被@StorageLink修饰的变量stridePixel进行数据刷新，图片送显。
 *
 * @param {boolean} isShowStridePixel - 是否显示拍摄image（必需）
 * @param {image.PixelMap | undefined} stridePixel - 图像像素（必需）
 * @param {number} cameraDeviceIndex - 相机设备索引（必需）
 * @param {number} imageWidth - 渲染相机的宽度（必需）
 * @param {number} imageHeight - 渲染相机的高度（必需）
 * @param {number} previewRotate - 旋转角度（必需）
 */
@Component
export struct ImageViewUint {
  @State isShowStridePixel: boolean = false; // 是否显示拍摄image
  @StorageLink('stridePixel') @Watch('onStridePixel') stridePixel: image.PixelMap | undefined = undefined; // 图像像素
  @State cameraDeviceIndex: number = 0; // 相机设备索引
  @State imageWidth: number = 1920; // 渲染相机的宽度
  @State imageHeight: number = 1080; // 渲染相机的高度
  @StorageLink('previewRotation') previewRotate: number = 0; // 旋转角度

  onStridePixel(): void {
    this.isShowStridePixel = true;
  }

  aboutToDisappear(): void {
    // 销毁组件时清除会话和相关参数
    CameraServiceUint.releaseCamera();
  }

  build() {
    Column() {
      Stack() {
        if (this.isShowStridePixel) {
          Image(this.stridePixel)
            .zIndex(0)
            .rotate({
              z: 0.5,
              angle: this.previewRotate
            })
        }
      }
      .width(px2vp(this.imageWidth))
      .height(px2vp(this.imageHeight))
    }
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, _currentRation: number) => {
      // 切换组件时清除不可见的页面信息，重新进入组件时重新进入相机
      if (isVisible) {
        CameraServiceUint.initCamera(this.cameraDeviceIndex);
      } else {
        CameraServiceUint.releaseCamera();
      }
    })
    .backgroundColor(Color.Black)
    .width($r('app.string.deal_stride_solution_all_percentage'))
    .height($r('app.string.deal_stride_solution_all_percentage'))
    .justifyContent(FlexAlign.Center)
  }
}
