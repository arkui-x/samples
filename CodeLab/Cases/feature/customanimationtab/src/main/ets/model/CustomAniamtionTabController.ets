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
 * 自定义动效tab控制器，控制自定义动效Tab组件进行页签切换
 *
 */
export class CustomAnimationTabController extends SwiperController {
  // 状态监听器
  private listener: (state: number) => void = (state: number) => {
  };

  public changeIndex(index: number, useAnimation?: boolean | SwiperAnimationMode): void {
    this.listener(1);
    super.changeIndex(index, useAnimation);
  }

  public setListener(func: (state: number) => void) {
    this.listener = func;
  }
}