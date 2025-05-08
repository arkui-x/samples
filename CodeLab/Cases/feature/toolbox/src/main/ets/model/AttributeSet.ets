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
import { CustomAnimation } from "./CustomAnimation";
import { CustomParams } from "./CustomParams";

/**
 * 工具项属性集
 *
 */
@Observed
export class AttributeSet {

  // 动效参数属性集
  private animation_?: CustomAnimation;
  // 静态参数属性集
  private params_?: CustomParams;

  constructor(animation?: CustomAnimation, params?: CustomParams) {
    this.animation_ = animation;
    this.params_ = params;
  }

  get animation(): CustomAnimation | undefined {
    return this.animation_;
  }

  set animation(animation: CustomAnimation | undefined) {
    this.animation_ = animation;
  }

  get params(): CustomParams | undefined {
    return this.params_;
  }
}