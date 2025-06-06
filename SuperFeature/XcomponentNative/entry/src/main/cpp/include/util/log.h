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

#ifndef LOG_H
#define LOG_H

#if defined(IOS_PLATFORM) || defined(ANDROID_PLATFORM)
#include "hilog/log_inner.h"
#else
#include "hilog/log.h"
#endif

#ifndef LOGI
#define LOGI(...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "[OpenGL]", __VA_ARGS__))
#endif

#ifndef LOGD
#define LOGD(...) ((void)OH_LOG_Print(LOG_APP, LOG_DEBUG, LOG_DOMAIN, "[OpenGL]", __VA_ARGS__))
#endif

#ifndef LOGW
#define LOGW(...) ((void)OH_LOG_Print(LOG_APP, LOG_WARN, LOG_DOMAIN, "[OpenGL]", __VA_ARGS__))
#endif

#ifndef LOGE
#define LOGE(...) ((void)OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "[OpenGL]", __VA_ARGS__))
#endif
#endif // _LOG_H_
