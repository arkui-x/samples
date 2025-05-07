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

#include "decode_heif_image.h"
#include "download_heif_image.h"
#include "napi/native_api.h"
#include <multimedia/image_framework/image_mdk_common.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <multimedia/image_framework/image_pixel_map_napi.h>


/**
 * 通过libheif软解码HEIF网络图片
 * @param env
 * @param info
 * @return 解码后的HEIF图片数据
 */
static napi_value DecodeHeifImageFromInternet(napi_env env, napi_callback_info info) {
    napi_value pixel_map = nullptr;

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Beginning DecodeInternetHeifImage！");

    // 解析参数JS -> C++
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    size_t filenameSize;
    char filenameBuffer[512];
    napi_get_value_string_utf8(env, argv[0], filenameBuffer, sizeof(filenameBuffer), &filenameSize);
    std::string imageUrl(filenameBuffer, filenameSize);
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "DecodeHeifImageFromInternet, url:%{public}s",
                 imageUrl.c_str());

    // 获取网络HEIF
    DownloadHEIFImage downloadHEIFImage;
    MemoryStruct chunk = downloadHEIFImage.get(imageUrl);

    if (chunk.size == -1) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "DecodeInternetHeifImage, download Fail!");
        return nullptr;
    }

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,
                 "DecodeInternetHeifImage DownloadFromInternet success, size:%{public}d", chunk.size);

    DecodeHEIFImage decodeHEIFImage;

    DecodeResult *decodeResult = decodeHEIFImage.decode_heif_image(chunk);
    if (!decodeResult) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "DecodeInternetHeifImage, decodeResult is null.");
        if (chunk.memory) {
            free(chunk.memory);
            chunk.memory = nullptr;
            chunk.size = 0;
        }
        return nullptr;
    }

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "DecodeInternetHeifImage success, image height:%{public}d",
                 decodeResult->heif_image_height);

    const size_t bpp = 4;
    const size_t pixel_count = decodeResult->heif_image_width * decodeResult->heif_image_height; // 像素总数
    const size_t row_bytes = decodeResult->heif_image_width * bpp; // 每一行的字节数，每个像素4个字节
    const size_t total_size = pixel_count * bpp;                   // 计算平面的总数据大小

    bool needAlignment = decodeResult->heif_image_stride != row_bytes; // 是否需要字节对齐
    struct OhosPixelMapCreateOps createOps;
    createOps.width = decodeResult->heif_image_width;
    createOps.height = decodeResult->heif_image_height;
    createOps.pixelFormat = 4; // 目前颜色编码格式只支持BGRA
    createOps.alphaType = 0;

    // TODO: 知识点：调用NDK接口OH_PixelMap_CreatePixelMap创建PixelMap
    int32_t res = OH_PixelMap_CreatePixelMap(env, createOps, (void *)decodeResult->data, total_size, &pixel_map);
    if (res != IMAGE_RESULT_SUCCESS || pixel_map == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "创建pixelMap错误");
        if (chunk.memory) {
            free(chunk.memory);
            chunk.memory = nullptr;
            chunk.size = 0;
        }
        if (decodeResult->data != nullptr) {
            delete[] decodeResult->data;
        }
        return nullptr;
    }

    const char *keys[] = {"data", "width", "height"};
    napi_value values[3];
    values[0] = pixel_map;
    napi_create_int32(env, decodeResult->heif_image_width, &values[1]);
    napi_create_int32(env, decodeResult->heif_image_height, &values[2]);

    napi_value result;
    napi_create_object_with_named_properties(env, &result, 3, keys, values);

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "napi_create_object_with_named_properties success");
    // 清理资源
    if (decodeResult->data != nullptr) {
        delete[] decodeResult->data;
    }

    // 释放chunk
    if (chunk.memory) {
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "释放chunk");
        free(chunk.memory);
        chunk.memory = nullptr;
        chunk.size = 0;
    }
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {{"decodeHeifImageFromInternet", nullptr, DecodeHeifImageFromInternet, nullptr,
                                        nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "decodeheifimage",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterDecodeHEIFImageModule(void) { napi_module_register(&demoModule); }
