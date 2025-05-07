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
import { CustomAnimation } from "../model/CustomAnimation";

/**
 * 自定义动效参数集
 *
 */
@Observed
export class VisibleAnimation extends CustomAnimation{
  // 工具项可见属性
  private visible_: Visibility;

  constructor(visible: Visibility = Visibility.Hidden) {
    super();
    this.visible_ = visible;
  }

  get visible(): Visibility {
    return this.visible_;
  }

  set visible(visible: Visibility) {
    this.visible_ = visible;
  }
}