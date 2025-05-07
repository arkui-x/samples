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

/**
 * 轮播项信息
 * @param imageSrc: 图片路径（必传参数）
 * @param name: 轮播图标题名称
 * @param appUri: 功能模块地址
 * @param param: 跳转参数
 */
export class SwiperData {
  imageSrc: ResourceStr;
  name: ResourceStr;
  appUri: string;
  param: string;

  constructor(imageSrc: ResourceStr, name?: ResourceStr, appUri?: string, param?: string) {
    this.imageSrc = imageSrc;
    this.name = name === undefined ? '' : name;
    this.appUri = appUri === undefined ? '' : appUri;
    this.param = param === undefined ? '' : param;
  }
}

/**
 * 轮播项视图类
 * @param data: 轮播项数据
 * @param contentBuilder: 轮播项视图组件
 */
export class SwiperItemViewType {
  data: SwiperData;
  contentBuilder: WrappedBuilder<[SwiperData]>;

  constructor(data: SwiperData, contentBuilder: WrappedBuilder<[SwiperData]>) {
    this.data = data;
    this.contentBuilder = contentBuilder;
  }
}