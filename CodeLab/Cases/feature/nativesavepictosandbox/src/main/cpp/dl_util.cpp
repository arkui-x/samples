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

#include <cstdio>
#include <dlfcn.h>

void *LoadLibrary(const char *libraryPath)
{
    // 打开共享库
    void *handle = dlopen(libraryPath, RTLD_LAZY);
    if (!handle) {
        fprintf(stderr, "Error opening library: %s\n", dlerror());
        return nullptr;
    }
    return handle;
}

void *GetFunction(void *handle, const char *functionName)
{
    // 获取共享库中的函数指针
    void *functionPtr = dlsym(handle, functionName);
    if (!functionPtr) {
        fprintf(stderr, "Error getting function: %s\n", dlerror());
        return nullptr;
    }
    return functionPtr;
}

void CloseLibrary(void *handle)
{
    // 关闭共享库
    if (handle) {
        dlclose(handle);
    }
}

