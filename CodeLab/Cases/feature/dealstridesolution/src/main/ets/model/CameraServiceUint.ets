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

import { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from '../common/Constants';
import { camera } from '@kit.CameraKit';
import { image } from '@kit.ImageKit';
import { JSON } from '@kit.ArkTS';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { logger } from '../common/Logger';
import CameraService from './CameraService';

const TAG: string = 'CameraService';

/**
 * 当stride和width相等时，按宽读取buffer不影响结果。
 * 当stride和width不等时，将相机返回的预览流数据即component.byteBuffer的数据去除stride，拷贝得到新的dstArr数据进行数据处理，将处理后的dstArr数组buffer，通过width和height直接创建pixelMap, 并存储到全局变量stridePixel中，传给Image送显。
 */
class CameraServiceUint {
  private cameraManager: camera.CameraManager | undefined = undefined;
  private cameras: Array<camera.CameraDevice> | Array<camera.CameraDevice> = [];
  private cameraInput: camera.CameraInput | undefined = undefined;
  private previewOutput: camera.PreviewOutput | undefined = undefined;
  private session: camera.PhotoSession | camera.VideoSession | undefined = undefined;
  handlePhotoAssetCb: (photoAsset: photoAccessHelper.PhotoAsset) => void = () => {
  };
  private curCameraDevice: camera.CameraDevice | undefined = undefined;
  private receiver: image.ImageReceiver | undefined = undefined;
  frameStartFlag: number = 0;
  // 推荐的预览分辨率之一
  private previewProfileObj: camera.Profile = {
    format: 1003,
    size: {
      width: Constants.X_COMPONENT_SURFACE_WIDTH,
      height: Constants.X_COMPONENT_SURFACE_HEIGHT
    }
  };
  surfaceId: string = '';

  onImageArrival(receiver: image.ImageReceiver): void {
    receiver.on('imageArrival', () => {
      receiver.readNextImage((err: BusinessError, nextImage: image.Image) => {
        if (err || nextImage === undefined) {
          logger.error(TAG, `requestPermissionsFromUser call Failed! error: ${err.code}`);
          return;
        }
        if (nextImage) {
          nextImage.getComponent(image.ComponentType.JPEG,
            async (err, component: image.Component) => {
              let width = 1920; // width为应用创建预览流分辨率对应的宽
              let height = 1080; // height为应用创建预览流分辨率对应的高
              let stride = component.rowStride; // 通过component.rowStride获取stride
              logger.info(TAG, `receiver getComponent width:${width} height:${height} stride:${stride}`);
              // 当图片的width等于相机预览流返回的行跨距stride，此时无需处理stride，通过width和height直接创建pixelMap,并存储到全局变量stridePixel中，传给Image送显。
              if (stride === width) {
                let pixelMap = await image.createPixelMap(component.byteBuffer, {
                  size: { height: height, width: width },
                  srcPixelFormat: image.PixelMapFormat.NV21,
                })
                AppStorage.setOrCreate('stridePixel', pixelMap);
              } else {
                // 当图片的width不等于相机预览流返回的行跨距stride，此时将相机返回的预览流数据component.byteBuffer去除掉stride，拷贝得到新的dstArr数据，数据处理后传给其他不支持stride的接口处理。
                const dstBufferSize = width * height * 1.5; // 创建一个width * height * 1.5的dstBufferSize空间，此处为NV21数据格式。
                const dstArr = new Uint8Array(dstBufferSize); // 存放去掉stride后的buffer。
                // 读取每行数据，相机支持的profile宽高均为偶数，不涉及取整问题。
                for (let j = 0; j < height * 1.5; j++) { // 循环dstArr的每一行数据。
                  // 拷贝component.byteBuffer的每行数据前width个字节到dstArr中(去除无效像素，刚好每行得到一个width*height的八字节数组空间)。
                  const srcBuf = new Uint8Array(component.byteBuffer, j * stride,
                    width); // 将component.byteBuffer返回的buffer，每行遍历，从首位开始，每行截取出width字节。
                  dstArr.set(srcBuf, j * width); // 将width*height大小的数据存储到dstArr中。
                }
                let pixelMap = await image.createPixelMap(dstArr.buffer, {
                  // 将处理后的dstArr数组buffer，通过width和height直接创建pixelMap,并存储到全局变量stridePixel中，传给Image送显。
                  size: { height: height, width: width },
                  srcPixelFormat: image.PixelMapFormat.NV21,
                })
                AppStorage.setOrCreate('stridePixel', pixelMap);
              }
              nextImage.release();
            })
        }
      });
    })
  }

  getPreviewProfile(cameraOutputCapability: camera.CameraOutputCapability): camera.Profile | undefined {
    let previewProfiles = cameraOutputCapability.previewProfiles;
    if (previewProfiles.length < 1) {
      return undefined;
    }
    let index = previewProfiles.findIndex((previewProfile: camera.Profile) => {
      return previewProfile.size.width === this.previewProfileObj.size.width &&
        previewProfile.size.height === this.previewProfileObj.size.height &&
        previewProfile.format === this.previewProfileObj.format;
    });
    if (index === -1) {
      return undefined;
    }
    return previewProfiles[index];
  }

  /**
   * 初始化相机功能
   * @param cameraDeviceIndex - 相机设备索引
   * @returns 无返回值
   */
  async initCamera(cameraDeviceIndex: number): Promise<void> {
    logger.debug(TAG, `initCamera cameraDeviceIndex: ${cameraDeviceIndex}`);
    try {
      await this.releaseCamera();
      // 获取相机管理器实例
      this.cameraManager = CameraService.getCameraManagerFn();
      if (this.cameraManager === undefined) {
        logger.error(TAG, 'cameraManager is undefined');
        return;
      }
      this.cameras = CameraService.getSupportedCamerasFn(this.cameraManager);
      this.curCameraDevice = this.cameras[cameraDeviceIndex];
      if (this.curCameraDevice === undefined) {
        logger.error(TAG, 'Failed to create the camera input.');
        return;
      }
      // 创建cameraInput输出对象
      this.cameraInput = CameraService.createCameraInputFn(this.cameraManager, this.curCameraDevice);
      if (this.cameraInput === undefined) {
        logger.error(TAG, 'Failed to create the camera input.');
        return;
      }
      // 打开相机
      let isOpenSuccess = await CameraService.cameraInputOpenFn(this.cameraInput);
      if (!isOpenSuccess) {
        logger.error(TAG, 'Failed to open the camera.');
        return;
      }

      // 选择具有不同的stride和width
      let previewProfile: camera.Profile = {
        format: camera.CameraFormat.CAMERA_FORMAT_YUV_420_SP,
        size: {
          width: Constants.X_COMPONENT_SURFACE_WIDTH,
          height: Constants.X_COMPONENT_SURFACE_HEIGHT
        }
      };

      let size: image.Size = {
        width: Constants.X_COMPONENT_SURFACE_WIDTH,
        height: Constants.X_COMPONENT_SURFACE_HEIGHT
      }
      this.receiver = image.createImageReceiver(size, image.ImageFormat.JPEG, 8);
      let surfaceId: string = await this.receiver.getReceivingSurfaceId();
      this.previewOutput = CameraService.createPreviewOutputFn(this.cameraManager, previewProfile, surfaceId);
      this.onImageArrival(this.receiver);

      if (this.previewOutput === undefined) {
        logger.error(TAG, 'Failed to create the preview stream.');
        return;
      }

      // 会话流
      await this.sessionFlowFn(this.cameraManager, this.cameraInput, this.previewOutput);
    } catch (error) {
      logger.error(TAG, `initCamera fail: ${JSON.stringify(error)}`);
    }
  }

  getPreviewRotation() {
    let previewRotation: camera.ImageRotation | undefined = camera.ImageRotation.ROTATION_0;
    previewRotation = this.previewOutput?.getPreviewRotation(previewRotation);
    AppStorage.set('previewRotation', previewRotation);
  }

  /**
   * 释放会话和相关参数
   */
  async releaseCamera(): Promise<void> {
    logger.info(TAG, 'releaseCamera is called');
    try {
      await this.receiver?.release();
    } catch (err) {
      logger.error(TAG, `imageReceiver release fail: error: ${JSON.stringify(err)}`);
    }
    try {
      await this.previewOutput?.release();
    } catch (err) {
      logger.error(TAG, `previewOutput release fail: error: ${JSON.stringify(err)}`);
    } finally {
      this.previewOutput = undefined;
    }
    try {
      await this.session?.release();
    } catch (err) {
      logger.error(TAG, `captureSession release fail: error: ${JSON.stringify(err)}`);
    } finally {
      this.session = undefined;
    }
    try {
      await this.cameraInput?.close();
    } catch (err) {
      logger.error(TAG, `cameraInput close fail: error: ${JSON.stringify(err)}`);
    } finally {
      this.cameraInput = undefined;
    }
    logger.info(TAG, 'releaseCamera success');
  }

  /**
   * 会话流
   */
  async sessionFlowFn(cameraManager: camera.CameraManager, cameraInput: camera.CameraInput,
    previewOutput: camera.PreviewOutput | undefined): Promise<void> {
    try {
      // 创建CaptureSession实例
      this.session = cameraManager.createSession(camera.SceneMode.NORMAL_PHOTO) as camera.PhotoSession;
      this.session.beginConfig();
      this.session.addInput(cameraInput);
      this.session.addOutput(previewOutput);
      this.getPreviewRotation();
      await this.session.commitConfig();
      await this.session.start();
      logger.info(TAG, 'sessionFlowFn success');
    } catch (error) {
      logger.error(TAG, `sessionFlowFn fail : ${JSON.stringify(error)}`);
    }
  }
}

export default new CameraServiceUint();