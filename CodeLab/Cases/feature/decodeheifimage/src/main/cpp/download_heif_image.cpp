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
#include "download_heif_image.h"
#ifndef COMMONAPPDEVELOPMENT_DOWNLOAD_HEIF_IMAGE_CPP
#define COMMONAPPDEVELOPMENT_DOWNLOAD_HEIF_IMAGE_CPP

extern "C" {
#include "curl.h"
#include "easy.h"
/**
 * 下载HEIF图像（.heic格式网络图片）
 * @param imageUrl HEIF图像下载链接
 * @return 下载的HEIF图像数据
 */

DownloadHEIFImage::DownloadHEIFImage(){};  // 构造函数
DownloadHEIFImage::~DownloadHEIFImage(){}; // 析构函数
/**
 *
 * @param contents
 * @param size
 * @param nmemb
 * @param userp
 * @return
 */
size_t DownloadHEIFImage::HttpPostWriteBack(void *contents, size_t size, size_t nmemb, void *userp) {
    size_t realsize = size * nmemb; // 一次回调返回的数据量
    auto *mem = static_cast<MemoryStruct *>(userp);

    char *ptr = (char *)realloc(mem->memory, mem->size + realsize + 1); // 增加1字节用于结束符
    if (ptr == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "not enough memory (realloc returned NULL)");
        return 0; // 返回0表示错误
    }

    mem->memory = ptr;
    memcpy(&(mem->memory[mem->size]), contents, realsize);
    mem->size += realsize;
    mem->memory[mem->size] = '\0'; // 确保以空字符结尾
    return realsize;
}

MemoryStruct DownloadHEIFImage::get(std::string imageUrl) {
    CURL *curl = curl_easy_init();
    // 获取数据
    MemoryStruct chunk;
    if (!curl) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to init curl!");
        chunk.size = -1;
        if (chunk.memory) {
            free(chunk.memory);
            chunk.memory = nullptr;
        }
        return chunk;
    }

    // 支持https
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L);
    // 访问网址
    curl_easy_setopt(curl, CURLOPT_URL, imageUrl.c_str());

    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, &DownloadHEIFImage::HttpPostWriteBack);

    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &chunk);

    // 运行
    CURLcode res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "curl_easy_perform() failed: %{public}s",
                     curl_easy_strerror(res));
        if (chunk.memory) {
            free(chunk.memory);     // 释放内存
            chunk.memory = nullptr; // 防止悬空指针
            chunk.size = 0;         // 清空大小
        }
    }
    curl_easy_cleanup(curl); // 释放句柄

    return chunk;
}
#endif
}