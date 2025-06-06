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

#include <thread>

#include "napi/native_api.h"

const int GLOBAL_RESMGR = 0xFF00;
const char* TAG = "[nativeprogressnotify]";
typedef struct CallbackContext {
    napi_env env = nullptr;
    napi_threadsafe_function tsfn = nullptr; // 线程安全函数
    int progress = 0;
} CallbackContext;

// 回调ts侧函数，将进度信息通知到ts侧
static void callTS(napi_env env, napi_value jsCb, void* context, void* data)
{
    CallbackContext* arg = (CallbackContext*)data;
    napi_value progress;
    napi_create_int32(arg->env, arg->progress, &progress);
    napi_call_function(arg->env, nullptr, jsCb, 1, &progress, nullptr);
}

/**
 * 模拟下载任务，这里因为调用了ts侧函数，所以要使用线程安全函数
 */
void DownloadTask(CallbackContext* context)
{
    int32_t hundred = 100;
    while (context && context->progress < hundred) {
        context->progress += 1;
        napi_acquire_threadsafe_function(context->tsfn);
        napi_call_threadsafe_function(context->tsfn, (void*)context, napi_tsfn_blocking);
        std::this_thread::sleep_for(std::chrono::milliseconds(hundred));
    }
    delete context;
};

static napi_value startDownload(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = { nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    auto asyncContext = new CallbackContext();
    asyncContext->env = env;
    // 创建线程安全函数
    napi_value workName;
    napi_create_string_utf8(env, "nativeprogressdownload", NAPI_AUTO_LENGTH, &workName);
    napi_threadsafe_function tsfn;
    napi_create_threadsafe_function(env, args[0], nullptr, workName, 0, 1, nullptr, nullptr, nullptr, callTS, &tsfn);
    asyncContext->tsfn = tsfn;
    // 启动下载线程，在子线程中执行下载任务并实时将进度通知到arkts线程
    std::thread downloadThread(DownloadTask, asyncContext);
    downloadThread.detach();
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = { { "startDownload", nullptr, startDownload, nullptr, nullptr, nullptr,
        napi_default, nullptr } };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "nativeprogressnotify",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterNativeprocessnotifyModule(void)
{
    napi_module_register(&demoModule);
}
