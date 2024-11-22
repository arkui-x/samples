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

#ifndef RENDER_SURFACE_H
#define RENDER_SURFACE_H

#if defined(ANDROID_PLATFORM) || defined(OHOS_PLATFORM)
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif


#if defined(IOS_PLATFORM)
#ifdef __OBJC__
    #import <Foundation/Foundation.h>
    #import <OpenGLES/EAGL.h>
    #import <OpenGLES/ES2/gl.h>
    #import <OpenGLES/ES2/glext.h>
    #import <QuartzCore/QuartzCore.h>
    @class EAGLContext;
    @class CAEAGLLayer;
#else
    #include <OpenGLES/ES3/gl.h>

    typedef void *EAGLContext;
    typedef void *CAEAGLLayer;
#endif
#endif


#include <string>
#include <stdint.h>

#define TRIANGLES_POINT     3
#define TETRAHEDRON_POINT   12

class RenderSurface {
public:
#if defined(ANDROID_PLATFORM) || defined(OHOS_PLATFORM)
    explicit RenderSurface(std::string& id) : id(id) {};
#endif
#if defined(IOS_PLATFORM)
    explicit RenderSurface(std::string& id);
#endif
    int32_t Init(void* windowHandle, int windowWidth, int windowHeight);
    void Update(float angleXOffset, float angleYOffset);
    float GetAngleX(void);
    float GetAngleY(void);
    void UpdateSzie(float width, float height);
    int32_t Quit(void);

public:
    std::string id;

private:
    GLuint LoadShader(GLenum type, const char *shaderSrc);
    GLuint CreateProgram(const char *vertexShader, const char *fragShader);
#if defined(ANDROID_PLATFORM) || defined(OHOS_PLATFORM)
    EGLNativeWindowType mEglWindow;
    EGLDisplay mEGLDisplay = EGL_NO_DISPLAY;
    EGLConfig mEGLConfig = nullptr;
    EGLContext mEGLContext = EGL_NO_CONTEXT;
    EGLContext mSharedEGLContext = EGL_NO_CONTEXT;
    EGLSurface mEGLSurface = nullptr;
#endif
#if defined(IOS_PLATFORM)
    void InitRenderBuffer();
    void *eaglContextObj;
    CAEAGLLayer *mEglWindow;
    GLuint mRenderbuffer;
    GLuint mFramebuffer;
    bool isInitBuffer_ = false;
    EAGLContext* getEAGLContext();
#endif
    
    GLuint mProgramHandle;
    float angleX = 30.0; /* default X angle */
    float angleY = 45.0; /* default Y angle */
    int32_t mSurfaceWidth = 0;
    int32_t mSurfaceHeight = 0;

    GLint mRotationLocation;
    GLint mTranslationLocation;
    GLint mMoveOriginLocation;
};

#endif /* RENDER_SURFACE_H */
