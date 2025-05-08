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

import { interactiveLiveness } from '@kit.VisionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';

const promptActionDuration: number = 2000;

export class StartFacialRecognition {
  /**
   * 校验CAMERA权限,跳转人脸活体验证控件
   * @param routerOptions 活体检测参数
   * @param permissionArr 权限列表
   */
  public static privateStartDetection(routerOptions: interactiveLiveness.InteractiveLivenessConfig,
    permissionArr: Array<Permissions>) {
    let context = getContext();
    // 向用户申请权限，此处为相机权限
    abilityAccessCtrl.createAtManager().requestPermissionsFromUser(context, permissionArr).then((res) => {
      for (let i = 0; i < res.permissions.length; i++) {
        if (res.permissions[i] === 'ohos.permission.CAMERA' && res.authResults[i] === 0) {
          // 拉起活体检测
          interactiveLiveness.startLivenessDetection(routerOptions).then((DetectState: boolean) => {
          })
        }
      }
    })
  }

  /**
   * 获取活体检测结果
   * @returns
   */
  public static getDetectionResultInfo() {
    // getInteractiveLivenessResult接口调用完会释放资源
    let resultInfo = interactiveLiveness.getInteractiveLivenessResult();
    const promise: Promise<interactiveLiveness.InteractiveLivenessResult> = new Promise((resolve, reject) => {
      resultInfo.then(async (data) => {
        if (data.mPixelMap !== undefined) {
          promptAction.showToast({
            message: $r('app.string.start_decrypt_success_text'),
            duration: promptActionDuration
          });
          resolve(data);
        } else {
          promptAction.showToast({
            message: $r('app.string.start_decrypt_error_text'),
            duration: promptActionDuration
          });
        }
      }).catch((err: BusinessError) => {
        // 检测算法初始化，表示接口调用成功，无数据状态。停留在当前页面，不做跳转处理
        if (err.code !== 1008302000) {
          promptAction.showToast({
            message: err.message + '，请重试',
            duration: promptActionDuration
          });
        }
        reject(err);
      })
    })
    return promise;
  }
}