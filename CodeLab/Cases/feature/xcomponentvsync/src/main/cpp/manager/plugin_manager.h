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

#ifndef PLUGIN_MANAGER_H_
#define PLUGIN_MANAGER_H_

#include <string>
#include <unordered_map>

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <napi/native_api.h>
#include <uv.h>

#include "common/native_common.h"
#include "render/plugin_render.h"

class PluginManager {
public:
    ~PluginManager() {}

    static PluginManager *GetInstance() { return &PluginManager::manager_; }
    void SetNativeXComponent(std::string &id, OH_NativeXComponent *nativeXComponent);
    PluginRender *GetRender(std::string &id);

    bool Export(napi_env env, napi_value exports);
    napi_env mainEnv_ = nullptr;
    uv_loop_t *mainLoop_ = nullptr;
    uv_async_t mainOnMessageSignal_{};

private:
    static void MainOnMessage(const uv_async_t *req);
    static PluginManager manager_;

    std::string id_;
    std::unordered_map<std::string, OH_NativeXComponent *> nativeXComponentMap_;
    std::unordered_map<std::string, PluginRender *> pluginRenderMap_;
};

#endif // PLUGIN_MANAGER_H_