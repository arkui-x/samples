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

#ifndef _PLUGIN_RENDER_H_
#define _PLUGIN_RENDER_H_

#include <string>
#include <unordered_map>

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <napi/native_api.h>

#include "egl_core_shader.h"

class PluginRender {
public:
    explicit PluginRender(std::string &id);
    static PluginRender *GetInstance(std::string &id);
    static OH_NativeXComponent_Callback *GetNXComponentCallback();

    void SetNativeXComponent(OH_NativeXComponent *component);

public:
    // Callback, called by ACE XComponent
    void OnSurfaceCreated(OH_NativeXComponent *component, void *window);
    void OnSurfaceChanged(OH_NativeXComponent *component, void *window);
    void OnSurfaceDestroyed(OH_NativeXComponent *component, void *window);
    
public:
    static std::unordered_map<std::string, PluginRender *> instance_;
    static OH_NativeXComponent_Callback callback_;

    // OH_NativeXComponent* component_;
    EGLCore *eglCore_;
    std::string id_;
    uint64_t width_;
    uint64_t height_;

    double x_;
    double y_;
    OH_NativeXComponent_TouchEvent touchEvent_;
};

#endif // _PLUGIN_RENDER_H_
