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

// 图片属性的modifier类，便于用户扩展image相关的属性
export class ImageModifier implements AttributeModifier<ImageAttribute> {
  private imageFit: ImageFit = ImageFit.Fill;
  private imageRenderMode: ImageRenderMode = ImageRenderMode.Original;

  constructor() {
  }

  applyNormalAttribute(instance: ImageAttribute): void {
    instance.objectFit(this.imageFit);
    instance.renderMode(this.imageRenderMode);
  }

  objectFit(fit: ImageFit): ImageModifier {
    this.imageFit = fit;
    return this;
  }

  renderMode(mode: ImageRenderMode): ImageModifier {
    this.imageRenderMode = mode;
    return this;
  }
}
