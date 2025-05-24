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

package com.example.enjoyarkuix;

import android.os.Bundle;

import com.amap.api.location.AMapLocationClient;
import com.amap.api.maps.MapsInitializer;
import com.example.enjoyarkuix.platformview.MyPlatformViewFactory;

import ohos.stage.ability.adapter.StageActivity;

/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 20
 */
public class PlatformViewPlatformViewAbilityActivity extends StageActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setInstanceName("com.example.enjoyarkuix:PlatformView:PlatformViewAbility:");
        super.onCreate(savedInstanceState);
        platFormView(savedInstanceState);
    }

    /**
     * platFormView
     *
     * @param savedInstanceState savedInstanceState
     */
    public void platFormView(Bundle savedInstanceState) {
        AMapLocationClient.updatePrivacyShow(this, true, true);
        AMapLocationClient.updatePrivacyAgree(this, true);
        MapsInitializer.updatePrivacyShow(this, true, true);
        MapsInitializer.updatePrivacyAgree(this, true);
        MyPlatformViewFactory platformViewFactory = new MyPlatformViewFactory();
        platformViewFactory.setContext(this);
        platformViewFactory.setSavedInstanceState(savedInstanceState);
        registerPlatformViewFactory(platformViewFactory);
    }
}
