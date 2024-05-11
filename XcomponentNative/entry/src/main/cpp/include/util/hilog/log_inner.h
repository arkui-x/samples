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

#ifndef HIVIEWDFX_HILOG_H
#define HIVIEWDFX_HILOG_H

#include <string>
#ifdef ANDROID_PLATFORM
#include <android/log.h>
#endif

#ifdef IOS_PLATFORM
#import <os/log.h>
#endif

#include <stdarg.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifndef LOG_DOMAIN
#define LOG_DOMAIN 0
#endif

#ifndef LOG_TAG
#define LOG_TAG NULL
#endif

typedef enum {
    /* Third-party application logs */
    LOG_APP = 0,
} LogType;

typedef enum {
    /* Debug level to be used by {@link OH_LOG_DEBUG} */
    LOG_DEBUG = 3,
    /* Informational level to be used by {@link OH_LOG_INFO} */
    LOG_INFO = 4,
    /* Warning level to be used by {@link OH_LOG_WARN} */
    LOG_WARN = 5,
    /* Error level to be used by {@link OH_LOG_ERROR} */
    LOG_ERROR = 6,
    /* Fatal level to be used by {@link OH_LOG_FATAL} */
    LOG_FATAL = 7,
} LogLevel;

#ifdef __cplusplus
}
#endif

const std::string PRIVATE_FLAG_PUBLIC = "{public}";
const std::string PRIVATE_FLAG_PRIVATE = "{private}";

#if defined(ANDROID_PLATFORM)
constexpr int32_t LOG_LEVEL[] = { ANDROID_LOG_DEBUG, ANDROID_LOG_INFO, ANDROID_LOG_WARN, ANDROID_LOG_ERROR,
    ANDROID_LOG_FATAL };

static inline int HiLogPrintArgs(int type, int prio, int domain, const char * tag, const char * fmt, va_list vargs)
{
    std::string newFmt(fmt);

    for (auto pos = newFmt.find(PRIVATE_FLAG_PUBLIC, 0); pos != std::string::npos;
        pos = newFmt.find(PRIVATE_FLAG_PUBLIC, pos)) {
        newFmt.erase(pos, PRIVATE_FLAG_PUBLIC.size());
    }

    for (auto pos = newFmt.find(PRIVATE_FLAG_PRIVATE, 0);
        pos != std::string::npos; pos = newFmt.find(PRIVATE_FLAG_PRIVATE, pos)) {
        newFmt.erase(pos, PRIVATE_FLAG_PRIVATE.size());
    }

    __android_log_vprint(LOG_LEVEL[static_cast<int>(domain)], "Xcomponent", newFmt.c_str(), vargs);

    return 0;
}

static inline int OH_LOG_Print(LogType type, LogLevel level, unsigned int domain, const char *tag, const char *fmt, ...)
{
    int ret;
    va_list ap;
    va_start(ap, fmt);
    ret = HiLogPrintArgs(type, level, domain, tag, fmt, ap);
    va_end(ap);
    return ret;
}
#endif

#if defined(IOS_PLATFORM)

constexpr uint32_t MAX_BUFFER_SIZE = 4000; // MAX_BUFFER_SIZE same with hilog
constexpr uint32_t MAX_TIME_SIZE = 32;
const char* const LOGLEVELNAME[] = { "DEBUG", "INFO", "WARNING", "ERROR", "FATAL" };
constexpr os_log_type_t LOG_TYPE[] = {OS_LOG_TYPE_DEBUG, OS_LOG_TYPE_INFO, OS_LOG_TYPE_DEFAULT, OS_LOG_TYPE_ERROR,
    OS_LOG_TYPE_FAULT};


static inline int OH_LOG_Print(LogType type, LogLevel level, unsigned int domain, const char *tag, const char *fmt, ...)
{
    std::string newFmt(fmt);

    for (auto pos = newFmt.find(PRIVATE_FLAG_PUBLIC, 0); pos != std::string::npos;
        pos = newFmt.find(PRIVATE_FLAG_PUBLIC, pos)) {
        newFmt.erase(pos, PRIVATE_FLAG_PUBLIC.size());
    }

    for (auto pos = newFmt.find(PRIVATE_FLAG_PRIVATE, 0);
        pos != std::string::npos; pos = newFmt.find(PRIVATE_FLAG_PRIVATE, pos)) {
        newFmt.erase(pos, PRIVATE_FLAG_PRIVATE.size());
    }

    char buf[MAX_BUFFER_SIZE];
    va_list ap;
    va_start(ap, fmt);
    if (vsnprintf(buf, sizeof(buf), newFmt.c_str(), ap) < 0) {
        return 0;
    }
    const char* levelName = LOGLEVELNAME[static_cast<int>(level-3)];
    os_log_t log = os_log_create("Xcomponent", levelName);
    os_log(log, "[%{public}s] %{public}s", levelName, buf);
    return 0;
}
#endif

#endif  // HIVIEWDFX_HILOG_C_H
