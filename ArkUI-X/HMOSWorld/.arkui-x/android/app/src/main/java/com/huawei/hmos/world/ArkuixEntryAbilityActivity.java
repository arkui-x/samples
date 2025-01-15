/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

package com.huawei.hmos.world;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.huawei.hmos.world.bridge.BridgeAspectUtil;
import com.huawei.hmos.world.bridge.BridgeWindowUtil;

import ohos.ace.adapter.capability.bridge.BridgeManager;
import ohos.stage.ability.adapter.StageActivity;

/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 2025-01-07
 */
public class ArkuixEntryAbilityActivity extends StageActivity {
    static Context context;

    static BridgeManager bridgeManager;

    private final String TAG = "[ArkuixEntryAbilityActivity]";

    private void initBridgeObject() {
        context = this;
        bridgeManager = getBridgeManager();
        new BridgeAspectUtil(context, "AspectUtil", bridgeManager);
        new BridgeWindowUtil(context, "WindowUtil", bridgeManager);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.i(TAG, "onCreate called");
        initBridgeObject();
        setInstanceName("com.huawei.hmos.world:arkuix:EntryAbility:");
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, 100);
        }
        super.onCreate(savedInstanceState);
    }
}
