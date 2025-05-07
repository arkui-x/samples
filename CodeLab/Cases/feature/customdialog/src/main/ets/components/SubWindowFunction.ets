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

import window from '@ohos.window';
import * as api  from './SubWindowApi';
import { common } from '@kit.AbilityKit';
import { PlatformInfo } from 'utils';

const context = getContext(this) as common.UIAbilityContext; // 获取当前页面的上下文
let sumResource: string = ''; // 初始化弹窗加载数据

try {
  // 获取指定resource对象对应的字符串
  sumResource = context.resourceManager.getStringSync($r('app.string.custom_dialog_sum2').id);
} catch (err) {
  console.error(`getStringSync failed, code is ${err.code}, message is ${err.message}`);
}

export interface Data {
  subWindowStage: window.WindowStage | null; // 初始化subWindowStage
}

/**
 * 创建并展示弹窗
 * @param { api.SubWindowApi | null } SubWindowApi - SubWindowApi对象
 * @param { window.WindowStage | undefined } windowStage - WindowStage对象
 */
export function showApiSubWindow(SubWindowApi: api.SubWindowApi | null, windowStage: window.WindowStage | undefined) {
  if (PlatformInfo.isArkUIX()) {
    SubWindowApi?.hideSubWindow();
  }
  SubWindowApi?.initSubWindow({ windowStage: windowStage as window.WindowStage }, {
    sum: sumResource
  });
}

/**
 * 隐藏弹窗
 * @param { api.SubWindowApi | null } SubWindowApi - SubWindowApi对象
 */
export function hideApiSubWindow(SubWindowApi: api.SubWindowApi | null) {
  SubWindowApi?.hideSubWindow();
}

