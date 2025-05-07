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

export class HelperConstants {
  static readonly ANIMATION_DURATION: number = 300;
  static readonly HELPER_URL_PROTOTYPE: string =
    "https://gitee.com/harmonyos-cases/cases/blob/master/CommonAppDevelopment/feature/{placeholder}/README.md";
  static readonly HELPER_URL_PROTOTYPE_PERFERMANCE: string =
    "https://gitee.com/harmonyos-cases/cases/blob/master/CommonAppDevelopment/feature/perfermance/{placeholder}/README.md";
  static readonly HELPER_URL_HOME: string = "https://gitee.com/harmonyos-cases/cases/blob/master/README.md";
  static readonly IDE_PLUGIN_URL: string = "https://gitee.com/harmonyos-cases/cases/blob/master/plugin/README.md";
  /*
   * 网络PDF文件路径，其中“#toolbar=0”屏蔽Web组件的工具栏
   * */
  static readonly REMOTE_URL: string =
    'https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/webpdfviewer/src/main/resources/rawfile/sample.pdf#toolbar=0';
}