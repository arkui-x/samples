/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { mediaquery } from '@kit.ArkUI';
import { BreakpointConstants } from '../constants/BreakpointConstants';

declare interface BreakPointTypeOption<T> {
  sm: T
  md: T
  lg: T
}

export class BreakPointType<T> {
  options: BreakPointTypeOption<T>

  constructor(option: BreakPointTypeOption<T>) {
    this.options = option;
  }

  getValue(currentBreakPoint: string): T {
    if (this.options.sm !== undefined && currentBreakPoint === 'sm') {
      return this.options.sm as T;
    }
    if (this.options.md && currentBreakPoint === 'md') {
      return this.options.md as T;
    } else {
      return this.options.lg as T;
    }
  }
}

export class BreakpointSystem {
  private currentBreakpoint: string = '';
  private smListener?: mediaquery.MediaQueryListener;
  private mdListener?: mediaquery.MediaQueryListener;
  private lgListener?: mediaquery.MediaQueryListener;

  private updateCurrentBreakpoint(breakpoint: string) {
    if (this.currentBreakpoint !== breakpoint) {
      this.currentBreakpoint = breakpoint;
      AppStorage.set<string>(BreakpointConstants.CURRENT_BREAKPOINT, this.currentBreakpoint);
    }
  }

  private isBreakpointSM = (mediaQueryResult: mediaquery.MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint(BreakpointConstants.BREAKPOINT_SM);
    }
  }
  private isBreakpointMD = (mediaQueryResult: mediaquery.MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint(BreakpointConstants.BREAKPOINT_MD);
    }
  }
  private isBreakpointLG = (mediaQueryResult: mediaquery.MediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint(BreakpointConstants.BREAKPOINT_LG);
    }
  }

  public register() {
    this.smListener = mediaquery.matchMediaSync(BreakpointConstants.RANGE_SM);
    this.smListener.on('change', this.isBreakpointSM);
    this.mdListener = mediaquery.matchMediaSync(BreakpointConstants.RANGE_MD);
    this.mdListener.on('change', this.isBreakpointMD);
    this.lgListener = mediaquery.matchMediaSync(BreakpointConstants.RANGE_LG);
    this.lgListener.on('change', this.isBreakpointLG);
  }

  public unregister() {
    this.smListener?.off('change', this.isBreakpointSM);
    this.mdListener?.off('change', this.isBreakpointMD);
    this.lgListener?.off('change', this.isBreakpointLG);
  }
}