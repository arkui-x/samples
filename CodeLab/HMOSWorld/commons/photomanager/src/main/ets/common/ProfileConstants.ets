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

export class ProfileConstants {
  private static instance: ProfileConstants;
  public DISTRIBUTED_PROFILE_PATH: string = '';
  public LOCAL_PROFILE_PATH: string = '';
  public LOCAL_PROFILE_NAME: string = '';

  public static getInstance() {
    if (!ProfileConstants.instance) {
      ProfileConstants.instance = new ProfileConstants();
    }
    return ProfileConstants.instance;
  }

  private constructor() {
    this.DISTRIBUTED_PROFILE_PATH =
      `${getContext().distributedFilesDir}/${AppStorage.get<string>('userId') as string}_profile.jpg`;
    this.LOCAL_PROFILE_PATH =
      `${getContext().filesDir}/${AppStorage.get<string>('userId') as string}_profile.png`;
    this.LOCAL_PROFILE_NAME = `${AppStorage.get<string>('userId') as string}_profile.png`;
  }
}