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

// auto-generated
import { DynamicsRouter, AppRouterInfo } from 'routermodule/Index';
import { MainPage } from '../pages/MainPage'
import { ReusePage } from '../pages/ReusePage'
import { ReuseFramePage } from '../pages/ReuseFramePage'

@Builder
function mainPageBuilder() {
  MainPage();
}

export function mainPageRegister(routerInfo: AppRouterInfo) {
  DynamicsRouter.registerAppRouterPage(routerInfo, wrapBuilder(mainPageBuilder));
}

@Builder
function reusePageBuilder() {
  ReusePage();
}

export function reusePageRegister(routerInfo: AppRouterInfo) {
  DynamicsRouter.registerAppRouterPage(routerInfo, wrapBuilder(reusePageBuilder));
}

@Builder
function reuseFramePageBuilder() {
  ReuseFramePage();
}

export function reuseFramePageRegister(routerInfo: AppRouterInfo) {
  DynamicsRouter.registerAppRouterPage(routerInfo, wrapBuilder(reuseFramePageBuilder));
}

