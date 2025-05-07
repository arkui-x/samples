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

export class Constants {
  /**
   * XComponent的宽度
   */
  static readonly X_COMPONENT_SURFACE_WIDTH = 1920; // 1920*1080 stride->1920
  /**
   * XComponent的高度
   */
  static readonly X_COMPONENT_SURFACE_HEIGHT = 1080;
  /**
   * image+cropSync方案说明
   */
  static readonly CROP_SYNC_DES = '应用通过image.ImageReceiver注册imageArrival图像回调方法，获取每帧图像数据实例image.Image，创建pixelMap，使用getComponent获取rowStride值。通过在Image中传入变量PixelMap进行数据刷新，图片送显。当分辨率的width和rowStride相等时按宽读取buffer。当rowStride和width不等时，如果应用想使用byteBuffer预览流数据创建pixelMap直接显示，可以根据rowStride*height字节的大小先创建pixelMap，然后调用PixelMap的cropSync方法裁剪掉多余的像素，从而正确处理rowStride，解决预览流花屏问题。';
  /**
   * image+cropSync方案说明
   */
  static readonly UINT_ARRAY_DES = '应用通过image.ImageReceiver注册imageArrival图像回调方法，获取每帧图像数据实例image.Image，创建pixelMap，使用getComponent获取rowStride值。通过在Image中传入变量PixelMap进行数据刷新，图片送显。当分辨率的width和rowStride相等时按宽读取buffer。当rowStride和width不等时，将相机返回的预览流数据即component.byteBuffer的数据去除stride，拷贝得到新的数据进行数据处理，将处理后的数组buffer，通过width和height直接创建pixelMap, 并存储到全局变量pixelMap中，传给Image送显。';
  /**
   * image+cropSync方案说明
   */
  static readonly X_COMPONENT_DES = '在初始相机模块时，使用getXComponentSurfaceId获取XComponent对应Surface的ID，调用使用camera中的createPreviewOutput创建预览输出对象，图片送显。';
};