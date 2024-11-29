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

#include "napi/native_api.h"
#include "uv.h"

#ifdef ANDROID_PLATFORM
#include "native_common.h"
#include "plugin_utils.h"
#include "platform_napi.h"
#include "platform_napi_jni.h"
#endif

#if defined(IOS_PLATFORM)
#include "include/native_common.h"
#include "include/platform_napi.h"
#endif

static napi_value Add(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    double value0;
    napi_get_value_double(env, args[0], &value0);

    double value1;
    napi_get_value_double(env, args[1], &value1);

    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);
    return sum;
}

static napi_value NativeCallArkTS(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype = napi_undefined;
    napi_typeof(env, args[0], &valuetype);

    if (valuetype != napi_function) {
        napi_value undefined = nullptr;
        napi_get_undefined(env, &undefined);
        return undefined;
    }

    napi_value argv = nullptr;
    napi_create_string_utf8(env, "hello", NAPI_AUTO_LENGTH, &argv);
    napi_value result = nullptr;
    napi_call_function(env, nullptr, args[0], 1, &argv, &result);
    return result;
}

#if defined(ANDROID_PLATFORM) || defined(IOS_PLATFORM)
static napi_value NativeUvLoop(napi_env env, napi_callback_info info) {
    uv_loop_t *loop = new uv_loop_t;
    int value0 = uv_loop_init(loop);
    uv_run(loop, UV_RUN_ONCE);
    uv_loop_close(loop);
    napi_value result = nullptr;
    napi_create_int32(env, value0, &result);
    delete loop;
    return result;
}

static napi_value GetDeviceBrand(napi_env env, napi_callback_info info) {
    auto platformNAPIPlugin = PlatformNAPI::Create();
    CHECK_AND_RETURN(platformNAPIPlugin, "platformNAPIPlugin", nullptr);
    auto value = platformNAPIPlugin->GetDeviceBrand();
    napi_value napiValue = nullptr;
    napi_create_string_utf8(env, value.c_str(), value.length(), &napiValue);
    return napiValue;
}

static napi_value GetProductModel(napi_env env, napi_callback_info info) {
    auto platformNAPIPlugin = PlatformNAPI::Create();
    CHECK_AND_RETURN(platformNAPIPlugin, "platformNAPIPlugin", nullptr);
    auto value = platformNAPIPlugin->GetProductModel();
    napi_value napiValue = nullptr;
    napi_create_string_utf8(env, value.c_str(), value.length(), &napiValue);
    return napiValue;
}
#endif

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
#if defined(ANDROID_PLATFORM) || defined(IOS_PLATFORM)
        {"nativeUvLoop", nullptr, NativeUvLoop, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"GetDeviceBrand", nullptr, GetDeviceBrand, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"GetProductModel", nullptr, GetProductModel, nullptr, nullptr, nullptr, napi_default, nullptr},
#endif
        {"add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"nativeCallArkTS", nullptr, NativeCallArkTS, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

#ifdef ANDROID_PLATFORM
static void PlatformNAPIJniRegister() {
    const char className[] = "com.example.platformnapi.DeviceInfo";
    ARKUI_X_Plugin_RegisterJavaPlugin(&PlatformNAPIJni::Register, className);
}
#endif

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) {
    napi_module_register(&demoModule);
#ifdef ANDROID_PLATFORM
    ARKUI_X_Plugin_RunAsyncTask(&PlatformNAPIJniRegister, ARKUI_X_Plugin_Thread_Mode::ARKUI_X_PLUGIN_PLATFORM_THREAD);
#endif
}
