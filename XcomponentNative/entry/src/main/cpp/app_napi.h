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

#ifndef APP_NAPI_H_
#define APP_NAPI_H_

#include <string>
#include <unordered_map>

#include "ace/xcomponent/native_interface_xcomponent.h"
#include "ace/xcomponent/native_xcomponent_key_event.h"
#include <napi/native_api.h>
#include "render_surface.h"

#define CIRCUMFERENCE_DEGREE   360
struct OH_NativeXComponent_KeyEvent {
    OH_NativeXComponent_KeyAction action = OH_NativeXComponent_KeyAction::OH_NATIVEXCOMPONENT_KEY_ACTION_UNKNOWN;
    OH_NativeXComponent_KeyCode code = OH_NativeXComponent_KeyCode::KEY_UNKNOWN;
    OH_NativeXComponent_EventSourceType sourceType =
        OH_NativeXComponent_EventSourceType::OH_NATIVEXCOMPONENT_SOURCE_TYPE_UNKNOWN;
    int64_t deviceId {};
    int64_t timestamp {};
};
class AppNapi {
public:
    explicit AppNapi(std::string& id);
    static AppNapi* GetInstance(std::string& id);
    static OH_NativeXComponent_Callback* GetNXComponentCallback();
    static OH_NativeXComponent_MouseEvent_Callback* GetNXComponentMouseEventCallback();
    void SetNativeXComponent(OH_NativeXComponent* component);

public:
    napi_value Export(napi_env env, napi_value exports);

    static napi_value UpdateAngle(napi_env env, napi_callback_info info);
    static napi_value UpdateForceWithCallBack(napi_env env, napi_callback_info info);
    static napi_value Quit(napi_env env, napi_callback_info info);

    static napi_value GetXComponentId(napi_env env, napi_callback_info info);
    static napi_value GetXComponentSize_Height(napi_env env, napi_callback_info info);
    static napi_value GetXComponentSize_Width(napi_env env, napi_callback_info info);
    static napi_value GetXComponentOffset_x(napi_env env, napi_callback_info info);
    static napi_value GetXComponentOffset_y(napi_env env, napi_callback_info info);
    static napi_value GetXComponent_TouchEvent(napi_env env, napi_callback_info info);
    static napi_value GetXComponent_MouseEvent(napi_env env, napi_callback_info info);
    static napi_value GetXComponent_GetKeyEvent(napi_env env, napi_callback_info info);
    static napi_value GetXComponentpointtool_tiltx(napi_env env, napi_callback_info info);
    static napi_value GetXComponentpointtool_tilty(napi_env env, napi_callback_info info);
    static napi_value GetXComponentpointtool_type(napi_env env, napi_callback_info info);
    static napi_value GetXComponent_RegisterMouseEventCallback(napi_env env, napi_callback_info info);

    static napi_value SetExpectedFrameRateRange(napi_env env, napi_callback_info info);
    static napi_value BeginFrameRateCallback(napi_env env, napi_callback_info info);
    static napi_value EndFrameRateCallback(napi_env env, napi_callback_info info);


    void OnSurfaceCreated(OH_NativeXComponent* component, void* window);
    void OnSurfaceChanged(OH_NativeXComponent* component, void* window);
    void OnSurfaceDestroyed(OH_NativeXComponent* component, void* window);
    void DispatchTouchEvent(OH_NativeXComponent* component, void* window);
    void DispatchMouseEvent(OH_NativeXComponent* component, void* window);
    void DispatchHoverEvent(OH_NativeXComponent* component, bool isHover);
    void DispatchKeyEvent(OH_NativeXComponent* component, void* window);

public:
    static std::unordered_map<std::string, AppNapi*> instance_;
    static OH_NativeXComponent_Callback callback_;
    static uint32_t isCreated_;
    static uint32_t xcHeight_;
    static uint32_t xcWidth_;
    static uint32_t toolType_;
    static float tiltX_;
    static float tiltY_;
    static int32_t hPointSize_;
    static OH_NativeXComponent_HistoricalPoint* hPoints_;
    static uint32_t mousecallback_;
    static double off_x;
    static double off_y;
    static uint32_t touchType;
    static OH_NativeXComponent_TouchEvent testTouchEvent_;
    static OH_NativeXComponent_MouseEvent testMouseEvent_;
    static OH_NativeXComponent_KeyEvent *testKeyEvent_;
    static OH_NativeXComponent_MouseEvent_Callback mouseEventcallback_;
    static bool isHover_;
    
    static std::string touchInfo_;
    static std::string keyEventInfo_;
    static std::string keyEventGetInfo_;
    static std::string keyMouseEventInfo_;

    OH_NativeXComponent* component_;
    std::string id_;
    uint64_t width_ = 0;
    uint64_t height_ = 0;

    float angleX_ = 30.0;
    float angleY_ = 45.0;
    double x_ = 0;
    double y_ = 0;
    OH_NativeXComponent_TouchEvent touchEvent_;
    OH_NativeXComponent_MouseEvent mouseEvent_;
    OH_NativeXComponent_KeyEvent *keyEvent_;
};

#endif // APP_NAPI_H_
