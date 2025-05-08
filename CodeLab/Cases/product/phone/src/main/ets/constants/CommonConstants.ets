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

export class CommonConstants {
  // 资源异常枚举
  static readonly RESOURCE_CONTROL: number = 7;
  // 网络PDF文件路径，其中“#toolbar=0”屏蔽Web组件的工具栏
  static readonly REMOTE_URL: string =
    'https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/webpdfviewer/src/main/resources/rawfile/sample.pdf#toolbar=0';
  // 启动页"跳过"按键靠近右侧屏幕距离
  static readonly OFFSET_RIGHT_LEN: number = 320;
  // 首页组件文本：隐私协议
  static readonly PRIVACY_AGREEMENT: string = '隐私协议';
  // 首页组件文本：用户协议
  static readonly USER_AGREEMENT: string = '用户协议';
  // 首页分享按钮链接
  static readonly AGC_APP_LINK: string = "https://appgallery.huawei.com/app/detail?id=com.north.cases";
  // 隐私协议 URL
  static readonly PRIVACY_AGREEMENT_WEB_URL: string = 'http://113.44.157.14/privacy-agreement/';
  // 用户协议 URL
  static readonly USER_AGREEMENT_WEB_URL: string = 'http://113.44.157.14/user-agreement/';
  // cases仓README文件地址
  static readonly CASE_URL: string = 'https://gitee.com/harmonyos-cases/cases/raw/master/README.md';
}