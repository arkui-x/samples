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

import { logger } from '../common/Logger';
import CameraService from '../model/CameraService';

const BORDER_WIDTH = 0.5; // 边框宽度

/**
 * 功能描述：
 * 1.使用XComponent构建每一帧图片渲染的场景，从而形成相机效果
 * 2.切换组件时清除不可见的页面信息，重新进入组件时重新进入相机
 *
 * 实现原理：
 * 1.在初始相机模块时，使用getXComponentSurfaceId获取XComponent对应Surface的ID，调用createPreviewOutput创建预览输出对象，图片送显。
 *
 * @param {XComponentController} xComponentCtl - 构建XComponent组件的控制器（必需）
 * @param {string} xComponentSurfaceId - XComponent对应Surface的ID（必需）
 * @param {number} imageWidth - 渲染相机的宽度（必需）
 * @param {number} imageHeight - 渲染相机的高度（必需）
 * @param {number} cameraDeviceIndex - 相机设备索引（必需）
 */
@Component
export struct XComponentView {
  private xComponentCtl: XComponentController = new XComponentController(); // 构建XComponent组件的控制器
  private xComponentSurfaceId: string = ''; // XComponent对应Surface的ID
  @State imageWidth: number = 1920; // 渲染相机的宽度
  @State imageHeight: number = 1080; // 渲染相机的高度
  @State cameraDeviceIndex: number = 0; // 相机设备索引

  aboutToAppear(): void {
    if (this.xComponentSurfaceId !== '') {
      CameraService.initCamera(this.cameraDeviceIndex, this.xComponentSurfaceId);
    }
  }

  aboutToDisappear(): void {
    CameraService.releaseCamera();
  }

  build() {
    Stack() {
      XComponent({
        type: XComponentType.SURFACE,
        controller: this.xComponentCtl
      })
        .onLoad(async () => {
          logger.info('onLoad is called');
          this.xComponentSurfaceId = this.xComponentCtl.getXComponentSurfaceId(); // 获取组件surfaceId
          // 初始化相机，组件实时渲染每帧预览流数据
          CameraService.initCamera(this.cameraDeviceIndex, this.xComponentSurfaceId);
        })
        .zIndex(0)
    }
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, _currentRation: number) => {
      if (isVisible) {
        CameraService.initCamera(this.cameraDeviceIndex, this.xComponentSurfaceId);
      } else {
        CameraService.releaseCamera();
      }
    })
    .width(px2vp(this.imageHeight))
    .height(px2vp(this.imageWidth))
  }
}

// 页面共享组件
@Component
export struct PublishView {
  @Prop imageWidth: number;
  @Prop imageHeight: number;
  @Prop isShow: boolean;
  private gridArray: String[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8'];

  build() {
    Column() {
      if (!this.isShow) {
        Grid() {
          ForEach(this.gridArray, (day: string) => {
            GridItem() {
            }
            .borderWidth(BORDER_WIDTH)
            .borderColor(Color.White)
            .width($r('app.string.deal_stride_solution_all_percentage'))
            .height($r('app.string.deal_stride_solution_all_percentage'))
          }, (day: string) => day)
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr')
      }
    }
    .width(px2vp(this.imageHeight))
    .height(px2vp(this.imageWidth))
  }
}