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

import { Animator, AnimatorResult } from '@kit.ArkUI';
import { DisplaySyncInterface } from '../Interface/DisplaySyncInterface';

export class DisplaySyncArkUIX implements DisplaySyncInterface {
  private static instance: DisplaySyncArkUIX;
  private backAnimator: AnimatorResult | undefined = undefined;

  public static getInstance(): DisplaySyncInterface {
    if (!DisplaySyncArkUIX.instance) {
      DisplaySyncArkUIX.instance = new DisplaySyncArkUIX();
    }
    return DisplaySyncArkUIX.instance;
  }

  public createAnimate(range: ExpectedFrameRateRange, frame: () => void): void {
    this.backAnimator = undefined;
    this.backAnimator = Animator.create({
      duration: 5000,
      easing: "linear",
      delay: 0,
      fill: "forwards",
      direction: "normal",
      iterations: -1,
      begin: 0,
      end: 1
    })
    this.backAnimator.setExpectedFrameRateRange(range);
    this.backAnimator.onFrame = frame;
  }

  public deleteAnimate(frame: () => void): void {
    if (this.backAnimator != undefined) {
      this.backAnimator.cancel();
      this.backAnimator = undefined;
    }
  }

  public startAnimate(): void {
    if (this.backAnimator != undefined) {
      this.backAnimator.play();
    }
  }

  public stopAnimate(): void {
    if (this.backAnimator != undefined) {
      this.backAnimator.pause();
    }
  }
}