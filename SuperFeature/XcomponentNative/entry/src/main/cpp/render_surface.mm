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

#include "render_surface.h"

#import <UIKit/UIKit.h>

#include <cmath>
#include "log.h"

RenderSurface::RenderSurface(std::string& id)
  : id(id), eaglContextObj(nullptr) {
        EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        eaglContextObj = (__bridge_retained void*)context;
}

static char g_vertexShader[] =
    "attribute vec4 a_pos;\n"
    "attribute vec4 a_color;\n"
    "attribute vec4 a_normal;\n"
    "uniform vec3 u_lightColor;\n"
    "uniform vec3 u_lightDirection;\n"
    "uniform mat4 a_mx;\n"
    "uniform mat4 a_my;\n"
    "varying vec4 v_color;\n"
    "void main() {\n"
    "    float radian = radians(30.0);\n"
    "    float cos = cos(radian);\n"
    "    float sin = sin(radian);\n"
    "    gl_Position = a_mx * a_my * vec4(a_pos.x, a_pos.y, a_pos.z, 1.0);\n"
    "    vec3 normal = normalize((a_mx * a_my * a_normal).xyz);\n"
    "    float dot = max(dot(u_lightDirection, normal), 0.0);\n"
    "    vec3 reflectedLight = u_lightColor * a_color.rgb * dot;\n"
    "    v_color = vec4(reflectedLight, a_color.a);\n"
    "}\n\0";

static char g_fragmentShader[] =
    "precision mediump float;\n"
    "varying vec4 v_color;\n"
    "void main() {\n"
    "    gl_FragColor = v_color;\n"
    "}\n\0";

/* Create an array of vertex position data vertexData */
static float g_vertexData[] = {
    -0.75, -0.50, -0.43, 0.75, -0.50, -0.43, 0.00,  -0.50, 0.87,  0.75, -0.50, -0.43,
    0.00,  -0.50, 0.87,  0.00, 1.00,  0.00,  0.00,  -0.50, 0.87,  0.00, 1.00,  0.00,
    -0.75, -0.50, -0.43, 0.00, 1.00,  0.00,  -0.75, -0.50, -0.43, 0.75, -0.50, -0.43,
};

/* Create an array of vertex colors colorData */
static float g_colorData[] = {
    1, 0, 0, 1, 0, 0, 1, 0, 0, /* Red surface 1 */
    1, 0, 0, 1, 0, 0, 1, 0, 0, /* Red surface 2 */
    1, 0, 0, 1, 0, 0, 1, 0, 0, /* Red surface 3 */
    1, 0, 0, 1, 0, 0, 1, 0, 0  /* Red surface 4 */
};

/* An array of vertex normal vectors normalData */
static float g_normalData[] = {
    0.00,  -1.00, 0.00,  0.00,  -1.00, 0.00,  0.00,  -1.00, 0.00, -0.83, -0.28, -0.48,
    -0.83, -0.28, -0.48, -0.83, -0.28, -0.48, -0.83, 0.28,  0.48, -0.83, 0.28,  0.48,
    -0.83, 0.28,  0.48,  0.00,  -0.28, 0.96,  0.00,  -0.28, 0.96, 0.00,  -0.28, 0.96,
};

namespace {
    void enableVertexAttrib(GLuint index, float *data, int32_t len)
    {
        GLuint buffer;
        glGenBuffers(1, &buffer);
        glBindBuffer(GL_ARRAY_BUFFER, buffer);
        glBufferData(GL_ARRAY_BUFFER, len, data, GL_STATIC_DRAW);
        glVertexAttribPointer(index, TRIANGLES_POINT, GL_FLOAT, GL_FALSE, 0, 0);
        glEnableVertexAttribArray(index);
        return;
    }
}

GLuint RenderSurface::LoadShader(GLenum type, const char *shaderSrc)
{
    GLuint shader;
    GLint compiled;

    shader = glCreateShader(type);
    if (shader == 0) {
        LOGE("LoadShader shader error");
        return 0;
    }

    glShaderSource(shader, 1, &shaderSrc, nullptr);
    glCompileShader(shader);

    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);

    if (!compiled) {
        GLint infoLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);

        if (infoLen > 1) {
            std::string infoLog(infoLen, '\0');
            glGetShaderInfoLog(shader, infoLen, nullptr, (GLchar *)&infoLog);
            LOGE("Error compiling shader:%{public}s\n", infoLog.c_str());
        }

        glDeleteShader(shader);
        return 0;
    }

    return shader;
}

GLuint RenderSurface::CreateProgram(const char *vertexShader, const char *fragShader)
{
    GLuint vertex;
    GLuint fragment;
    GLuint program;
    GLint linked;

    vertex = LoadShader(GL_VERTEX_SHADER, vertexShader);
    if (vertex == 0) {
        LOGE("LoadShader: vertexShader error");
        return 0;
    }

    fragment = LoadShader(GL_FRAGMENT_SHADER, fragShader);
    if (fragment == 0) {
        LOGE("LoadShader: fragShader error");
        glDeleteShader(vertex);
        return 0;
    }

    program = glCreateProgram();
    if (program == 0) {
        LOGE("CreateProgram program error");
        glDeleteShader(vertex);
        glDeleteShader(fragment);
        return 0;
    }

    glAttachShader(program, vertex);
    glAttachShader(program, fragment);
    glLinkProgram(program);
    glGetProgramiv(program, GL_LINK_STATUS, &linked);

    if (!linked) {
        LOGE("CreateProgram linked error");
        GLint infoLen = 0;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            std::string infoLog(infoLen, '\0');
            glGetProgramInfoLog(program, infoLen, nullptr, (GLchar *)&infoLog);
            LOGE("Error linking program:%{public}s\n", infoLog.c_str());
        }
        glDeleteShader(vertex);
        glDeleteShader(fragment);
        glDeleteProgram(program);
        return 0;
    }
    glDeleteShader(vertex);
    glDeleteShader(fragment);

    return program;
}

EAGLContext* RenderSurface::getEAGLContext() {
    return  (__bridge EAGLContext*)eaglContextObj;
}

int32_t RenderSurface::Init(void *window, int32_t width,  int32_t height)
{
    LOGI("Init window = %{public}p, w = %{public}d, h = %{public}d.", window, width, height);
    mSurfaceWidth = width;
    mSurfaceHeight = height;
    
    if (!eaglContextObj) {
        /* Create a new EAGLContext directly */
        EAGLContext *newContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (!newContext || ![EAGLContext setCurrentContext:newContext]) {
            NSLog(@"Failed to create EAGLContext");
            return -1;
        }
        eaglContextObj = (__bridge_retained void *)newContext;
    } else {
        /* Note: We do not need to recreate the EAGLContext here if we've already created it in our constructor */
        [EAGLContext setCurrentContext:getEAGLContext()];
    }
    
    CAEAGLLayer * caeagLayer = [[CAEAGLLayer alloc] init];
    CALayer * layer = (__bridge CALayer *)window;
    caeagLayer.frame = layer.frame;
    [layer addSublayer:caeagLayer];
    /* Let's assume that the passed window is of type UIView */
    mEglWindow = caeagLayer;
    
    
    mEglWindow.opaque = YES;
    mEglWindow.drawableProperties = @{
        kEAGLDrawablePropertyRetainedBacking : [NSNumber numberWithBool:NO],
        kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8
    };
    
    if (!eaglContextObj || ![EAGLContext setCurrentContext:getEAGLContext()]) {
        LOGE("Failed to set current EAGLContext");
        return -1;
    }
    InitRenderBuffer();

    mProgramHandle = CreateProgram(g_vertexShader, g_fragmentShader);
    if (!mProgramHandle) {
        LOGE("Could not create CreateProgram");
        return -1;
    }

    LOGI("Init success.");

    return 0;
}

void RenderSurface::InitRenderBuffer()
{
    if(mEglWindow.frame.size.width == 0 && mEglWindow.frame.size.height == 0) {
        return;
    }
    if( isInitBuffer_) {
        return;
    }
    /* Set the render buffer and frame buffer */
    glGenRenderbuffers(1, &mRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, mRenderbuffer);
    if (![getEAGLContext() renderbufferStorage:GL_RENDERBUFFER fromDrawable:mEglWindow]) {
        /* Could not proceed to renderbufferStorage, returned error */
        LOGE("iOS failed to call renderbufferStorage:fromDrawable:");
        return;
    }

    /* Generate and bind the frame buffer */
    glGenFramebuffers(1, &mFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, mFramebuffer);
    /* Attach the render buffer to the frame buffer */
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, mRenderbuffer);

    GLenum frameBufferStatus = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (frameBufferStatus != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Framebuffer is not complete: %x", frameBufferStatus);
        switch (frameBufferStatus) {
            case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
                NSLog(@"Framebuffer incomplete: Attachment is NOT complete.");
                break;
            case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
                NSLog(@"Framebuffer incomplete: No image is attached to FBO.");
                break;
            /* More cases can be added to check other Framebuffer status */
            default:
                NSLog(@"Framebuffer incomplete: Unknown error.");
        }
        /* The Framebuffer was not set successfully; an error is returned */
        return;
    } else {
        /* Framebuffer is complete, proceed with rendering */
        NSLog(@"Framebuffer is complete.");
    }

    GLenum err;
    while ((err = glGetError()) != GL_NO_ERROR) {
        NSLog(@"OpenGL Error after checking framebuffer status: 0x%04X", err);
    }
    isInitBuffer_ = true;
    Update(angleX, angleY);
    return;
}

void RenderSurface::Update(float angleXOffset, float angleYOffset)
{
    const float pi = 3.141592;

    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, mSurfaceWidth, mSurfaceHeight);
    glUseProgram(mProgramHandle);

    GLint aPos = glGetAttribLocation(mProgramHandle, "a_pos");
    GLint aColor = glGetAttribLocation(mProgramHandle, "a_color");
    GLint aNormal = glGetAttribLocation(mProgramHandle, "a_normal");
    GLint uLightColor = glGetUniformLocation(mProgramHandle, "u_lightColor");
    GLint uLightDirection = glGetUniformLocation(mProgramHandle, "u_lightDirection");
    GLint aMx = glGetUniformLocation(mProgramHandle, "a_mx");
    GLint aMy = glGetUniformLocation(mProgramHandle, "a_my");

    angleX = angleXOffset;
    angleY = angleYOffset;

    /* y axis rotation */
    float radianY = (angleY * pi) / 180.0;
    float cosY = cosf(radianY);
    float sinY = sinf(radianY);
    float myArr[] = {
        cosY, 0, -sinY, 0,
        0, 1, 0, 0,
        sinY, 0, cosY, 0,
        0, 0, 0, 1
    };

    glUniformMatrix4fv(aMy, 1, false, myArr);

    /* x axis rotation */
    float radianX = (angleX * pi) / 180.0;
    float cosX = cosf(radianX);
    float sinX = sinf(radianX);
    float mxArr[] = {
        1, 0, 0, 0, 0, cosX, -sinX, 0, 0, sinX, cosX, 0, 0, 0, 0, 1
    };

    glUniformMatrix4fv(aMx, 1, false, mxArr);

    /* Passing color and orientation data to the parallel light, RGB(1,1,1), unit vector (x,y,z) */
    glUniform3f(uLightColor, 1.0, 1.0, 1.0);

    /* The vector (x,y,z) is guaranteed to have length 1, which is the unit vector */
    float x = 2.0 / sqrt(15);
    float y = 2.0 / sqrt(15);
    float z = 3.0 / sqrt(15);

    glUniform3f(uLightDirection, x, -y, z);

    /* Create a buffer and pass in the vertex position data g_vertexData */
    enableVertexAttrib(aPos, g_vertexData, sizeof(g_vertexData));
    enableVertexAttrib(aNormal, g_normalData, sizeof(g_normalData));
    /* Create a colorBuffer and pass in the vertex position data g_colorData */
    enableVertexAttrib(aColor, g_colorData, sizeof(g_colorData));

    /* Make sure you enable the depth test before you start drawing to avoid cluttering the colors */
    glEnable(GL_DEPTH_TEST);

    /* Perform the draw and update */
    glDrawArrays(GL_TRIANGLES, 0, TETRAHEDRON_POINT);

    if ([getEAGLContext() presentRenderbuffer:GL_RENDERBUFFER]) {
        LOGI("Swap buffers success.");
    } else {
        LOGE("Swap buffers failed.");
    }
}

void RenderSurface::UpdateSzie(float width, float height) {
    CGFloat scale = [UIScreen mainScreen].scale;
    mSurfaceWidth = width/scale;
    mSurfaceHeight = height/scale;
    mEglWindow.frame = CGRectMake(0, 0, mSurfaceWidth, mSurfaceHeight);
    InitRenderBuffer();
}

float RenderSurface::GetAngleX()
{
    return angleX;
}

float RenderSurface::GetAngleY()
{
    return angleY;
}

int32_t RenderSurface::Quit(void)
{
    BOOL success = YES;

    if (getEAGLContext()) {
        if (getEAGLContext() != [EAGLContext currentContext]) {
            [EAGLContext setCurrentContext:getEAGLContext()];
        }

        if ([EAGLContext currentContext] == getEAGLContext()) {
            if (mRenderbuffer) {
                glDeleteRenderbuffers(1, &mRenderbuffer);
                mRenderbuffer = 0;
            }

            if (mFramebuffer) {
                glDeleteFramebuffers(1, &mFramebuffer);
                mFramebuffer = 0;
            }
            success =  [EAGLContext setCurrentContext:nil];
            eaglContextObj = nullptr;
        }
        isInitBuffer_ = false;
    }

    if (!success) {
        LOGW("Quit failure.");
    } else {
        LOGE("Quit success.");
    }

    return success ? 0 : -1;
}
