/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
#include "image/image_packer_native.h"
#include "image/pixelmap_native.h"
#include "uv.h"

#include <array>
#include <fcntl.h>
#include <string>
#include <unistd.h>
#include <vector>

namespace {
constexpr uint32_t SAMPLE_WIDTH = 2;
constexpr uint32_t SAMPLE_HEIGHT = 2;
constexpr size_t RGBA_CHANNEL_COUNT = 4;
constexpr uint32_t DEFAULT_QUALITY = 90;

enum PackArgumentIndex : size_t {
    PATH_ARGUMENT_INDEX,
    MIME_ARGUMENT_INDEX,
    QUALITY_ARGUMENT_INDEX,
    PACK_ARGUMENT_COUNT,
};

constexpr size_t PIXELMAP_ARGUMENT_INDEX = 0;
constexpr size_t NAPI_PACK_ARGUMENT_OFFSET = 1;
constexpr size_t NAPI_ARGUMENT_COUNT = NAPI_PACK_ARGUMENT_OFFSET + PACK_ARGUMENT_COUNT;

struct PackArguments {
    std::string path;
    std::string mimeType;
    uint32_t quality = DEFAULT_QUALITY;
};

napi_value CreateImageResult(napi_env env, Image_ErrorCode code)
{
    napi_value result = nullptr;
    napi_create_int32(env, static_cast<int32_t>(code), &result);
    return result;
}

bool GetString(napi_env env, napi_value value, std::string &result)
{
    napi_valuetype valueType = napi_undefined;
    if (napi_typeof(env, value, &valueType) != napi_ok || valueType != napi_string) {
        return false;
    }

    size_t length = 0;
    if (napi_get_value_string_utf8(env, value, nullptr, 0, &length) != napi_ok || length == 0) {
        return false;
    }

    std::vector<char> buffer(length + 1);
    size_t copied = 0;
    if (napi_get_value_string_utf8(env, value, buffer.data(), buffer.size(), &copied) != napi_ok) {
        return false;
    }
    result.assign(buffer.data(), copied);
    return true;
}

bool GetPackArguments(napi_env env, const napi_value *values, PackArguments &arguments)
{
    return GetString(env, values[PATH_ARGUMENT_INDEX], arguments.path) &&
        GetString(env, values[MIME_ARGUMENT_INDEX], arguments.mimeType) &&
        napi_get_value_uint32(env, values[QUALITY_ARGUMENT_INDEX], &arguments.quality) == napi_ok;
}

void KeepFirstError(Image_ErrorCode candidate, Image_ErrorCode &result)
{
    if (result == IMAGE_SUCCESS && candidate != IMAGE_SUCCESS) {
        result = candidate;
    }
}

Image_ErrorCode PackPixelMapToFile(OH_PixelmapNative *pixelmap, const std::string &path,
    const std::string &mimeType, uint32_t quality)
{
    if (pixelmap == nullptr || path.empty() || mimeType.empty()) {
        return IMAGE_BAD_PARAMETER;
    }

    int32_t fd = open(path.c_str(), O_CREAT | O_TRUNC | O_WRONLY, 0600);
    if (fd < 0) {
        return IMAGE_BAD_PARAMETER;
    }

    Image_ErrorCode result = IMAGE_SUCCESS;
    OH_PackingOptions *options = nullptr;
    OH_ImagePackerNative *packer = nullptr;
    Image_MimeType mime = { const_cast<char *>(mimeType.data()), mimeType.size() };

    result = OH_PackingOptions_Create(&options);
    if (result == IMAGE_SUCCESS) {
        result = OH_PackingOptions_SetMimeType(options, &mime);
    }
    if (result == IMAGE_SUCCESS) {
        result = OH_PackingOptions_SetQuality(options, quality);
    }
    if (result == IMAGE_SUCCESS) {
        result = OH_ImagePackerNative_Create(&packer);
    }
    if (result == IMAGE_SUCCESS) {
        result = OH_ImagePackerNative_PackToFileFromPixelmap(packer, options, pixelmap, fd);
    }

    if (packer != nullptr) {
        KeepFirstError(OH_ImagePackerNative_Release(packer), result);
    }
    if (options != nullptr) {
        KeepFirstError(OH_PackingOptions_Release(options), result);
    }
    if (close(fd) != 0 && result == IMAGE_SUCCESS) {
        result = IMAGE_UNKNOWN_ERROR;
    }
    if (result != IMAGE_SUCCESS) {
        (void)unlink(path.c_str());
    }
    return result;
}

napi_value PackRawPixelMap(napi_env env, napi_callback_info info)
{
    std::array<napi_value, PACK_ARGUMENT_COUNT> args = {};
    size_t argc = args.size();
    napi_get_cb_info(env, info, &argc, args.data(), nullptr, nullptr);

    PackArguments arguments;
    if (argc != args.size() || !GetPackArguments(env, args.data(), arguments)) {
        return CreateImageResult(env, IMAGE_BAD_PARAMETER);
    }

    OH_Pixelmap_InitializationOptions *options = nullptr;
    OH_PixelmapNative *pixelmap = nullptr;
    std::array<uint8_t, SAMPLE_WIDTH * SAMPLE_HEIGHT * RGBA_CHANNEL_COUNT> pixels = {
        255, 0, 0, 255,
        0, 255, 0, 255,
        0, 0, 255, 255,
        255, 255, 255, 255,
    };

    Image_ErrorCode result = OH_PixelmapInitializationOptions_Create(&options);
    if (result == IMAGE_SUCCESS) {
        result = OH_PixelmapInitializationOptions_SetWidth(options, SAMPLE_WIDTH);
    }
    if (result == IMAGE_SUCCESS) {
        result = OH_PixelmapInitializationOptions_SetHeight(options, SAMPLE_HEIGHT);
    }
    if (result == IMAGE_SUCCESS) {
        result = OH_PixelmapInitializationOptions_SetPixelFormat(options, PIXEL_FORMAT_RGBA_8888);
    }
    if (result == IMAGE_SUCCESS) {
        result = OH_PixelmapInitializationOptions_SetAlphaType(options, PIXELMAP_ALPHA_TYPE_OPAQUE);
    }
    if (result == IMAGE_SUCCESS) {
        result = OH_PixelmapNative_CreatePixelmap(pixels.data(), pixels.size(), options, &pixelmap);
    }
    if (result == IMAGE_SUCCESS) {
        result = PackPixelMapToFile(pixelmap, arguments.path, arguments.mimeType, arguments.quality);
    }

    if (pixelmap != nullptr) {
        KeepFirstError(OH_PixelmapNative_Destroy(&pixelmap), result);
    }
    if (options != nullptr) {
        KeepFirstError(OH_PixelmapInitializationOptions_Release(options), result);
    }
    return CreateImageResult(env, result);
}

napi_value PackNapiPixelMap(napi_env env, napi_callback_info info)
{
    std::array<napi_value, NAPI_ARGUMENT_COUNT> args = {};
    size_t argc = args.size();
    napi_get_cb_info(env, info, &argc, args.data(), nullptr, nullptr);

    PackArguments arguments;
    if (argc != args.size() ||
        !GetPackArguments(env, args.data() + NAPI_PACK_ARGUMENT_OFFSET, arguments)) {
        return CreateImageResult(env, IMAGE_BAD_PARAMETER);
    }

    OH_PixelmapNative *pixelmap = nullptr;
    Image_ErrorCode result = OH_PixelmapNative_ConvertPixelmapNativeFromNapi(
        env, args[PIXELMAP_ARGUMENT_INDEX], &pixelmap);
    if (result == IMAGE_SUCCESS) {
        result = PackPixelMapToFile(pixelmap, arguments.path, arguments.mimeType, arguments.quality);
    }
    if (pixelmap != nullptr) {
        KeepFirstError(OH_PixelmapNative_Destroy(&pixelmap), result);
    }
    return CreateImageResult(env, result);
}
} // namespace

static napi_value Add(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    if ((valuetype0 != napi_number) || (valuetype1 != napi_number)) {
        napi_value undefined = nullptr;
        napi_get_undefined(env, &undefined);
        return undefined;
    }

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

static napi_value NativeUvLoop(napi_env env,napi_callback_info info) {
    uv_loop_t *loop = new uv_loop_t;
    int value0 = uv_loop_init(loop);
    uv_run(loop, UV_RUN_ONCE);
    uv_loop_close(loop);

    napi_value result = nullptr;
    napi_create_int32(env, value0, &result);
    delete loop;
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "nativeCallArkTS", nullptr, NativeCallArkTS, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "nativeUvLoop", nullptr, NativeUvLoop, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "packRawPixelMap", nullptr, PackRawPixelMap, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "packNapiPixelMap", nullptr, PackNapiPixelMap, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version =1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
