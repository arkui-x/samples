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

import { displaySync } from '@kit.ArkGraphics2D';
import { DisplaySyncInterface } from '../Interface/DisplaySyncInterface';

export class DisplaySyncLocal implements DisplaySyncInterface {
  private static instance: DisplaySyncLocal;
  private backDisplaySyncSlow: displaySync.DisplaySync | undefined = undefined;

  public static getInstance(): DisplaySyncInterface {
    if (!DisplaySyncLocal.instance) {
      DisplaySyncLocal.instance = new DisplaySyncLocal();
    }
    return DisplaySyncLocal.instance;
  }

  public createAnimate(range: ExpectedFrameRateRange, frame: () => void): void {
    this.backDisplaySyncSlow = undefined;
    this.backDisplaySyncSlow = displaySync.create();
    this.backDisplaySyncSlow.setExpectedFrameRateRange(range);
    this.backDisplaySyncSlow.on('frame', frame);
  }

  public deleteAnimate(frame: () => void): void {
    if (this.backDisplaySyncSlow != undefined) {
      this.backDisplaySyncSlow?.off('frame', frame);
      this.backDisplaySyncSlow = undefined;
    }
  }

  public startAnimate(): void {
    if (this.backDisplaySyncSlow != undefined) {
      this.backDisplaySyncSlow?.start();
    }
  }

  public stopAnimate(): void {
    if (this.backDisplaySyncSlow != undefined) {
      this.backDisplaySyncSlow?.stop();
    }
  }
}