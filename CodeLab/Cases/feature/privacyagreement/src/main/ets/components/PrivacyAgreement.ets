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

import { webview } from '@kit.ArkWeb';

interface agreementData {
  name: string
  uri: string
}

const agreementDataArr: agreementData[] = [{
  name: '隐私协议',
  uri: 'http://113.44.157.14/privacy-agreement/'
}, {
  name: '用户协议',
  uri: 'http://113.44.157.14/user-agreement/'
}];

/**
 * 功能描述：本示例主要介绍使用web组件实现隐私协议与用户协议的展示
 *
 * 推荐场景：应用中协议展示
 *
 * 核心组件
 * 1.web 加载协议html
 *
 * 实现步骤
 * 1.通过AppStorage获取点击的按钮是用户协议还是隐私协议
 * 2.根据AppStorage获取的值匹配对应网址赋值给webUri在web组件中加载
 */
@Component
export struct PrivacyAgreement {
  @State webUri: string = '';
  webController: WebviewController = new webview.WebviewController();

  aboutToAppear(): void {
    let titleName: string | undefined = AppStorage.get('agreementTitle');
    for (let i = 0; i < agreementDataArr.length; i++) {
      if (agreementDataArr[i].name === titleName) {
        this.webUri = agreementDataArr[i].uri;
      }
    }
  }

  build() {
    Column() {
      Web({ src: this.webUri, controller: this.webController })
        .width('100%')
        .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}
