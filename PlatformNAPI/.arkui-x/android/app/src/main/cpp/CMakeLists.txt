#
#  Copyright (c) 2024 Huawei Device Co., Ltd.
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, softwarea
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)

# project Name
project(PlatformNAPI)

# Set Path
set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(NATIVE_SOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../entry/src/main/cpp)
if (DEFINED ENV{ARKUIX_SDK_HOME})
    set(NATIVE_INCLUDE_PATH "$ENV{ARKUIX_SDK_HOME}/10/arkui-x/engine/lib/include/")
endif ()

# Macro isolation
add_definitions(-DANDROID_PLATFORM)

# include_directories 对齐OH
include_directories(${NATIVERENDER_ROOT_PATH})
include_directories(${NATIVERENDER_ROOT_PATH}/../../../../../../entry/src/main/cpp/include)
include_directories(${NATIVE_INCLUDE_PATH})

# Compile files 对齐OH
add_library(entry SHARED
        ${NATIVE_SOURCE_PATH}/napi_module.cpp
        ${NATIVE_SOURCE_PATH}/src/platform_napi_impl.cpp
        ${NATIVE_SOURCE_PATH}/src/platform_napi_jni.cpp
        )

# deps
add_library(arkui_android SHARED IMPORTED GLOBAL)
set_target_properties(
        arkui_android
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${CMAKE_ANDROID_ARCH_ABI}/libarkui_android.so
)

# target link
target_link_libraries(entry PUBLIC arkui_android)
target_link_libraries(entry PUBLIC libc++.a)
target_link_libraries(entry PUBLIC log)
