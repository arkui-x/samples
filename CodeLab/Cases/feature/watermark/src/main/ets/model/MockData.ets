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

import { ImageDataType, VideoDataType, FeatureDataType } from './DataType';

export const ImageData: (ImageDataType | VideoDataType)[] = [
  new ImageDataType('0', $r("app.media.water_mark_image_1")),
  new ImageDataType('1', $r("app.media.water_mark_image_2")),
  new ImageDataType('2', $r("app.media.water_mark_image_3")),
  new ImageDataType('3', $r("app.media.water_mark_image_4")),
  new VideoDataType('4', $r("app.media.water_mark_video_1"))
]

export const FeatureData: FeatureDataType[] = [
  new FeatureDataType($r('app.media.water_mark_camera'), $r('app.string.water_mark_identify_images_text')),
  new FeatureDataType($r('app.media.water_mark_download'), $r('app.string.water_mark_save_text')),
  new FeatureDataType($r('app.media.water_mark_favor'), $r('app.string.water_mark_interested_text'))
]