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

package com.example.platformnapi;

import android.os.Build;
import android.content.Context;

/**
 * Native side method class
 *
 * @since 2025-01-15
 */
public class DeviceInfo {
    /**
     * Func constructor
     *
     * @param context Context of the current DeviceInfo
     * @since 2025-01-07
     */
    public DeviceInfo(Context context) {
        nativeInit();
    }

    /**
     * Func getDeviceBrand
     *
     * @return Build MODEL
     * @since 2025-01-07
     */
    public String getProductModel() {
        return Build.MODEL;
    }

    /**
     * Func getDeviceBrand
     *
     * @return Device Brand
     * @since 2025-01-07
     */
    public String getDeviceBrand() {
        return Build.BRAND;
    }

    /**
     * Func nativeInit 注册插件的初始化方法，供插件构造函数调用
     *
     * @since 2025-01-07
     */
    protected native void nativeInit();
}
