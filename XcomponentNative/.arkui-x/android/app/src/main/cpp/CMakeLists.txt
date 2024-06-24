# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(xcomponentnative)

set(NATIVE_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
if(DEFINED ENV{ARKUIX_SDK_HOME})
        message("ARKUIX_SDK_HOME: $ENV{ARKUIX_SDK_HOME}")
        set(NATIVE_INCLUDE_PATH "$ENV{ARKUIX_SDK_HOME}/12/arkui-x/engine/lib/include/")
        if(EXISTS ${NATIVE_INCLUDE_PATH})
                message("NATIVE_INCLUDE_PATH: ${NATIVE_INCLUDE_PATH}")
        else()
                message(FATAL_ERROR "The ${NATIVE_INCLUDE_PATH} does not exist. Please verify the path.")
        endif()
else()
        message(FATAL_ERROR "ARKUIX_SDK_HOME environment variable not set.Set it up for your project.")
endif()

include_directories(${NATIVE_ROOT_PATH})
include_directories(${NATIVE_ROOT_PATH}/include)
include_directories(${NATIVE_ROOT_PATH}/include/util)
include_directories(${NATIVE_INCLUDE_PATH})
include_directories(${NATIVE_INCLUDE_PATH}/ace/xcomponent)

add_library(arkui_android SHARED IMPORTED GLOBAL)
set_target_properties(
        arkui_android
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${CMAKE_ANDROID_ARCH_ABI}/libarkui_android.so
)

set(NATIVE_SOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../entry/src/main/cpp)

include_directories(${NATIVE_SOURCE_PATH})
include_directories(${NATIVE_SOURCE_PATH}/include)
include_directories(${NATIVE_SOURCE_PATH}/include/util)

add_definitions(-DANDROID_PLATFORM)

add_library(xcomponent_napi SHARED
            ${NATIVE_SOURCE_PATH}/module.cpp
            ${NATIVE_SOURCE_PATH}/app_napi.cpp
            ${NATIVE_SOURCE_PATH}/render_surface.cpp
            ${NATIVE_SOURCE_PATH}/napi_manager.cpp
            ${NATIVE_SOURCE_PATH}/napi_util.cpp)
target_link_libraries(xcomponent_napi PUBLIC arkui_android)
target_link_libraries(xcomponent_napi PUBLIC libc++.a)
target_link_libraries(xcomponent_napi PUBLIC log)
target_link_libraries(xcomponent_napi PUBLIC EGL)
target_link_libraries(xcomponent_napi PUBLIC GLESv3)