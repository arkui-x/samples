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
import android.view.View;

import com.amap.api.maps.TextureMapView;

import ohos.ace.adapter.capability.platformview.IPlatformView;

/**
 * MyMapView.
 *
 * @since 20
 */
public class MyMapView implements IPlatformView {
    TextureMapView mMapView;
    private String id = "MapView";

    public MyMapView(Context context, Bundle savedInstanceState) {
        mMapView = new TextureMapView(context);
        mMapView.onCreate(savedInstanceState);
    }

    @Override
    public View getView() {
        return mMapView;
    }

    @Override
    public void onDispose() {
        mMapView.onDestroy();
    }

    @Override
    public String getPlatformViewID() {
        return id;
    }
}
