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
import { SideslipIntercept } from "./components/mainpage/MainPage";
import { AppRouter, DynamicsRouter } from 'routermodule';


@AppRouter({ name: "sideslipintercept/SideslipInterceptComponent" })
@Component
export struct SideslipInterceptComponent {

  build() {
    SideslipIntercept({ callBack: () => DynamicsRouter.popAppRouter() })
      .height($r("app.string.sideslipintercept_one_hundred_percent"))
      .width($r("app.string.sideslipintercept_one_hundred_percent"))
  }
}