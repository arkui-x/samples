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
#include "mock.h"

void Mock::DocumentSelectThenFn(std::list<std::string> value)
{
    for (auto it = value.begin(); it != value.end(); it++) {
    }
}

void Mock::DocumentSelectCatchFn(EtsWrapper::BusinessError error)
{
}

napi_value Mock::MockDocumentViewPickerSelectJSThread(napi_env env, napi_callback_info info)
{
    int32_t three = 3;
    EtsWrapper::DocumentSelectOptions options{};
    options.maxSelectNumber = three;
    EtsWrapper::DocumentViewPickerSelect(options, DocumentSelectThenFn, DocumentSelectCatchFn);
    return nullptr;
}

napi_value Mock::MockDocumentViewPickerSelectPThread(napi_env env, napi_callback_info info)
{
    std::thread otherThread(MockDocumentViewPickerSelectJSThread, env, info);
    otherThread.detach(); // 这里必须detach，不能join，这与js的线程模型相关
    return nullptr;
}