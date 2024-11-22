/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http:/* www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <js_native_api.h>
#include <js_native_api_types.h>

#include <cstdint>
#include <cstdio>

#include "app_napi.h"
#include "log.h"
#include "napi_manager.h"
#include "native_common.h"
#include "render_surface.h"

std::unordered_map<std::string, AppNapi *> AppNapi::instance_;
OH_NativeXComponent_Callback AppNapi::callback_;
static RenderSurface *renderObject_;

static napi_ref callbackRef = NULL;
static napi_env env_ = nullptr;

uint32_t AppNapi::isCreated_ = 0;
uint32_t AppNapi::xcHeight_ = 0;
uint32_t AppNapi::xcWidth_ = 0;
double AppNapi::off_x = 0;
double AppNapi::off_y = 0;
uint32_t AppNapi::toolType_ = 5;
uint32_t AppNapi::mousecallback_ = 0;
float AppNapi::tiltX_ = 0;
float AppNapi::tiltY_ = 0;
uint32_t AppNapi::touchType = 4;
bool AppNapi::isHover_ = false;
OH_NativeXComponent_TouchEvent AppNapi::testTouchEvent_;
OH_NativeXComponent_MouseEvent AppNapi::testMouseEvent_;

std::string AppNapi::touchInfo_;
std::string AppNapi::keyEventInfo_;
std::string AppNapi::keyEventGetInfo_;
std::string AppNapi::keyMouseEventInfo_;

OH_NativeXComponent_KeyEvent *AppNapi::testKeyEvent_ = nullptr;
OH_NativeXComponent_MouseEvent_Callback AppNapi::mouseEventcallback_;
int32_t AppNapi::hPointSize_ = 0;
OH_NativeXComponent_HistoricalPoint *AppNapi::hPoints_ = nullptr;

static int Normalize(int angle)
{
    int ret = angle % CIRCUMFERENCE_DEGREE;
    if (ret < 0) {
        ret += CIRCUMFERENCE_DEGREE;
    }

    return ret;
}

static std::string getKeyName(OH_NativeXComponent_KeyCode keyCode)
{
    switch (keyCode) {
        case KEY_0:
            return "0";
        case KEY_1:
            return "1";
        case KEY_2:
            return "2";
        case KEY_3:
            return "3";
        case KEY_4:
            return "4";
        case KEY_5:
            return "5";
        case KEY_6:
            return "6";
        case KEY_7:
            return "7";
        case KEY_8:
            return "8";
        case KEY_9:
            return "9";
        case KEY_A:
            return "A";
        case KEY_S:
            return "S";
        case KEY_D:
            return "D";
        case KEY_F:
            return "F";
        case KEY_G:
            return "G";
        case KEY_H:
            return "H";
        case KEY_J:
            return "J";
        case KEY_K:
            return "K";
        case KEY_L:
            return "L";
        case KEY_Q:
            return "Q";
        case KEY_W:
            return "W";
        case KEY_E:
            return "E";
        case KEY_R:
            return "R";
        case KEY_T:
            return "T";
        case KEY_Y:
            return "Y";
        case KEY_U:
            return "U";
        case KEY_I:
            return "I";
        case KEY_O:
            return "O";
        case KEY_P:
            return "P";
        case KEY_Z:
            return "Z";
        case KEY_X:
            return "X";
        case KEY_C:
            return "C";
        case KEY_V:
            return "V";
        case KEY_B:
            return "B";
        case KEY_N:
            return "N";
        case KEY_M:
            return "M";
        default:
            return "--";
    }
}

static void ForceCallbackWithValue(bool value)
{
    /*  Check if the callback reference is empty */
    if (callbackRef == NULL || env_ == nullptr) {
        /*  Handling error: No stored callback reference */
        return;
    }

    /*  Retrieve the napi_value of the callback function */
    napi_value callbackFunc;
    napi_get_reference_value(env_, callbackRef, &callbackFunc);

    /*  Construct Boolean parameters */
    napi_value boolValue;
    napi_get_boolean(env_, value, &boolValue);

    /*  Invoke the callback function */
    napi_value argv[] = { boolValue };
    napi_value undefined;
    napi_get_undefined(env_, &undefined);
    napi_call_function(env_, undefined, callbackFunc, 1, argv, NULL);
}

static void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
    LOGE("OnSurfaceCreatedCB");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }

    std::string id(idStr);
    auto instance = AppNapi::GetInstance(id);
    instance->OnSurfaceCreated(component, window);
}

static void OnSurfaceChangedCB(OH_NativeXComponent *component, void *window)
{
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }

    std::string id(idStr);
    auto instance = AppNapi::GetInstance(id);
    instance->OnSurfaceChanged(component, window);
}

static void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }

    std::string id(idStr);
    auto instance = AppNapi::GetInstance(id);
    renderObject_->Quit();
    instance->OnSurfaceDestroyed(component, window);
}

static void DispatchTouchEventCB(OH_NativeXComponent *component, void *window)
{
    LOGE("DispatchTouchEventCB");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    std::string id(idStr);
    auto instance = AppNapi::GetInstance(id);
    instance->DispatchTouchEvent(component, window);
}

static void DispatchMouseEventCB(OH_NativeXComponent *component, void *window)
{
    LOGE("DispatchMouseEventCB");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    std::string id(idStr);
    auto instance = AppNapi::GetInstance(id);
    instance->DispatchMouseEvent(component, window);
}

static void DispatchHoverEventCB(OH_NativeXComponent *component, bool isHover)
{
    LOGE("DispatchHoverEventCB");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    std::string id(idStr);
    auto instance = AppNapi::GetInstance(id);
    instance->DispatchHoverEvent(component, isHover);
}

static void DispatchFocusEventCB(OH_NativeXComponent *component, void *window)
{
    LOGE("DispatchFocusEventCB");
    ForceCallbackWithValue(true);
    LOGE("AppNapi::OH_NativeXComponent_RegisterFocusEventCallback Getting Focus");
}

static void DispatchKeyEventCB(OH_NativeXComponent *component, void *window)
{
    LOGE("DispatchKeyEventCB");
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    ret = OH_NativeXComponent_GetXComponentId(component, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    std::string id(idStr);
    auto instance = AppNapi::GetInstance(id);
    instance->DispatchKeyEvent(component, window);
}

static void DispatchBlurEventCB(OH_NativeXComponent *component, void *window)
{
    LOGE("DispatchBlurEventCB");
    ForceCallbackWithValue(false);
    LOGE("AppNapi::OH_NativeXComponent_RegisterBlurEventCallback Loss of focus");
}

static void DispatchOnFrameCB(OH_NativeXComponent *component, uint64_t timestamp, uint64_t targetTimestamp)
{
    double time_interval_s =
        static_cast<double>(targetTimestamp) / 1000000.0 - static_cast<double>(timestamp) / 1000000.0;
    double fps = 1000.0 / time_interval_s;
    LOGE("AppNapi::OH_NativeXComponent_RegisterOnFrameCallback Frame callback timestamp: %llu, targetTimestamp: %f  "
         "After the calculation, the frame rate is approx: %f",
        timestamp, targetTimestamp / 1000000.0, fps);
}

AppNapi::AppNapi(std::string &id) : id_(id)
{
    component_ = nullptr;
    keyEvent_ = nullptr;
    auto appCallback = AppNapi::GetNXComponentCallback();
    appCallback->OnSurfaceCreated = OnSurfaceCreatedCB;
    appCallback->OnSurfaceChanged = OnSurfaceChangedCB;
    appCallback->OnSurfaceDestroyed = OnSurfaceDestroyedCB;
    appCallback->DispatchTouchEvent = DispatchTouchEventCB;
    auto appMouseEventCallback = AppNapi::GetNXComponentMouseEventCallback();
    appMouseEventCallback->DispatchMouseEvent = DispatchMouseEventCB;
    appMouseEventCallback->DispatchHoverEvent = DispatchHoverEventCB;
    renderObject_ = new RenderSurface(id);
}

AppNapi *AppNapi::GetInstance(std::string &id)
{
    if (instance_.find(id) == instance_.end()) {
        AppNapi *instance = new AppNapi(id);
        instance_[id] = instance;
        return instance;
    } else {
        return instance_[id];
    }
}

OH_NativeXComponent_Callback *AppNapi::GetNXComponentCallback()
{
    return &AppNapi::callback_;
}

OH_NativeXComponent_MouseEvent_Callback *AppNapi::GetNXComponentMouseEventCallback()
{
    return &AppNapi::mouseEventcallback_;
}

void AppNapi::SetNativeXComponent(OH_NativeXComponent *component)
{
    component_ = component;
    auto callback = OH_NativeXComponent_RegisterCallback(component_, &AppNapi::callback_);
    LOGE("AppNapi::OH_NativeXComponent_RegisterCallback, ret:%d", callback);

    auto mousecallback = OH_NativeXComponent_RegisterMouseEventCallback(component_, &AppNapi::mouseEventcallback_);
    mousecallback_ = mousecallback;
    LOGE("AppNapi::OH_NativeXComponent_RegisterMouseEventCallback, ret:%d", mousecallback);

    auto focuscallback = OH_NativeXComponent_RegisterFocusEventCallback(component_, DispatchFocusEventCB);
    LOGE("AppNapi::OH_NativeXComponent_RegisterFocusEventCallback, ret:%d", focuscallback);

    auto keycallback = OH_NativeXComponent_RegisterKeyEventCallback(component_, DispatchKeyEventCB);
    LOGE("AppNapi::OH_NativeXComponent_RegisterKeyEventCallback, ret:%d", keycallback);

    auto blurcallback = OH_NativeXComponent_RegisterBlurEventCallback(component_, DispatchBlurEventCB);
    LOGE("AppNapi::OH_NativeXComponent_RegisterBlurEventCallback, ret:%d", blurcallback);
}

void AppNapi::OnSurfaceCreated(OH_NativeXComponent *component, void *window)
{
    LOGE("AppNapi::OnSurfaceCreated");

    int32_t ret = OH_NativeXComponent_GetXComponentSize(component, window, &width_, &height_);

    LOGE("Offset : x = %{public}f, y = %{public}f ", x_, y_);
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        renderObject_->Init(window, width_, height_);
        renderObject_->Update(angleX_, angleY_);
        isCreated_++;
        xcHeight_ = height_;
        xcWidth_ = width_;

        LOGE("AppNapi::OnSurfaceCreated success ");
    } else {
        LOGE("AppNapi::OnSurfaceCreated failed");
    }
}

void AppNapi::OnSurfaceChanged(OH_NativeXComponent *component, void *window)
{
    LOGE("AppNapi::OnSurfaceChanged success");
    int32_t ret = OH_NativeXComponent_GetXComponentSize(component, window, &width_, &height_);
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        int32_t ret1;
        xcHeight_ = height_;
        xcWidth_ = width_;
        LOGE("after width = %{public}d, height = %{public}d", xcWidth_, xcHeight_);
        ret1 = OH_NativeXComponent_GetXComponentOffset(component, window, &x_, &y_);
        off_x = x_;
        off_y = y_;

        if (ret1 == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
            LOGE("Offset : x = %{public}lf, y = %{public}lf ", off_x, off_y);
        } else {
            LOGE("Offset get failed");
        }

        LOGE("AppNapi::GetOffset ");
        LOGE("Offset : x = %{public}lf, y = %{public}lf ", off_x, off_y);

        renderObject_->UpdateSzie(width_, height_);
    }
}

void AppNapi::OnSurfaceDestroyed(OH_NativeXComponent *component, void *window)
{
    LOGE("AppNapi::OnSurfaceDestroyed success");
    isCreated_--;
    LOGE("AppNapi::OnSurfaceDestroyed iscreated %{public}d", isCreated_);
}

void AppNapi::DispatchTouchEvent(OH_NativeXComponent *component, void *window)
{
    LOGE("AppNapi::DispatchTouchEvent success");
    touchInfo_ = "======= Touch info: ======= \n\n";

    int32_t ret = OH_NativeXComponent_GetTouchEvent(component, window, &touchEvent_);
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        LOGE("AppNapi::OH_NativeXComponent_GetTouchEvent success");
        testTouchEvent_ = touchEvent_;
        touchInfo_ =
            touchInfo_ + "\n\n" + "======= OH_NativeXComponent_TouchEvent: ======= \n\n" + "id : "
            + std::to_string(touchEvent_.id) + "\n" + "screenX : " + std::to_string(touchEvent_.screenX) + "\n"
            + "screenY : " + std::to_string(touchEvent_.screenY) + "\n" + "x : " + std::to_string(touchEvent_.x) + "\n"
            + "y : " + std::to_string(touchEvent_.y) + "\n" + "type : " + std::to_string(touchEvent_.type) + "\n"
            + "size : " + std::to_string(touchEvent_.size) + "\n" + "force : " + std::to_string(touchEvent_.force)
            + "\n" + "deviceId : " + std::to_string(touchEvent_.deviceId) + "\n" + "timeStamp : "
            + std::to_string(touchEvent_.timeStamp) + "\n" + "numPoints : " + std::to_string(touchEvent_.numPoints);

        touchInfo_ = touchInfo_ + "\n\n" + "======= OH_NativeXComponent_TouchPoint: ======= \n\n";
        for (uint32_t i = 0; i < touchEvent_.numPoints; i++) {
            OH_NativeXComponent_TouchPointToolType toolType;
            float tiltX = 123.0;
            float tiltY = 321.0;
            OH_NativeXComponent_GetTouchPointToolType(component, i, &toolType);
            OH_NativeXComponent_GetTouchPointTiltX(component, touchEvent_.touchPoints[i].id, &tiltX);
            OH_NativeXComponent_GetTouchPointTiltY(component, touchEvent_.touchPoints[i].id, &tiltY);
            toolType_ = toolType;
            tiltX_ = tiltX;
            tiltY_ = tiltY;

            touchInfo_ = touchInfo_ + "\n\n" + "id : " + std::to_string(touchEvent_.touchPoints[i].id) + "\n"
                         + "screenX : " + std::to_string(touchEvent_.touchPoints[i].screenX) + "\n"
                         + "screenY : " + std::to_string(touchEvent_.touchPoints[i].screenY) + "\n"
                         + "x : " + std::to_string(touchEvent_.touchPoints[i].x) + "\n"
                         + "y : " + std::to_string(touchEvent_.touchPoints[i].y) + "\n"
                         + "type : " + std::to_string(touchEvent_.touchPoints[i].type) + "\n"
                         + "size : " + std::to_string(touchEvent_.touchPoints[i].size) + "\n"
                         + "force : " + std::to_string(touchEvent_.touchPoints[i].force) + "\n"
                         + "timeStamp : " + std::to_string(touchEvent_.touchPoints[i].timeStamp) + "\n"
                         + "isPressed : " + (touchEvent_.touchPoints[i].isPressed ? "true" : "false") + "\n"
                         + "ToolType : " + std::to_string(toolType_) + "\n" + "TiltX : " + std::to_string(tiltX_)
                         + "\n" + "TiltY : " + std::to_string(tiltY_) + "\n";
        }
        LOGE("%s", touchInfo_.c_str());
    } else {
        LOGE("Touch fail");
    }
}

void AppNapi::DispatchMouseEvent(OH_NativeXComponent *component, void *window)
{
    int32_t ret = OH_NativeXComponent_GetMouseEvent(component, window, &mouseEvent_);
    keyMouseEventInfo_ = "======= MouseEvent info: ======= \n\n";
    LOGE("Mouse Info DispatchMouseEvent");
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        testMouseEvent_ = mouseEvent_;
        LOGE("Mouse Info : x = %{public}f, y = %{public}f screenx = %{public}f, screeny = %{public}f", mouseEvent_.x,
            mouseEvent_.y, mouseEvent_.screenX, mouseEvent_.screenY);
        LOGE("Mouse Info : action = %{public}d, button = %{public}d", mouseEvent_.action, mouseEvent_.button);

        keyMouseEventInfo_ =
            keyMouseEventInfo_ + "\n\n" + "x : " + std::to_string(mouseEvent_.x) + "\n"
            + "y : " + std::to_string(mouseEvent_.y) + "\n" + "screenx : " + std::to_string(mouseEvent_.screenX) + "\n"
            + "screeny : " + std::to_string(mouseEvent_.screenY) + "\n" + "action : "
            + std::to_string(mouseEvent_.action) + "\n" + "button : " + std::to_string(mouseEvent_.button) + "\n";
    } else {
        LOGE("Mouse Info fail");
    }
}

void AppNapi::DispatchHoverEvent(OH_NativeXComponent *component, bool isHover)
{
    LOGE("Mouse Info DispatchHoverEvent");
    LOGE("Mouse Info : isHover = %d", isHover);
    isHover_ = isHover;
}

void AppNapi::DispatchKeyEvent(OH_NativeXComponent *component, void *window)
{
    LOGE("Key Info DispatchKeyEvent");
    int32_t ret = OH_NativeXComponent_GetKeyEvent(component, &keyEvent_);
    if (ret == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        keyEventInfo_ = "======= KeyEvent info: ======= \n\n";
        testKeyEvent_ = keyEvent_;
        LOGE("Key Info : deviceId = %lld, action =%d code = %d, sourceType = %d", keyEvent_->deviceId,
            keyEvent_->action, keyEvent_->code, keyEvent_->sourceType);
        LOGE("Key Info : timestamp = %lld", keyEvent_->timestamp);

        keyEventInfo_ = keyEventInfo_ + "======= OH_NativeXComponent_KeyEven info: ======= \n\n";

        std::string keyName = getKeyName(keyEvent_->code);
        if (keyName != "--") {
            keyEventInfo_ += "The keyboard button was clicked: " + getKeyName(keyEvent_->code) + "\n";
        }

        std::string touchEventStr = "";
        touchEventStr += "deviceId: " + std::to_string(keyEvent_->deviceId) + "\n";
        touchEventStr += "action: " + std::to_string(keyEvent_->action) + "\n";
        touchEventStr += "code: " + std::to_string(keyEvent_->code) + "\n";
        touchEventStr += "sourceType: " + std::to_string(keyEvent_->sourceType) + "\n";
        touchEventStr += "timestamp: " + std::to_string(keyEvent_->timestamp) + "\n";
        keyEventInfo_ = keyEventInfo_ + touchEventStr;

        if (testKeyEvent_) {
            OH_NativeXComponent_KeyAction keyAction;
            OH_NativeXComponent_KeyCode keyCode;
            int64_t keyDeviceId;
            OH_NativeXComponent_EventSourceType sourceType;
            int64_t timestamp;

            OH_NativeXComponent_GetKeyEventAction(testKeyEvent_, &keyAction);
            OH_NativeXComponent_GetKeyEventCode(testKeyEvent_, &keyCode);
            OH_NativeXComponent_GetKeyEventDeviceId(testKeyEvent_, &keyDeviceId);
            OH_NativeXComponent_GetKeyEventSourceType(testKeyEvent_, &sourceType);
            OH_NativeXComponent_GetKeyEventTimestamp(testKeyEvent_, &timestamp);
            LOGE("Key Info getEvent: deviceId = %lld, action = %{public}d code = %{public}d,"
                "sourceType = %{public}d, timestamp = %lld ",
                keyDeviceId, keyAction, keyCode, sourceType, timestamp);

            keyEventGetInfo_ = "======= KeyEvent GetKeyEvent info: ======= \n\n";

            std::string keyName = getKeyName(keyEvent_->code);
            if (keyName != "--") {
                keyEventGetInfo_ += "The keyboard button was clicked: " + getKeyName(keyCode) + "\n";
            }

            keyEventGetInfo_ = keyEventGetInfo_ + "\n\n" + "keyAction : " + std::to_string(keyAction) + "\n"
                               + "keyCode : " + std::to_string(keyCode) + "\n" + "keyDeviceId : "
                               + std::to_string(keyDeviceId) + "\n" + "sourceType : " + std::to_string(sourceType)
                               + "\n" + "timestamp : " + std::to_string(timestamp) + "\n";
        }
    }
    LOGE("%s", keyEventInfo_.c_str());
    LOGE("%s", keyEventGetInfo_.c_str());
}

napi_value AppNapi::UpdateAngle(napi_env env, napi_callback_info info)
{
    LOGE("Update");
    size_t argc = 2;
    int speed = 3;
    napi_value args[2] = { nullptr };

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    double offsetX;
    napi_get_value_double(env, args[0], &offsetX);

    double offsetY;
    napi_get_value_double(env, args[1], &offsetY);

    float renderObject_angleX = renderObject_->GetAngleX();
    float renderObject_angleY = renderObject_->GetAngleY();

    if (offsetY < 0) {
        renderObject_angleX = renderObject_angleX + speed;
    } else {
        renderObject_angleX = renderObject_angleX - speed;
    }

    if (offsetX < 0) {
        renderObject_angleY = renderObject_angleY + speed;
    } else {
        renderObject_angleY = renderObject_angleY - speed;
    }

    renderObject_angleY = Normalize(renderObject_angleY);
    renderObject_angleX = Normalize(renderObject_angleX);

    renderObject_->Update(renderObject_angleX, renderObject_angleY);

    napi_value ret;
    napi_create_array(env, &ret);

    napi_value num;
    napi_create_int32(env, renderObject_angleX, &num);
    napi_set_element(env, ret, 0, num);
    napi_create_int32(env, renderObject_angleY, &num);
    napi_set_element(env, ret, 1, num);

    return ret;
}

napi_value AppNapi::UpdateForceWithCallBack(napi_env env, napi_callback_info info)
{
    env_ = env;
    size_t argc = 1;
    napi_value callbackFunc;
    napi_get_cb_info(env, info, &argc, &callbackFunc, NULL, NULL);
    /* Store a reference value to the callback function */
    napi_create_reference(env, callbackFunc, 1, &callbackRef);
    return nullptr;
}

napi_value AppNapi::Quit(napi_env env, napi_callback_info info)
{
    LOGE("AppNapi -> Quit");
    napi_value exportInstance;
    napi_value thisArg;
    napi_status status;
    OH_NativeXComponent *nativeXComponent = nullptr;

    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;

    renderObject_->Quit();

    NAPI_CALL(env, napi_get_cb_info(env, info, NULL, NULL, &thisArg, NULL));

    status = napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance);
    if (status != napi_ok) {
        return nullptr;
    }

    status = napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent));
    if (status != napi_ok) {
        return nullptr;
    }

    ret = OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return nullptr;
    }

    return 0;
}

napi_value AppNapi::GetXComponentId(napi_env env, napi_callback_info info)
{
    napi_value thisArg;
    napi_status status;
    napi_value exportInstance;
    OH_NativeXComponent *nativeXComponent = nullptr;

    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;

    NAPI_CALL(env, napi_get_cb_info(env, info, NULL, NULL, &thisArg, NULL));
    status = napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance);
    status = napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent));
    ret = OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return nullptr;
    }

    std::string id(idStr);

    napi_value output;
    NAPI_CALL(env, napi_create_string_utf8(env, idStr, id.length(), &output));

    return output;
}

napi_value AppNapi::GetXComponentSize_Height(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::GetXComponentSize_Height");
    napi_value output;
    NAPI_CALL(env, napi_create_uint32(env, xcHeight_, &output));
    LOGE(" GetXComponentSize_Height %{public}d ", xcHeight_);
    return output;
}

napi_value AppNapi::GetXComponentSize_Width(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::GetXComponentSize_Width");
    napi_value output;
    NAPI_CALL(env, napi_create_uint32(env, xcWidth_, &output));
    LOGE(" GetXComponentSize_Width %{public}d ", xcWidth_);
    return output;
}

napi_value AppNapi::GetXComponentOffset_x(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::GetXComponentOffset_x");

    napi_value output;
    NAPI_CALL(env, napi_create_double(env, off_x, &output));
    LOGE("GetXComponentOffset_x : %{public}f", off_x);

    return output;
}

napi_value AppNapi::GetXComponentOffset_y(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::GetXComponentOffset_y");

    napi_value output;
    NAPI_CALL(env, napi_create_double(env, off_y, &output));
    LOGE("GetXComponentOffset_y : %{public}f", off_y);

    return output;
}

napi_value AppNapi::GetXComponentpointtool_tiltx(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::GetXComponentpointtool_tiltx");

    napi_value output;
    NAPI_CALL(env, napi_create_double(env, tiltX_, &output));
    LOGE("GetXComponentpointtool_tiltx : %{public}f", tiltX_);

    return output;
}

napi_value AppNapi::GetXComponentpointtool_tilty(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::GetXComponentpointtool_tilty");

    napi_value output;
    NAPI_CALL(env, napi_create_double(env, tiltY_, &output));
    LOGE("GetXComponentpointtool_tilty : %{public}f", tiltY_);

    return output;
}

napi_value AppNapi::GetXComponentpointtool_type(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::GetXComponentpointtool_type");

    napi_value output;
    NAPI_CALL(env, napi_create_double(env, toolType_, &output));
    LOGE("GetXComponentpointtool_type : %{public}u", toolType_);

    return output;
}

napi_value AppNapi::GetXComponent_TouchEvent(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::GetXComponent_TouchEvent");

    if (touchInfo_.length() == 0) {
        napi_value undefined = nullptr;
        NAPI_CALL(env, napi_get_undefined(env, &undefined));
        return undefined;
    }

    napi_value surf_x;
    napi_value surf_y;
    napi_value t_type;
    napi_value touch_info;

    NAPI_CALL(env, napi_create_double(env, testTouchEvent_.x, &(surf_x)));
    NAPI_CALL(env, napi_create_double(env, testTouchEvent_.y, &(surf_y)));
    NAPI_CALL(env, napi_create_uint32(env, testTouchEvent_.type, &(t_type)));

    const char *pointInfoCStr = touchInfo_.c_str();
    NAPI_CALL(env, napi_create_string_utf8(env, pointInfoCStr, NAPI_AUTO_LENGTH, &touch_info));

    napi_value obj;
    NAPI_CALL(env, napi_create_object(env, &obj));
    NAPI_CALL(env, napi_set_named_property(env, obj, "surface_X", surf_x));
    NAPI_CALL(env, napi_set_named_property(env, obj, "surface_Y", surf_y));
    NAPI_CALL(env, napi_set_named_property(env, obj, "touchType", t_type));
    NAPI_CALL(env, napi_set_named_property(env, obj, "touchInfo", touch_info));

    return obj;
}

napi_value AppNapi::GetXComponent_MouseEvent(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::GetXComponent_MouseEvent");

    if (keyMouseEventInfo_.length() == 0) {
        napi_value undefined = nullptr;
        NAPI_CALL(env, napi_get_undefined(env, &undefined));
        return undefined;
    }

    napi_value surf_x;
    napi_value surf_y;
    napi_value t_button;
    napi_value keyMouseEventInfo;
    napi_value hover;

    NAPI_CALL(env, napi_create_double(env, testMouseEvent_.x, &(surf_x)));
    NAPI_CALL(env, napi_create_double(env, testMouseEvent_.y, &(surf_y)));
    NAPI_CALL(env, napi_create_uint32(env, testMouseEvent_.button, &(t_button)));
    NAPI_CALL(env, napi_create_uint32(env, isHover_, &(hover)));

    const char *keyMouseEventCStr = keyMouseEventInfo_.c_str();
    NAPI_CALL(env, napi_create_string_utf8(env, keyMouseEventCStr, NAPI_AUTO_LENGTH, &keyMouseEventInfo));

    napi_value obj;
    NAPI_CALL(env, napi_create_object(env, &obj));
    NAPI_CALL(env, napi_set_named_property(env, obj, "surface_X1", surf_x));
    NAPI_CALL(env, napi_set_named_property(env, obj, "surface_Y1", surf_y));
    NAPI_CALL(env, napi_set_named_property(env, obj, "mousebutton", t_button));
    NAPI_CALL(env, napi_set_named_property(env, obj, "keyMouseEventInfo", keyMouseEventInfo));
    NAPI_CALL(env, napi_set_named_property(env, obj, "isHover", hover));
    return obj;
}

napi_value AppNapi::GetXComponent_GetKeyEvent(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::GetXComponent_GetKeyEvent");

    if (testKeyEvent_ == nullptr) {
        napi_value undefined = nullptr;
        NAPI_CALL(env, napi_get_undefined(env, &undefined));
        return undefined;
    }

    napi_value action;
    napi_value code;
    napi_value sourceType;
    napi_value timestamp;
    napi_value deviceId;
    napi_value keyEventInfo;
    napi_value keyEventGetInfo;

    NAPI_CALL(env, napi_create_uint32(env, testKeyEvent_->action, &(action)));
    NAPI_CALL(env, napi_create_uint32(env, testKeyEvent_->code, &(code)));
    NAPI_CALL(env, napi_create_uint32(env, testKeyEvent_->sourceType, &(sourceType)));
    NAPI_CALL(env, napi_create_int64(env, testKeyEvent_->timestamp, &(timestamp)));
    NAPI_CALL(env, napi_create_int64(env, testKeyEvent_->deviceId, &(deviceId)));
    const char *keyEventInfoCStr = keyEventInfo_.c_str();
    NAPI_CALL(env, napi_create_string_utf8(env, keyEventInfoCStr, NAPI_AUTO_LENGTH, &keyEventInfo));

    const char *keyEventGetInfoCStr = keyEventGetInfo_.c_str();
    NAPI_CALL(env, napi_create_string_utf8(env, keyEventGetInfoCStr, NAPI_AUTO_LENGTH, &keyEventGetInfo));

    napi_value obj;
    NAPI_CALL(env, napi_create_object(env, &obj));
    NAPI_CALL(env, napi_set_named_property(env, obj, "action", action));
    NAPI_CALL(env, napi_set_named_property(env, obj, "code", code));
    NAPI_CALL(env, napi_set_named_property(env, obj, "sourceType", sourceType));
    NAPI_CALL(env, napi_set_named_property(env, obj, "timestamp", timestamp));
    NAPI_CALL(env, napi_set_named_property(env, obj, "deviceId", deviceId));
    NAPI_CALL(env, napi_set_named_property(env, obj, "keyEventInfo", keyEventInfo));
    NAPI_CALL(env, napi_set_named_property(env, obj, "keyEventGetInfo", keyEventGetInfo));

    return obj;
}

napi_value AppNapi::GetXComponent_RegisterMouseEventCallback(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::GetXComponent_RegisterMouseEventCallback");

    napi_value callback_;
    NAPI_CALL(env, napi_create_double(env, mousecallback_, &(callback_)));

    napi_value obj;
    NAPI_CALL(env, napi_create_object(env, &obj));
    NAPI_CALL(env, napi_set_named_property(env, obj, "MouseCallback_", callback_));

    return obj;
}

napi_value AppNapi::SetExpectedFrameRateRange(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::SetExpectedFrameRateRange");

    napi_value exportInstance;
    napi_value thisArg;
    napi_status status;
    OH_NativeXComponent *nativeXComponent = nullptr;

    NAPI_CALL(env, napi_get_cb_info(env, info, NULL, NULL, &thisArg, NULL));

    status = napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance);
    if (status != napi_ok) {
        return nullptr;
    }

    status = napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent));
    if (status != napi_ok) {
        return nullptr;
    }
    OH_NativeXComponent_ExpectedRateRange range;
    range.max = 30;
    range.min = 10;
    range.expected = 20;
    OH_NativeXComponent_SetExpectedFrameRateRange(nativeXComponent, &range);

    napi_value isSuccess_;
    NAPI_CALL(env, napi_create_int64(env, 1, &(isSuccess_)));

    napi_value obj;
    NAPI_CALL(env, napi_create_object(env, &obj));
    NAPI_CALL(env, napi_set_named_property(env, obj, "isSuccess", isSuccess_));

    return obj;
}

napi_value AppNapi::BeginFrameRateCallback(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::BeginFrameRateCallback");

    napi_value exportInstance;
    napi_value thisArg;
    napi_status status;
    OH_NativeXComponent *nativeXComponent = nullptr;

    NAPI_CALL(env, napi_get_cb_info(env, info, NULL, NULL, &thisArg, NULL));

    status = napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance);
    if (status != napi_ok) {
        return nullptr;
    }

    status = napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent));
    if (status != napi_ok) {
        return nullptr;
    }

    OH_NativeXComponent_RegisterOnFrameCallback(nativeXComponent, DispatchOnFrameCB);

    napi_value isSuccess_;
    NAPI_CALL(env, napi_create_int64(env, 1, &(isSuccess_)));

    napi_value obj;
    NAPI_CALL(env, napi_create_object(env, &obj));
    NAPI_CALL(env, napi_set_named_property(env, obj, "isSuccess", isSuccess_));

    return obj;
}

napi_value AppNapi::EndFrameRateCallback(napi_env env, napi_callback_info info)
{
    LOGE("running AppNapi::EndFrameRateCallback");

    napi_value exportInstance;
    napi_value thisArg;
    napi_status status;
    OH_NativeXComponent *nativeXComponent = nullptr;

    NAPI_CALL(env, napi_get_cb_info(env, info, NULL, NULL, &thisArg, NULL));

    status = napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance);
    if (status != napi_ok) {
        return nullptr;
    }

    status = napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent));
    if (status != napi_ok) {
        return nullptr;
    }

    OH_NativeXComponent_UnregisterOnFrameCallback(nativeXComponent);

    napi_value isSuccess_;
    NAPI_CALL(env, napi_create_int64(env, 1, &(isSuccess_)));

    napi_value obj;
    NAPI_CALL(env, napi_create_object(env, &obj));
    NAPI_CALL(env, napi_set_named_property(env, obj, "isSuccess", isSuccess_));

    return obj;
}

napi_value AppNapi::Export(napi_env env, napi_value exports)
{
    LOGE("AppNapi::Export");
    napi_property_descriptor desc[] = {
        DECLARE_NAPI_FUNCTION("Quit", AppNapi::Quit),
        DECLARE_NAPI_FUNCTION("GetXComponentId", AppNapi::GetXComponentId),
        DECLARE_NAPI_FUNCTION("GetXComponentSize_Height", AppNapi::GetXComponentSize_Height),
        DECLARE_NAPI_FUNCTION("GetXComponentSize_Width", AppNapi::GetXComponentSize_Width),
        DECLARE_NAPI_FUNCTION("GetXComponentOffset_x", AppNapi::GetXComponentOffset_x),
        DECLARE_NAPI_FUNCTION("GetXComponentOffset_y", AppNapi::GetXComponentOffset_y),
        DECLARE_NAPI_FUNCTION("GetXComponent_TouchEvent", AppNapi::GetXComponent_TouchEvent),
        DECLARE_NAPI_FUNCTION("GetXComponent_MouseEvent", AppNapi::GetXComponent_MouseEvent),
        DECLARE_NAPI_FUNCTION("GetXComponentpointtool_tilty", AppNapi::GetXComponentpointtool_tilty),
        DECLARE_NAPI_FUNCTION("GetXComponentpointtool_type", AppNapi::GetXComponentpointtool_type),
        DECLARE_NAPI_FUNCTION("GetXComponentpointtool_tiltx", AppNapi::GetXComponentpointtool_tiltx),
        DECLARE_NAPI_FUNCTION(
            "GetXComponent_RegisterMouseEventCallback", AppNapi::GetXComponent_RegisterMouseEventCallback),
        DECLARE_NAPI_FUNCTION("GetXComponent_GetKeyEvent", AppNapi::GetXComponent_GetKeyEvent),
        DECLARE_NAPI_FUNCTION("SetExpectedFrameRateRange", AppNapi::SetExpectedFrameRateRange),
        DECLARE_NAPI_FUNCTION("UpdateForceWithCallBack", AppNapi::UpdateForceWithCallBack),
        DECLARE_NAPI_FUNCTION("BeginFrameRateCallback", AppNapi::BeginFrameRateCallback),
        DECLARE_NAPI_FUNCTION("EndFrameRateCallback", AppNapi::EndFrameRateCallback),
    };
    NAPI_CALL(env, napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc));
    return exports;
}
