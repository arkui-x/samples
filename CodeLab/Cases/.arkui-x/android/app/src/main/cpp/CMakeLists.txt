cmake_minimum_required(VERSION 3.4.1)

project(cases)

# ++++++++++++++++++++++++++++++++ 共通部分：环境路径配置 ++++++++++++++++++++++++++++++++++++++++++++++
set(NATIVE_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(NATIVE_SOURCE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../feature/nativerawfile/src/main/cpp)
if (DEFINED ENV{ARKUIX_SDK_HOME})
    message("ARKUIX_SDK_HOME: $ENV{ARKUIX_SDK_HOME}")
    set(NATIVE_INCLUDE_PATH "$ENV{ARKUIX_SDK_HOME}/16/arkui-x/engine/lib/include/")
    if (EXISTS ${NATIVE_INCLUDE_PATH})
        message("NATIVE_INCLUDE_PATH: ${NATIVE_INCLUDE_PATH}")
    else ()
        message(FATAL_ERROR "The ${NATIVE_INCLUDE_PATH} does not exist. Please verify the path.")
    endif ()
endif ()

add_library(arkui_android SHARED IMPORTED GLOBAL)

set_target_properties(
        arkui_android
        PROPERTIES IMPORTED_LOCATION
        ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${CMAKE_ANDROID_ARCH_ABI}/libarkui_android.so
)

if (DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif ()

# Macro isolation
add_definitions(-DANDROID_PLATFORM)

# ++++++++++++++++++++++++++++++++ 案例-011 预加载so并读取RawFile文件 ++++++++++++++++++++++++++++++++++++++++++++++
include_directories(${NATIVE_ROOT_PATH})
include_directories(${NATIVE_INCLUDE_PATH})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../feature/nativerawfile/src/main/cpp/include)

add_library(nativerawfile SHARED ${NATIVE_SOURCE_PATH}/native_rawfile.cpp)
add_library(preloadso SHARED ${NATIVE_SOURCE_PATH}/preloadso.cpp)
add_library(global_handlers SHARED ${NATIVE_SOURCE_PATH}/global_handlers.cpp)
add_library(nativerawfileapi SHARED ${NATIVE_SOURCE_PATH}/native_rawfile_api.cpp)

target_link_libraries(nativerawfile PUBLIC arkui_android)
target_link_libraries(nativerawfile PUBLIC libc++.a)
target_link_libraries(nativerawfile PUBLIC log)

target_link_libraries(preloadso PUBLIC global_handlers nativerawfile)
target_link_libraries(preloadso PUBLIC arkui_android)
target_link_libraries(preloadso PUBLIC libc++.a)
target_link_libraries(preloadso PUBLIC log)
target_link_libraries(nativerawfileapi PUBLIC global_handlers)
target_link_libraries(nativerawfileapi PUBLIC arkui_android)
target_link_libraries(nativerawfileapi PUBLIC libc++.a)
target_link_libraries(nativerawfileapi PUBLIC log)

# ++++++++++++++++++++++++++++++++ 案例-014 使用AKI轻松实现跨语言调用 ++++++++++++++++++++++++++++++++++++++++++++++
#aki库中依赖了oh的库 暂不确定是否可行
#set(NATIVE_SOURCE_PATH_AKIUSEPRATICE ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../feature/akiusepractice/src/main/cpp)
#
#include_directories(${NATIVE_SOURCE_PATH}
#                    ${NATIVE_SOURCE_PATH}/include)
#
## 设置AKI根路径
#set(AKI_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../feature/akiusepractice/oh_modules/@ohos/aki)
#
## 将CMAKE_MODULE_PATH变量的值设置为AKI_ROOT_PATH变量的值，这样CMake在查找自定义模块时会查看这个路径。
#set(CMAKE_MODULE_PATH ${AKI_ROOT_PATH})
#
## 用于查找并加载名为"Aki"的库
#find_package(Aki REQUIRED)
#
## 创建并编译一个akiusepractice库
#add_library(akiusepractice SHARED ${NATIVE_SOURCE_PATH}/akiusepractice.cpp)
#
## 将Aki::libjsbind库链接到akiusepractice
#target_link_libraries(akiusepractice PUBLIC Aki::libjsbind)
#
#target_link_libraries(akiusepractice PUBLIC arkui_android libc++.a log)

# ++++++++++++++++++++++++++++++++ 案例-022 在Native侧实现进度通知功能 ++++++++++++++++++++++++++++++++++++++++++++++
set(NATIVE_SOURCE_PATH_NATIVEPROGRESSNOTIFY ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../feature/nativeprogressnotify/src/main/cpp)

include_directories(${NATIVE_INCLUDE_PATH})
include_directories(${NATIVE_SOURCE_PATH_NATIVEPROGRESSNOTIFY})
include_directories(${NATIVE_SOURCE_PATH_NATIVEPROGRESSNOTIFY}/include)

add_library(nativeprogressnotify SHARED ${NATIVE_SOURCE_PATH_NATIVEPROGRESSNOTIFY}/hello.cpp)

target_link_libraries(nativeprogressnotify PUBLIC arkui_android libc++.a log)

# ++++++++++++++++++++++++++++++++ 案例-041 Native保存图片到应用沙箱 ++++++++++++++++++++++++++++++++++++++++++++++
set(NATIVE_SOURCE_PATH_NATIVESAVEPICTOSANDBOX ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../feature/nativesavepictosandbox/src/main/cpp)

include_directories(${NATIVE_SOURCE_PATH_NATIVESAVEPICTOSANDBOX})

add_library(nativesavepictosandbox SHARED ${NATIVE_SOURCE_PATH_NATIVESAVEPICTOSANDBOX}/native_picture_to_sandbox.cpp)

target_link_libraries(nativesavepictosandbox PUBLIC arkui_android libc++.a log)

# ++++++++++++++++++++++++++++++++ 案例-065 NAPI封装ArkTS接口案例 ++++++++++++++++++++++++++++++++++++++++++++++
set(NATIVE_SOURCE_PATH_ETSWRAPPER ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../feature/etswrapper/src/main/cpp)

include_directories(${NATIVE_SOURCE_PATH_ETSWRAPPER}
        ${NATIVE_SOURCE_PATH_ETSWRAPPER}/include)

aux_source_directory(${NATIVE_SOURCE_PATH_ETSWRAPPER}/src SRC_DIR)

add_library(etswrapper SHARED ${NATIVE_SOURCE_PATH_ETSWRAPPER}/napi_init.cpp ${SRC_DIR})

target_link_libraries(etswrapper PUBLIC arkui_android libc++.a log)

# ++++++++++++++++++++++++++++++++ 案例-097 XComponent + Vsync 实现自定义动画 ++++++++++++++++++++++++++++++++++++++++++++++
#find_libraty中的库暂未找到
#add_definitions(-DOHOS_PLATFORM)
#
#set(NATIVE_SOURCE_PATH_XCOMPONENTVSYNC ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../feature/xcomponentvsync/src/main/cpp)
#
#include_directories(${NATIVE_SOURCE_PATH_XCOMPONENTVSYNC}
#        ${NATIVE_SOURCE_PATH_XCOMPONENTVSYNC}/common
#        ${NATIVE_SOURCE_PATH_XCOMPONENTVSYNC}/manager
#        ${NATIVE_SOURCE_PATH_XCOMPONENTVSYNC}/render
#        ${NATIVE_SOURCE_PATH_XCOMPONENTVSYNC}/include
#        ${NATIVE_SOURCE_PATH_XCOMPONENTVSYNC}/include/native_vsync
#        )
#
#
#add_library(entry SHARED
#        ${NATIVE_SOURCE_PATH_XCOMPONENTVSYNC}/napi_init.cpp
#        ${NATIVE_SOURCE_PATH_XCOMPONENTVSYNC}/render/plugin_render.cpp
#        ${NATIVE_SOURCE_PATH_XCOMPONENTVSYNC}/manager/plugin_manager.cpp
#        ${NATIVE_SOURCE_PATH_XCOMPONENTVSYNC}/render/egl_core_shader.cpp
#        )
#
#find_library( # Sets the name of the path variable.
#        EGL-lib
#        # Specifies the name of the NDK library that
#        # you want CMake to locate.
#        EGL )
#
#find_library( # Sets the name of the path variable.
#        GLES-lib
#        # Specifies the name of the NDK library that
#        # you want CMake to locate.
#        GLESv3 )
#
##find_library( # Sets the name of the path variable.
##        hilog-lib
##        # Specifies the name of the NDK library that
##        # you want CMake to locate.
##        hilog_ndk.z )
##
##find_library( # Sets the name of the path variable.
##        libace-lib
##        # Specifies the name of the NDK library that
##        # you want CMake to locate.
##        ace_ndk.z )
##
##find_library( # Sets the name of the path variable.
##        libdrawing-lib
##        # Specifies the name of the NDK library that
##        # you want CMake to locate.
##        native_drawing )
##
##find_library( # Sets the name of the path variable.
##        libvsync-lib
##        # Specifies the name of the NDK library that
##        # you want CMake to locate.
##        native_vsync )
#
##find_library( # Sets the name of the path variable.
##        libnapi-lib
##        # Specifies the name of the NDK library that
##        # you want CMake to locate.
##        ace_napi.z )
##
##find_library( # Sets the name of the path variable.
##        libuv-lib
##        # Specifies the name of the NDK library that
##        # you want CMake to locate.
##        uv )
#target_link_libraries(entry PUBLIC arkui_android libc++.a log)
#
##target_link_libraries(entry PUBLIC ${EGL-lib} ${GLES-lib} ${hilog-lib} ${libace-lib} ${libnapi-lib} ${libuv-lib} ${libvsync-lib} ${libdrawing-lib} librawfile.z.so)
#target_link_libraries(entry PUBLIC ${EGL-lib} ${GLES-lib})

# ++++++++++++++++++++++++++++++++ 案例-148 HEIF软解码器案例 ++++++++++++++++++++++++++++++++++++++++++++++
#libpixelmap_ndk.z.so库暂未找到
#set(NATIVE_SOURCE_PATH_DECODEHEIFIMAGE ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../feature/decodeheifimage/src/main/cpp)
#
#include_directories(${NATIVE_SOURCE_PATH_DECODEHEIFIMAGE}
#                    ${NATIVE_SOURCE_PATH_DECODEHEIFIMAGE}/include)
#
#add_library(nativedownloadheif SHARED ${NATIVE_SOURCE_PATH_DECODEHEIFIMAGE}/download_heif_image.cpp)
#
## 配置动态链接，将libcurl.so加入工程中   没有识别${OHOS_ARCH} 暂用arm64-v8a代替
#target_link_libraries(nativedownloadheif PRIVATE ${NATIVE_SOURCE_PATH_DECODEHEIFIMAGE}/../../../../../libs/arm64-v8a/libcurl.so)
## 将libcurl的头文件加入工程中
#target_include_directories(nativedownloadheif PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../../thirdparty/curl)
## 导入napi、ndk相关库
#target_link_libraries(nativedownloadheif PUBLIC arkui_android libc++.a log)
#
## 生成封装libheif库的libnativedecodeheif.so
#add_library(nativedecodeheif SHARED ${NATIVE_SOURCE_PATH_DECODEHEIFIMAGE}/decode_heif_image.cpp)
## 配置动态链接，将libheif.so加入工程中  同 line 191
##target_link_libraries(nativedecodeheif PRIVATE ${NATIVE_SOURCE_PATH_DECODEHEIFIMAGE}/thirdparty/libheif/${OHOS_ARCH}/lib/libheif.so)
#target_link_libraries(nativedecodeheif PRIVATE ${NATIVE_SOURCE_PATH_DECODEHEIFIMAGE}/../../../libs/arm64-v8a/libheif.so.1)
#
## 将libheif的头文件加入工程中
#target_include_directories(nativedecodeheif PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../../thirdparty/libheif/libheif/api)
## 导入napi、ndk相关库
#target_link_libraries(nativedecodeheif PUBLIC arkui_android libc++.a log)
#
## 生成native侧库,供ArkTS侧调用
#add_library(decodeheifimage SHARED  ${NATIVE_SOURCE_PATH_DECODEHEIFIMAGE}/napi_init.cpp)
## 导入引用的库路径
#target_link_directories(decodeheifimage PUBLIC ${NATIVE_SOURCE_PATH_DECODEHEIFIMAGE}/../../../libs/${OHOS_ARCH}/)
#target_include_directories(decodeheifimage PRIVATE ${NATIVE_SOURCE_PATH_DECODEHEIFIMAGE}/include)
## 导入napi、ndk相关库及libnativedownloadheif.so和libnativedecodeheif解码库
##target_link_libraries(decodeheifimage PUBLIC libace_napi.z.so  libhilog_ndk.z.so libpixelmap_ndk.z.so libnativedownloadheif.so  libnativedecodeheif.so)
#target_link_libraries(decodeheifimage PUBLIC arkui_android libc++.a log nativedownloadheif  nativedecodeheif)