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

import { promptAction } from '@kit.ArkUI';

/**
 * 对未实现对应功能的UI进行提示
 * @param msg toast进行提示的信息，如果不传，则使用配置的默认值
 */
export function notImplementPrompt(msg?: string) {
  promptAction.showToast({ message: msg ?? $r("app.string.stepper_not_implement_prompt") });
}