# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(NativeRawFile)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
# 定义封装RawFile操作的变量BUILD_NATIVE_RAWFILE_SO。先设置为1，生成封装RawFile读写功能的libnativerawfile.so库。
# 然后将生成的libnativerawfile.so放到模块的libs目录下，将BUILD_NATIVE_RAWFILE_SO变量设置为0，生成供ArkTS调用的so库。
set(BUILD_NATIVE_RAWFILE_SO 0)
if(BUILD_NATIVE_RAWFILE_SO)
    # 封装RawFile操作
    add_library(nativerawfile SHARED native_rawfile.cpp)
    target_link_libraries(nativerawfile PUBLIC libace_napi.z.so libhilog_ndk.z.so librawfile.z.so)
else()
    add_library(preloadso SHARED preloadso.cpp)
    add_library(global_handlers SHARED global_handlers.cpp)
    add_library(nativerawfileapi SHARED native_rawfile_api.cpp)
    # TODO：知识点：使用target_link_directories命令将需要预加载的.so文件所在目录添加到preloadso的链接目录
    target_link_directories(preloadso PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${OHOS_ARCH}/)
    # TODO：知识点：在CMakeLists中导入所需的库，日志库为libhilog_ndk库。
    target_link_libraries(preloadso PUBLIC libhilog_ndk.z.so libace_napi.z.so global_handlers libnativerawfile.so)
    target_link_libraries(nativerawfileapi PUBLIC libhilog_ndk.z.so libace_napi.z.so global_handlers)
endif()