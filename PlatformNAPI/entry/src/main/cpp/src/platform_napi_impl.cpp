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

#include "platform_napi_impl.h"

#include <iostream>
#include "native_common.h"
#include "platform_napi_jni.h"

std::unique_ptr<PlatformNAPI> PlatformNAPI::Create()
{
    // Create
    return std::make_unique<PlatformNAPIImpl>();
}

std::string PlatformNAPIImpl::GetDeviceBrand()
{
    std::string res = PlatformNAPIJni::GetDeviceBrand();
    return res;
}

std::string PlatformNAPIImpl::GetProductModel()
{
    std::string res = PlatformNAPIJni::GetProductModel();
    return res;
}