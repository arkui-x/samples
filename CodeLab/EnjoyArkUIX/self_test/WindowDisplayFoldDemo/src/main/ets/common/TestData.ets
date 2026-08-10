/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
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

export class ExpectedResult {
  public resultForOH: string
  public resultForAndroid: string
  public resultForiOS: string

  constructor(oh: string, android: string, ios: string) {
    this.resultForOH = oh
    this.resultForAndroid = android
    this.resultForiOS = ios
  }
}

export interface ButtonScheme {
  bgColor: ResourceColor
  fontColor: ResourceColor
}

export const buttonSchemes: ButtonScheme[] = [
  {
    bgColor: 'rgb(149,162,255)',
    fontColor: 'rgba(8, 8, 10, 1.00)'
  },
  {
    bgColor: 'rgb(255,182,193)',
    fontColor: 'rgba(8, 8, 10, 1.00)'
  },
  {
    bgColor: 'rgb(102,217,187)',
    fontColor: 'rgba(8, 8, 10, 1.00)'
  },
  {
    bgColor: 'rgb(148,179,211)',
    fontColor: 'rgba(8, 8, 10, 1.00)'
  },
  {
    bgColor: 'rgb(135,206,235)',
    fontColor: 'rgba(8, 8, 10, 1.00)'
  }
]
