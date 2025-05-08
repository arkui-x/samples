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

export default class BleConstants {
  // 特定服务（service）的 UUID
  public static readonly UUID_SERVICE_HEART_RATE = '0000180D-0000-1000-8000-00805F9B34FB';
  // 特定特征（characteristic）的 UUID
  public static readonly UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT = '00002A37-0000-1000-8000-00805F9B34FB';
  // 描述符（descriptor）的 UUID 2902一般用于notification或者indication
  public static readonly UUID_DESCRIPTOR_HEART_RATE = '00002902-0000-1000-8000-00805F9B34FB';
}