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