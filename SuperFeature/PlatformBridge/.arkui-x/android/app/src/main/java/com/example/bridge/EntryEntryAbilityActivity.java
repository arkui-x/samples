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

package com.example.bridge;

import android.os.Bundle;
import android.util.Log;

import ohos.ace.adapter.capability.bridge.BridgePlugin;
import ohos.stage.ability.adapter.StageActivity;

/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 2025-10-20
 */
public class EntryEntryAbilityActivity extends StageActivity {
    private static final String TAG = "LOG";

    private static final String LOG_TAG = "[Native]:: ";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.i(TAG, LOG_TAG + "EntryEntryAbilityActivity onCreate");
        setInstanceName("com.example.bridge:entry:EntryAbility:");
        super.onCreate(savedInstanceState);
        BridgeManager.getInstance().get("BridgeJsonObject", BridgePlugin.BridgeType.JSON_TYPE);
        BridgeManager.getInstance().get("BridgeBinaryObject", BridgePlugin.BridgeType.BINARY_TYPE);
    }

    @Override
    protected void onStop() {
        Log.i(TAG, LOG_TAG + "EntryEntryAbilityActivity onStop");
        super.onStop();
        finish();
    }

    @Override
    protected void onDestroy() {
        Log.i(TAG, LOG_TAG + "EntryEntryAbilityActivity onDestroy");
        super.onDestroy();
    }
}
