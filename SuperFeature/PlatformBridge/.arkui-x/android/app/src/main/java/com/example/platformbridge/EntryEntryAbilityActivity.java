/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
package com.example.platformbridge;

import android.os.Bundle;

import ohos.ace.adapter.capability.bridge.BridgePlugin;
import ohos.ace.adapter.capability.bridge.TaskOption;
import ohos.stage.ability.adapter.StageActivity;

/**
 * Example ace activity class, which will load ArkUI-X ability instance.
 * StageActivity is provided by ArkUI-X
 * @see <a href=
 * "https://gitee.com/arkui-crossplatform/doc/blob/master/contribute/tutorial/how-to-build-Android-app.md">
 * to build android library</a>
 */
public class EntryEntryAbilityActivity extends StageActivity {
    private Bridge bridgeImpl = null;

    private Bridge bridgeCodec = null;

    private Bridge BridgeTask = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        bridgeImpl = new Bridge(this, "Bridge", getBridgeManager());
        bridgeCodec = new Bridge(this, "BridgeCodec", getBridgeManager(), BridgePlugin.BridgeType.BINARY_TYPE);
        BridgeTask = new Bridge(
            this, "BridgeTask", getBridgeManager(), BridgePlugin.BridgeType.BINARY_TYPE, new TaskOption());
        setInstanceName("com.example.platformbridge:entry:EntryAbility:");
        super.onCreate(savedInstanceState);
    }
}
