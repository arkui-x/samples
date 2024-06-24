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

#ifndef PlatformNAPI_platform_napi_H
#define PlatformNAPI_platform_napi_H

#include <iostream>

class PlatformNAPI {
public:
    PlatformNAPI() = default;
    virtual ~PlatformNAPI() = default;

    static std::unique_ptr<PlatformNAPI> Create();

    virtual std::string GetDeviceBrand() = 0;
    virtual std::string GetProductModel() = 0;
};

#endif // PlatformNAPI_platform_napi_H
