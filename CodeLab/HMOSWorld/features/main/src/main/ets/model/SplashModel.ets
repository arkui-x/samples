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

interface ISplash {
  day: Resource[];
  dusk: Resource[];
  night: Resource[];
}

export const SplashImages: ISplash = {
  day: [
    $r('app.media.ic_splash1'),
    $r('app.media.ic_splash2'),
    $r('app.media.ic_splash3')
  ],
  dusk: [
    $r('app.media.ic_splash4'),
    $r('app.media.ic_splash5'),
    $r('app.media.ic_splash6')
  ],
  night: [
    $r('app.media.ic_splash7'),
    $r('app.media.ic_splash8'),
    $r('app.media.ic_splash9')
  ]
}