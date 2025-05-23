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

import web_webview from '@ohos.web.webview';
import { BusinessError } from '@ohos.base';
import { camera, cameraPicker } from '@kit.CameraKit';

/**
 * 功能描述: 本示例介绍如何在HTML页面中拉起原生相机进行拍照，并获取返回的图片
 *
 * 推荐场景: 需要web侧拉起系统相机
 *
 * 核心组件:
 * 1. invokeCamera
 *
 * 实现步骤:
 * 1. 添加Web组件，加载HTML网页
 * 2. 实现invokeCamera接口，拉起相机拍照
 * 3. 对Web组件设置onShowFileSelector属性，处理具有“文件”输入类型的HTML表单，以响应用户按下的“选择文件”按钮
 * 4. 在onShowFileSelector中调用invokeCamera接口，拍照完成后将图片返回到HTML网页
 */
const LOCAL_HTML_PATH: string = "camera.html";

// HTML页面中input标签调用ArkTS方法的返回结果
class FileResult {
  // 用于通知Web组件文件选择的结果
  result: FileSelectorResult;
  // 文件选择器的相关信息
  fileSelector: FileSelectorParam;

  constructor(result: FileSelectorResult, fileSelector: FileSelectorParam) {
    this.result = result;
    this.fileSelector = fileSelector;
  }
}

@Component
export struct WebGetCameraImageView {
  controller: web_webview.WebviewController = new web_webview.WebviewController();

  build() {
    // TODO：知识点：Web组件通过onShowFileSelector接口，处理具有“文件”输入类型的HTML表单，响应用户按下的“选择文件”按钮，并通过event对象，将选择的图片/文件路径返回给input标签中onchange属性调用的js方法。onShowFileSelector接口的用法，可参考官方文档 https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-web-0000001774281246#ZH-CN_TOPIC_0000001774281246__onshowfileselector9
    Web({ src: $rawfile(LOCAL_HTML_PATH), controller: this.controller })
      .onShowFileSelector((event: FileResult) => { // event表示文件选择事件，其中result可以存储选择的图片/文件片路径，fileSelector可以设置文件选择器的部分属性
        // 调用invokeCamera接口，拉起原生相机进行拍照，并将照片路径放到uri中返回
        this.invokeCamera(((uri: string) => {
          // 将照片路径uri放到一个数组中，通过系统接口handleFileList将图片/文件的选择结果通知给Web组件，可参考官方文档 https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-web-0000001774281246#ZH-CN_TOPIC_0000001774281246__handlefilelist9
          event?.result.handleFileList([uri]);
        }))
        // 当返回值为true时，用户可以调用系统提供的弹窗能力。当回调返回false时，绘制的自定义弹窗无效。
        return true;
      })
  }

  /**
   * 调用系统相机，拍照后返回图片地址
   *
   * @param callback 回调接口，返回照片的路径
   */
  async invokeCamera(callback: (uri: string) => void) {
    try {
      let pickerProfile: cameraPicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      let pickerResult: cameraPicker.PickerResult = await cameraPicker.pick(getContext(),
        [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO], pickerProfile);
      console.log("the pick pickerResult is:" + JSON.stringify(pickerResult));
      if (callback && pickerResult) {
        callback(pickerResult.resultUri);
      }
    } catch (error) {
      let err = error as BusinessError;
      console.error(`the pick call failed. error code: ${err.code}`);
    }
  }
}