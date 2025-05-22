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

import com.example.enjoyarkuix.platformbridge.Bridge;

import ohos.ace.adapter.capability.bridge.BridgePlugin;
import ohos.ace.adapter.capability.bridge.TaskOption;
import ohos.stage.ability.adapter.StageActivity;

/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 *
 * @since 20
 */
public class PlatformBridgePlatformBridgeAbilityActivity extends StageActivity {
    private Bridge bridgeImpl = null;

    private Bridge bridgeCodec = null;

    private Bridge bridgeTask = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setInstanceName("com.example.enjoyarkuix:PlatformBridge:PlatformBridgeAbility:");
        super.onCreate(savedInstanceState);
        platFormBridge();
    }

    public void platFormBridge() {
        bridgeImpl = new Bridge(this, "Bridge", getBridgeManager());
        bridgeCodec = new Bridge(this, "BridgeCodec", getBridgeManager(), BridgePlugin.BridgeType.BINARY_TYPE);
        bridgeTask = new Bridge(this, "BridgeTask", getBridgeManager(), BridgePlugin.BridgeType.BINARY_TYPE, new TaskOption());
    }
}
