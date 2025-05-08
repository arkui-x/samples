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
import { AppRouter } from "routermodule";
import { CustomCalendarSamplePage } from "./pages/CustomCalendarSample";

@AppRouter({ name: "calendarswitch/CustomCalendarSample" })
@Component
export struct CustomCalendarSample {
  // 是否作为插件使用标志位。传false用于适配折叠屏全屏状态cases工程分段按钮。CustomCalendarSamplePage不传参或传true用于插件化。
  private isPlugin: boolean = false;
  build() {
    CustomCalendarSamplePage({ isPlugin: this.isPlugin });
  }
}