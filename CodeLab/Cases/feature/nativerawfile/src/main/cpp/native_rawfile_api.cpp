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

/**
 * 实现步骤
 * 1.在cpp文件中引入所用API函数及系统函数的头文件
 * 2.在cpp文件的Init函数中描述并定义要实现、暴露的接口
 * 3.在cpp文件中实现要暴露的接口
 * 4.在.d.ts文件中通过export暴露接口
 * 5.在CMakeLists中通过target_link_libraries导入所用的库
 */

#include "napi/native_api.h"
#include <dlfcn.h>
#include <unistd.h>
#if defined(IOS_PLATFORM)
#include "rawfile/raw_file.h"
#include "rawfile/raw_file_manager.h"
#include <string>
#else
#include "./include/global_handlers.h" // 包含全局对象global_handlers的头文件
#endif

#if defined(IOS_PLATFORM)
namespace LIB_RAWFILE {
static napi_value GetTotalRawFileContent(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value argv[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // 初始化native resource manager
    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    // 获取文件名
    size_t strSize;
    char strBuf[256];
    napi_get_value_string_utf8(env, argv[1], strBuf, sizeof(strBuf), &strSize);
    std::string filename(strBuf, strSize);
    // 打开指定rawfile文件。
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(mNativeResMgr, filename.c_str());
    if (rawFile == nullptr) {
        // 释放资源
        OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
        return nullptr;
    }
    // 获取rawfile的fd
    RawFileDescriptor descriptor;
    OH_ResourceManager_GetRawFileDescriptor(rawFile, descriptor);
    // 获取文件大小
    long len = OH_ResourceManager_GetRawFileSize(rawFile);

    char *buf = (char *)malloc(len + 1);
    errno_t err = memset_s(buf, len + 1, 0, len + 1);
    if (err != 0) {
        OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
        return nullptr;
    }
    int ret;
    if ((ret = pread(descriptor.fd, buf, len, descriptor.start)) == -1) {
    } else {
        buf[len] = '\0';
    }
    napi_value strContent;
    napi_create_string_utf8(env, buf, NAPI_AUTO_LENGTH, &strContent);
    // 释放资源
    OH_ResourceManager_CloseRawFile(rawFile);
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    free(buf);
    buf = nullptr;
    return strContent;
}

static napi_value GetRawFileContent(napi_env env, napi_callback_info info)
{
    size_t argc = 4;
    napi_value argv[4] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // 初始化native resource manager
    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, argv[0]);
    // 获取文件名
    size_t strSize;
    char strBuf[256];
    napi_get_value_string_utf8(env, argv[1], strBuf, sizeof(strBuf), &strSize);
    std::string filename(strBuf, strSize);
    // 获取读取位置与长度参数
    int32_t startPos = 0;
    int32_t lenContent = 0;
    int32_t two = 2;
    int32_t three = 3;
    napi_get_value_int32(env, argv[two], &startPos);
    napi_get_value_int32(env, argv[three], &lenContent);

    // 通过Rawfile的API接口OH_ResourceManager_OpenRawFile打开文件。
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(mNativeResMgr, filename.c_str());
    if (rawFile == nullptr) {
        // 释放资源
        OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
        return nullptr;
    }
    // 获取rawfile的fd
    RawFileDescriptor descriptor;
    OH_ResourceManager_GetRawFileDescriptor(rawFile, descriptor);
    // 获取文件大小
    long len = OH_ResourceManager_GetRawFileSize(rawFile);
    // 位置、长度参数校验
    if ((long)startPos < 0 || (long)startPos >= len || lenContent <= 0) {
        // 释放资源
        OH_ResourceManager_CloseRawFile(rawFile);
        OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
        return nullptr;
    }
    // 超过文件长度,读取剩余部分
    if (((long)startPos + lenContent) > len) {
        lenContent = len - startPos;
    }

    char *buf = (char *)malloc(lenContent + 1);
    memset_s(buf, lenContent + 1, 0, lenContent + 1);
    int ret;
    // 通过pread读取文件部分内容。
    if ((ret = pread(descriptor.fd, buf, lenContent, descriptor.start + startPos)) == -1) {
    } else {
        buf[lenContent] = '\0';
    }
    napi_value strContent;
    napi_create_string_utf8(env, buf, NAPI_AUTO_LENGTH, &strContent);
    // 释放资源
    OH_ResourceManager_CloseRawFile(rawFile);
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    free(buf);
    buf = nullptr;
    return strContent;
}
} // namespace LIB_RAWFILE
#endif

// 获取并调用so库中的GetTotalRawFileContentWrapper函数，返回调用结果
static napi_value GetTotalRawFileContent(napi_env env, napi_callback_info info)
{
#if defined(IOS_PLATFORM)
    napi_value result = LIB_RAWFILE::GetTotalRawFileContent(env, info);
    return result;
#else
    // 从全局对象中获取指定so库的句柄
    void *handler = g_globalHandlers["libnativerawfile.so"];
    if (handler == nullptr) {
        // 处理句柄为空的情况
        return nullptr;
    }
    // 声明函数指针类型
    typedef napi_value (*GetTotalRawFileContentWrapperFunc)(napi_env, napi_callback_info);
    // 使用dlsym查找和调用so库中的符号
    GetTotalRawFileContentWrapperFunc getTotalRawFileContentWrapper =
        reinterpret_cast<GetTotalRawFileContentWrapperFunc>(dlsym(handler, "GetTotalRawFileContentWrapper"));
    if (getTotalRawFileContentWrapper) {
        // 调用 GetRawFileContentWrapper 函数
        napi_value result = getTotalRawFileContentWrapper(env, info);
        return result;
    } else {
        // 处理无法获取函数指针的情况
        return nullptr;
    }
#endif
}

// 获取并调用so库中的GetRawFileContentWrapper函数，返回调用结果
static napi_value GetRawFileContent(napi_env env, napi_callback_info info)
{
#if defined(IOS_PLATFORM)
    napi_value result = LIB_RAWFILE::GetRawFileContent(env, info);
    return result;
#else
    // 从全局对象中获取指定so库的句柄
    void *handler = g_globalHandlers["libnativerawfile.so"];
    if (handler == nullptr) {
        // 处理句柄为空的情况
        return nullptr;
    }
    // 声明函数指针类型
    typedef napi_value (*GetRawFileContentWrapperFunc)(napi_env, napi_callback_info);
    GetRawFileContentWrapperFunc getRawFileContentWrapper =
        reinterpret_cast<GetRawFileContentWrapperFunc>(dlsym(handler, "GetRawFileContentWrapper"));
    if (getRawFileContentWrapper) {
        // 调用 GetRawFileContentWrapper 函数
        napi_value result = getRawFileContentWrapper(env, info);
        return result;
    } else {
        // 处理无法获取函数指针的情况
        return nullptr;
    }
#endif
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getTotalRawFileContent", nullptr, GetTotalRawFileContent, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getRawFileContent", nullptr, GetRawFileContent, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "nativerawfileapi",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterNativerawfile(void) { napi_module_register(&demoModule); }
