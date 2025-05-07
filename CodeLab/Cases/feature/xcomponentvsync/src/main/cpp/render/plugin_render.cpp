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

#include <cstdint>
#include "common/plugin_common.h"
#include "manager/plugin_manager.h"
#include "render/plugin_render.h"

std::unordered_map<std::string, PluginRender *> PluginRender::instance_;

OH_NativeXComponent_Callback PluginRender::callback_;

// 根据 surfaceID 创建 EGLsurface
void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window) {
    LOGD("PluginRender::OnSurfaceCreatedCB");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    std::string id(idStr);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceCreated(component, window);
}

// 监听 surfaceID 变化，变换 EGLsurface
void OnSurfaceChangedCB(OH_NativeXComponent *component, void *window) {
    LOGD("PluginRender::OnSurfaceChangedCB");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    std::string id(idStr);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceChanged(component, window);
}

// 监听 surfaceID 销毁，销毁 EGLsurface
void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window) {
    LOGD("PluginRender::OnSurfaceDestroyedCB");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    std::string id(idStr);
    auto render = PluginRender::GetInstance(id);
    render->OnSurfaceDestroyed(component, window);
}

PluginRender::PluginRender(std::string &id) : id_(id) {
    eglCore_ = new EGLCore(id);
    if (eglCore_ != nullptr) {
        LOGI("PluginRender::new EGLCore success.");
    } else {
        LOGE("PluginRender::new EGLCore fail!");
    }
    auto renderCallback = PluginRender::GetNXComponentCallback();
    renderCallback->OnSurfaceCreated = OnSurfaceCreatedCB;
    renderCallback->OnSurfaceChanged = OnSurfaceChangedCB;
    renderCallback->OnSurfaceDestroyed = OnSurfaceDestroyedCB;
}

PluginRender *PluginRender::GetInstance(std::string &id) {
    if (instance_.find(id) == instance_.end()) {
        LOGI("PluginRender::PluginRender::GetInstance new id: [%{public}s]", &id);
        PluginRender *instance = new PluginRender(id);
        instance_[id] = instance;
        return instance;
    } else {
        LOGI("PluginRender::PluginRender::GetInstance old id:[%{public}s]", &id);
        return instance_[id];
    }
}

OH_NativeXComponent_Callback *PluginRender::GetNXComponentCallback() { return &PluginRender::callback_; }

void PluginRender::SetNativeXComponent(OH_NativeXComponent *component) {
    OH_NativeXComponent_RegisterCallback(component, &PluginRender::callback_);
}

void PluginRender::OnSurfaceCreated(OH_NativeXComponent *component, void *window) {
    LOGD("PluginRender::OnSurfaceCreated");
    int32_t ret = OH_NativeXComponent_GetXComponentSize(component, window, &width_, &height_);
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS && nullptr != eglCore_) {
        eglCore_->OnSurfaceCreated(window, width_, height_);
    }
}

void PluginRender::OnSurfaceChanged(OH_NativeXComponent *component, void *window) {
    LOGD("PluginRender::OnSurfaceChanged");
    int32_t ret = OH_NativeXComponent_GetXComponentSize(component, window, &width_, &height_);
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS && nullptr != eglCore_) {
        eglCore_->OnSurfaceChanged(window, width_, height_);
    }
}

void PluginRender::OnSurfaceDestroyed(OH_NativeXComponent *component, void *window) {
    LOGW("PluginRender::OnSurfaceDestroyed begin");
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    int32_t ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS && nullptr != eglCore_) {
        eglCore_->OnSurfaceDestroyed();
    }
    std::lock_guard<std::mutex> lock(eglCore_->mtx);
    if (nullptr != eglCore_) {
        delete eglCore_;
        eglCore_ = nullptr;
    }
    if (nullptr != instance_[id_]) {
        delete instance_[id_];
        instance_[id_] = nullptr;
        instance_.erase(id_);
    }
    LOGW("PluginRender::OnSurfaceDestroyed end");
}