cmake_minimum_required(VERSION 3.4.1)
project(XCOMPONENTVSYNC)

set(ENGINE_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

add_definitions(-DOHOS_PLATFORM)
include_directories(${ENGINE_ROOT_PATH}
                    ${ENGINE_ROOT_PATH}/common
                    ${ENGINE_ROOT_PATH}/manager
                    ${ENGINE_ROOT_PATH}/render
                    ${ENGINE_ROOT_PATH}/include
                    ${ENGINE_ROOT_PATH}/include/native_vsync
                    )


add_library(entry SHARED
            napi_init.cpp
            render/plugin_render.cpp
            manager/plugin_manager.cpp
            render/egl_core_shader.cpp
            )

find_library( # Sets the name of the path variable.
              EGL-lib
              # Specifies the name of the NDK library that
              # you want CMake to locate.
              EGL )

find_library( # Sets the name of the path variable.
              GLES-lib
              # Specifies the name of the NDK library that
              # you want CMake to locate.
              GLESv3 )

find_library( # Sets the name of the path variable.
              hilog-lib
              # Specifies the name of the NDK library that
              # you want CMake to locate.
              hilog_ndk.z )

find_library( # Sets the name of the path variable.
              libace-lib
              # Specifies the name of the NDK library that
              # you want CMake to locate.
              ace_ndk.z )

find_library( # Sets the name of the path variable.
               libdrawing-lib
               # Specifies the name of the NDK library that
               # you want CMake to locate.
               native_drawing )

find_library( # Sets the name of the path variable.
               libvsync-lib
               # Specifies the name of the NDK library that
               # you want CMake to locate.
               native_vsync )

find_library( # Sets the name of the path variable.
              libnapi-lib
              # Specifies the name of the NDK library that
              # you want CMake to locate.
              ace_napi.z )

find_library( # Sets the name of the path variable.
              libuv-lib
              # Specifies the name of the NDK library that
              # you want CMake to locate.
              uv )

target_link_libraries(entry PUBLIC ${EGL-lib} ${GLES-lib} ${hilog-lib} ${libace-lib} ${libnapi-lib} ${libuv-lib} ${libvsync-lib} ${libdrawing-lib} librawfile.z.so)