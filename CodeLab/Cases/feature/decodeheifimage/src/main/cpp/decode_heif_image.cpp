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
#include <cstring>
#include <hilog/log.h>
#include "common.h"
#include <algorithm>
#include "libheif/heif.h"

extern "C" {
DecodeHEIFImage::DecodeHEIFImage() {}  // 构造函数
DecodeHEIFImage::~DecodeHEIFImage() {} // 析构函数

// 定义颜色编码格式转换函数
void DecodeHEIFImage::swapRBChannels(uint8_t *pixels, int pixelCount)
{
    int32_t two = 2;
    int32_t four = 4;
    for (int i = 0; i < pixelCount; i++) {
        std::swap(pixels[i * four], pixels[i * four + two]);
    }
}

DecodeResult *DecodeHEIFImage::decode_heif_image(MemoryStruct chunk)
{
    // 创建 heif_context
    struct heif_context *ctx = heif_context_alloc();
    if (!ctx) {
        OH_LOG_ERROR(LOG_APP, "分配 heif_context 失败");
        return nullptr;
    }
    // 从内存中读取 HEIC 图像
    heif_error err = heif_context_read_from_memory_without_copy(ctx, chunk.memory, chunk.size, nullptr);
    if (err.code != heif_error_Ok) {
        OH_LOG_ERROR(LOG_APP, "读取 heif 图片错误:  %{public}s", err.message);
        heif_context_free(ctx);
        return nullptr;
    }
    heif_image_handle *handle;
    err = heif_context_get_primary_image_handle(ctx, &handle);
    if (err.code != heif_error_Ok) {
        OH_LOG_ERROR(LOG_APP, "获取主图像句柄错误: %{public}s", err.message);
        heif_image_handle_release(handle);
        heif_context_free(ctx);
        return nullptr;
    }
    heif_image *heif_img;
    err = heif_decode_image(handle, &heif_img, heif_colorspace_RGB, heif_chroma_interleaved_RGBA, nullptr);
    if (err.code != heif_error_Ok) {
        heif_image_handle_release(handle);
        heif_context_free(ctx);
        return nullptr;
    }
    int width;
    int height;
    width = heif_image_get_width(heif_img, heif_channel_interleaved);
    height = heif_image_get_height(heif_img, heif_channel_interleaved);
    int stride;
    uint8_t *data = heif_image_get_plane_readonly(heif_img, heif_channel_interleaved, &stride);
    if (data == nullptr) {
        OH_LOG_ERROR(LOG_APP, "读取到的图像数据为空");
        if (heif_img != nullptr) {
            heif_image_release(heif_img);
            heif_img = nullptr;
        }
        if (handle != nullptr) {
            heif_image_handle_release(handle);
            handle = nullptr;
        }
        if (ctx != nullptr) {
            heif_context_free(ctx);
            ctx = nullptr;
        }
        return nullptr;
    }
    if (!data) {
        OH_LOG_ERROR(LOG_APP, "解码失败或图像数据为空");
        return nullptr;
    }
    const size_t bpp = 4;
    const size_t pixel_count = width * height;   // 像素总数
    const size_t row_bytes = width * bpp;        // 每一行的字节数，每个像素4个字节
    const size_t total_size = pixel_count * bpp; // 计算平面的总数据大小
    uint8_t *new_data = data;                 // 默认指向原数据
    bool needAlignment = stride != row_bytes; // 是否需要字节对齐
    if (needAlignment) {
        new_data = new (std::nothrow) uint8_t[total_size];
        if (new_data == nullptr) {
            OH_LOG_ERROR(LOG_APP, "内存分配失败");
            return nullptr;
        }
        // 字节对齐
        for (int row = 0; row < height; row++) {
            errno_t err =
                memcpy_s(new_data + row * row_bytes, total_size - row * row_bytes, data + row * stride, row_bytes);
            if (err != 0) {
                OH_LOG_ERROR(LOG_APP, "字节对齐失败");
            }
        }
    }
    if (new_data == nullptr) {
        OH_LOG_ERROR(LOG_APP, "图像数据为空，无法进行通道转换");
        return nullptr;
    }
    swapRBChannels(new_data, pixel_count);
    DecodeResult *decodeResult = new DecodeResult(new_data, stride, width, height);
    return decodeResult;
}
}