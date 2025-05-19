/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

package com.example.enjoyarkuix.platformview;

import android.content.Context;
import android.os.Bundle;

import ohos.ace.adapter.capability.platformview.IPlatformView;
import ohos.ace.adapter.capability.platformview.PlatformViewFactory;

/**
 * MyPlatformViewFactory.
 *
 * @since 20
 */
public class MyPlatformViewFactory extends PlatformViewFactory {
    private Context context;
    private Bundle savedInstanceState;

    @Override
    public IPlatformView getPlatformView(String id) {
        if ("MapView".equals(id)) {
            return new MyMapView(context, savedInstanceState);
        } else if ("WebView".equals(id)) {
            return new MyWebView(context);
        } else if ("VideoView".equals(id)) {
            return new MyVideoView(context);
        }
        return null;
    }

    public void setContext(Context context) {
        this.context = context;
    }

    public void setSavedInstanceState(Bundle savedInstanceState) {
        this.savedInstanceState = savedInstanceState;
    }
}
