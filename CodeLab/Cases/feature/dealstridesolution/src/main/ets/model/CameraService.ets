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

import { Constants } from '../common/Constants';
import { camera } from '@kit.CameraKit';
import { image } from '@kit.ImageKit';
import { JSON } from '@kit.ArkTS';
import { logger } from '../common/Logger';

const TAG: string = 'CameraService';

/**
 * 1.获取相机管理器实例
 * 2.使用createCameraInput创建输出对象
 * 3.打开相机
 * 4.创建previewOutput输出对象
 */
class CameraService {
  private cameraManager: camera.CameraManager | undefined = undefined;
  private cameras: Array<camera.CameraDevice> | Array<camera.CameraDevice> = [];
  private cameraInput: camera.CameraInput | undefined = undefined;
  private previewOutput: camera.PreviewOutput | undefined = undefined;
  private session: camera.PhotoSession | camera.VideoSession | undefined = undefined;
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

  /**
   * 初始化相机功能
   * @param cameraDeviceIndex - 相机设备索引
   * @returns 无返回值
   */
  async initCamera(cameraDeviceIndex: number, xComponentSurfaceId: string): Promise<void> {
    logger.debug(TAG, `initCamera cameraDeviceIndex: ${cameraDeviceIndex}`);
    try {
      await this.releaseCamera();
      // 获取相机管理器实例
      this.cameraManager = this.getCameraManagerFn();
      if (this.cameraManager === undefined) {
        logger.error(TAG, 'cameraManager is undefined');
        return;
      }
      this.cameras = this.getSupportedCamerasFn(this.cameraManager);
      this.curCameraDevice = this.cameras[cameraDeviceIndex];
      if (this.curCameraDevice === undefined) {
        logger.error(TAG, 'Failed to create the camera input.');
        return;
      }
      // 创建cameraInput输出对象
      this.cameraInput = this.createCameraInputFn(this.cameraManager, this.curCameraDevice);
      if (this.cameraInput === undefined) {
        logger.error(TAG, 'Failed to create the camera input.');
        return;
      }
      // 打开相机
      let isOpenSuccess = await this.cameraInputOpenFn(this.cameraInput);
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
      this.previewOutput = this.createPreviewOutputFn(this.cameraManager, previewProfile, xComponentSurfaceId);
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
   * 获取相机管理器实例
   */
  getCameraManagerFn(): camera.CameraManager | undefined {
    if (this.cameraManager) {
      return this.cameraManager;
    }
    let cameraManager: camera.CameraManager | undefined = undefined;
    try {
      cameraManager = camera.getCameraManager(getContext(this));
      logger.info(TAG, `getCameraManager success: ${cameraManager}`);
    } catch (error) {
      logger.error(TAG, `getCameraManager failed: ${JSON.stringify(error)}`);
    }
    return cameraManager;
  }

  /**
   * 获取支持指定的摄像机设备对象
   */
  getSupportedCamerasFn(cameraManager: camera.CameraManager): Array<camera.CameraDevice> {
    let supportedCameras: Array<camera.CameraDevice> = [];
    try {
      supportedCameras = cameraManager.getSupportedCameras();
      logger.info(TAG, `getSupportedCameras success: ${this.cameras}, length: ${this.cameras?.length}`);
    } catch (error) {
      logger.error(TAG, `getSupportedCameras failed: ${JSON.stringify(error)}`);
    }
    return supportedCameras;
  }

  /**
   * 创建cameraInput输出对象
   */
  createCameraInputFn(cameraManager: camera.CameraManager,
    cameraDevice: camera.CameraDevice): camera.CameraInput | undefined {
    logger.info(TAG, 'createCameraInputFn is called.');
    let cameraInput: camera.CameraInput | undefined = undefined;
    try {
      cameraInput = cameraManager.createCameraInput(cameraDevice);
      logger.info(TAG, 'createCameraInputFn success');
    } catch (error) {
      logger.error(TAG, `createCameraInputFn failed: ${JSON.stringify(error)}`);
    }
    return cameraInput;
  }

  /**
   * 创建previewOutput输出对象
   */
  createPreviewOutputFn(cameraManager: camera.CameraManager, previewProfileObj: camera.Profile,
    surfaceId: string): camera.PreviewOutput | undefined {
    let previewOutput: camera.PreviewOutput | undefined = undefined;
    try {
      previewOutput = cameraManager.createPreviewOutput(previewProfileObj, surfaceId);
      logger.info(TAG, `createPreviewOutput success: ${previewOutput}`);
    } catch (error) {
      logger.error(TAG, `createPreviewOutput failed: ${JSON.stringify(error)}`);
    }
    return previewOutput;
  }

  /**
   * 打开相机
   */
  async cameraInputOpenFn(cameraInput: camera.CameraInput): Promise<boolean> {
    let isOpenSuccess = false;
    try {
      await cameraInput.open();
      isOpenSuccess = true;
      logger.info(TAG, 'cameraInput open success');
    } catch (error) {
      logger.error(TAG, `createCameraInput failed : ${JSON.stringify(error)}`);
    }
    return isOpenSuccess;
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
      await this.session.commitConfig();
      await this.session.start();
      logger.info(TAG, 'sessionFlowFn success');
    } catch (error) {
      logger.error(TAG, `sessionFlowFn fail : ${JSON.stringify(error)}`);
    }
  }
}

export default new CameraService();