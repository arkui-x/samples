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
import web_webview from '@ohos.web.webview';

// 自定义浏览器对象
export class Browser {
  inputValue: string = "";
  progress: number = 0;
  isRegistered: boolean = false;
  hideProgress: boolean = true;
  tabsController: TabsController = new TabsController();
  webController: WebviewController = new web_webview.WebviewController();

  // 跳转页面
  loadUrl(addr: string | Resource) {
    if (addr) {
      this.webController.loadUrl(addr);
    }
  }

  // 返回页面
  back(): boolean {
    if (this.webController.accessBackward()) {
      this.webController.backward();
      return true;
    }
    return false;
  }

  // 前进页面
  forward() {
    if (this.webController.accessForward()) {
      this.webController.forward();
    }
  }

  // 刷新页面
  refresh() {
    this.webController.refresh();
  }
}
