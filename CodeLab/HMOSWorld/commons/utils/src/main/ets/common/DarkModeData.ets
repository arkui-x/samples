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

@Observed
export class DarkModeSettingsConfig {
  // Value: - 1: Not set, 0: On all day, 1: On at scheduled time.
  switchType: DarkModeType = DarkModeType.FOLLOW_UP;
  startTime: Date = new Date();
  endTime: Date = new Date();

  constructor() {
    let startDate = new Date();
    let endDate = new Date(startDate);
    startDate.setHours(22);
    startDate.setMinutes(0);
    this.startTime = startDate;
    endDate.setHours(7);
    endDate.setMinutes(30);
    this.endTime = endDate;
  }
}

export enum DarkModeType {
  FOLLOW_UP = -1,
  ALL_DAY = 0,
  TIMED = 1,
}