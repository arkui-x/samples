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
import { VideoTrimmer } from '../FeatureComponent'
import { VideoDetail } from '../pages/VideoDetail'
import { VideoUpload } from '../pages/VideoUpload'

@Builder
function videoTrimmerBuilder() {
  VideoTrimmer();
}

export function videoTrimmerRegister(routerInfo: AppRouterInfo) {
  DynamicsRouter.registerAppRouterPage(routerInfo, wrapBuilder(videoTrimmerBuilder));
}

@Builder
function videoDetailBuilder(param: ESObject) {
  VideoDetail();
}

export function videoDetailRegister(routerInfo: AppRouterInfo) {
  DynamicsRouter.registerAppRouterPage(routerInfo, wrapBuilder(videoDetailBuilder));
}

@Builder
function videoUploadBuilder(param: ESObject) {
  VideoUpload();
}

export function videoUploadRegister(routerInfo: AppRouterInfo) {
  DynamicsRouter.registerAppRouterPage(routerInfo, wrapBuilder(videoUploadBuilder));
}

