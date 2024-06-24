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

#include "platform_napi_jni.h"

#include <iostream>
#include "native_common.h"
#include "plugin_utils.h"

const char PLATFORM_NAPI_CLASS_NAME[] = "com/example/platformnapi/DeviceInfo";

static const JNINativeMethod METHODS[] = {
    {"nativeInit", "()V", reinterpret_cast<void *>(PlatformNAPIJni::NativeInit)},
};

struct {
    jmethodID GetDeviceBrand;
    jmethodID GetProductModel;
    jobject globalRef;
} g_pluginClass;

bool PlatformNAPIJni::Register(void *env) {
    auto *jniEnv = static_cast<JNIEnv *>(env);
    CHECK_AND_RETURN(jniEnv, "jniEnv", false);

    jclass cls = jniEnv->FindClass(PLATFORM_NAPI_CLASS_NAME);
    CHECK_AND_RETURN(cls, "cls", false);

    bool ret = jniEnv->RegisterNatives(cls, METHODS, sizeof(METHODS) / sizeof(METHODS[0])) == 0;
    jniEnv->DeleteLocalRef(cls);

    if (!ret) {
        LOGE("PlatformNAPI_TAG Register native failed");
        return false;
    }
    return true;
}

void PlatformNAPIJni::NativeInit(JNIEnv *env, jobject jobj) {
    g_pluginClass.globalRef = env->NewGlobalRef(jobj);
    CHECK_AND_RETURN_VOID(g_pluginClass.globalRef, "g_pluginClass.globalRef");

    jclass cls = env->GetObjectClass(jobj);
    CHECK_AND_RETURN_VOID(cls, "cls");

    g_pluginClass.GetDeviceBrand = env->GetMethodID(cls, "getDeviceBrand", "()Ljava/lang/String;");
    CHECK_AND_RETURN_VOID(g_pluginClass.GetDeviceBrand, "g_pluginClass.GetDeviceBrand");

    g_pluginClass.GetProductModel = env->GetMethodID(cls, "getProductModel", "()Ljava/lang/String;");
    CHECK_AND_RETURN_VOID(g_pluginClass.GetProductModel, "g_pluginClass.GetProductModel");

    env->DeleteLocalRef(cls);
}

std::string PlatformNAPIJni::GetDeviceBrand() {
    auto env = ARKUI_X_Plugin_GetJniEnv();
    CHECK_AND_RETURN(env, "env", "");

    jstring result = (jstring)env->CallObjectMethod(g_pluginClass.globalRef, g_pluginClass.GetDeviceBrand);

    const char *resultCStr = env->GetStringUTFChars(result, nullptr);
    std::string resultStr(resultCStr);
    env->ReleaseStringUTFChars(result, resultCStr);

    LOGE("PlatformNAPI_TAG GetDeviceBrand is %s ", resultStr.c_str());
    return resultStr;
}

std::string PlatformNAPIJni::GetProductModel() {
    auto env = ARKUI_X_Plugin_GetJniEnv();
    CHECK_AND_RETURN(env, "env", "");

    jstring result = (jstring)env->CallObjectMethod(g_pluginClass.globalRef, g_pluginClass.GetProductModel);

    const char *resultCStr = env->GetStringUTFChars(result, nullptr);
    std::string resultStr(resultCStr);
    env->ReleaseStringUTFChars(result, resultCStr);

    LOGE("PlatformNAPI_TAG GetProductModel is %s ", resultStr.c_str());
    return resultStr;
}
