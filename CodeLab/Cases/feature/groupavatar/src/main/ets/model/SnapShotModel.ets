/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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


import { componentSnapshot } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';

interface SnapShotType {
  setComponentId: (componentId: string) => void;
  getSnapShot: () => void;
  getComponentId: () => void;
}

/**
 * 组件截图类
 */
export class SnapShotModel implements SnapShotType {
  private componentId: string = 'avatar_group';

  /**
   * 设置id
   *
   * @param {string} componentId - 组件id
   */
  setComponentId(componentId: string) {
    this.componentId = componentId;
  }

  /**
   * 获取组件截图
   * @param {boolean} [scale] - 指定截图时图形侧绘制pixelmap的缩放比例，比例过大时截图时间会变长，或者截图可能会失败。
   * @param {boolean} [waitUntilRenderFinished] - 指定是否强制等待系统执行截图指令前所有绘制指令都执行完成之后再截图
   * @returns {image.PixelMap} 组件截图图片数据
   */
  getSnapShot(scale: number = 1, waitUntilRenderFinished?: boolean): image.PixelMap {
    let snapshotOptions: componentSnapshot.SnapshotOptions = {
      scale,
      waitUntilRenderFinished
    }
    return componentSnapshot.getSync(this.componentId, snapshotOptions);
  }

  /**
   * 获取组件Id
   * @returns {string} 组件id值
   */
  getComponentId() {
    return this.componentId;
  }
}