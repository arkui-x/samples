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

import { AppRouter } from 'routermodule';
import { ClickAnimationSamplePage } from './views/ClickAnimationSamplePage';

@AppRouter({ name: 'clickanimation/ClickAnimationPage' })
@Component
export struct ClickAnimationPage {
  build() {
    ClickAnimationSamplePage()
      .height($r('app.string.click_animation_full_size'))
      .width($r('app.string.click_animation_full_size'))
  }
}